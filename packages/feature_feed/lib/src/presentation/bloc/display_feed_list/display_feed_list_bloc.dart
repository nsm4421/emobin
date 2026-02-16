import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/core/errors/feed_failure_mapper.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'display_feed_list_bloc.freezed.dart';
part 'display_feed_list_event.dart';
part 'display_feed_list_state.dart';

@injectable
class DisplayFeedListBloc
    extends Bloc<DisplayFeedListEvent, DisplayFeedListState> {
  DisplayFeedListBloc(this._feedUseCase) : super(const DisplayFeedListState()) {
    on<DisplayFeedListEvent>(_onEvent);
  }

  final FeedUseCase _feedUseCase;
  StreamSubscription<List<FeedEntry>>? _entriesSubscription;
  bool _initialized = false;

  Future<void> _onEvent(
    DisplayFeedListEvent event,
    Emitter<DisplayFeedListState> emit,
  ) async {
    await event.when(
      started: () async {
        if (_initialized) return;
        _initialized = true;

        emit(
          state.copyWith(status: DisplayFeedListStatus.loading, failure: null),
        );
        await _refresh(emit, showLoading: false);
        await _bindLocalEntriesStream();
      },
      refreshRequested: (showLoading) async {
        await _refresh(emit, showLoading: showLoading);
      },
      entriesUpdated: (entries) async {
        emit(
          state.copyWith(
            status: DisplayFeedListStatus.success,
            entries: entries,
            failure: null,
          ),
        );
      },
      streamErrorOccurred: (error, stackTrace) async {
        emit(
          state.copyWith(
            status: DisplayFeedListStatus.failure,
            failure: error.toFeedFailure(stackTrace),
          ),
        );
      },
    );
  }

  Future<void> _refresh(
    Emitter<DisplayFeedListState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) {
      emit(
        state.copyWith(status: DisplayFeedListStatus.loading, failure: null),
      );
    }

    final result = await _feedUseCase.fetchLocalEntries();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: DisplayFeedListStatus.failure, failure: failure),
      ),
      (entries) => emit(
        state.copyWith(
          status: DisplayFeedListStatus.success,
          entries: entries,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _bindLocalEntriesStream() async {
    await _entriesSubscription?.cancel();
    _entriesSubscription = _feedUseCase.observeLocalEntries().listen(
      (entries) => add(DisplayFeedListEvent.entriesUpdated(entries)),
      onError: (Object error, StackTrace stackTrace) {
        add(DisplayFeedListEvent.streamErrorOccurred(error, stackTrace));
      },
    );
  }

  @override
  Future<void> close() async {
    await _entriesSubscription?.cancel();
    return super.close();
  }
}
