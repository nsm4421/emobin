import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/core/errors/feed_failure_mapper.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'display_feed_list_bloc.freezed.dart';

part 'display_feed_list_event.dart';

part 'display_feed_list_state.dart';

@injectable
class DisplayFeedListBloc
    extends Bloc<DisplayFeedListEvent, DisplayFeedListState> {
  DisplayFeedListBloc(FeedUseCase feedUseCase)
    : super(const DisplayFeedListState()) {
    _useCase = feedUseCase.fetchLocalEntries;
    on<DisplayFeedListEvent>(_onEvent);
  }

  static const int _pageSize = 20;

  late final FetchLocalFeedEntriesUseCase _useCase;
  bool _initialized = false;

  Future<void> _onEvent(
    DisplayFeedListEvent event,
    Emitter<DisplayFeedListState> emit,
  ) async {
    await event.when(
      started: () async {
        if (_initialized) return;
        _initialized = true;

        await _refresh(emit, showLoading: true);
      },
      refreshRequested: (showLoading) async {
        await _refresh(emit, showLoading: showLoading);
      },
      entriesUpdated: (_) async {},
      streamErrorOccurred: (error, stackTrace) async {
        emit(
          state.copyWith(
            status: DisplayFeedListStatus.failure,
            failure: error.toFeedFailure(stackTrace),
            isLoadingMore: false,
          ),
        );
      },
      loadMoreRequested: () async {
        if (state.isLoadingMore || !state.hasMore) {
          return;
        }
        emit(state.copyWith(isLoadingMore: true, failure: null));

        final result = await _useCase(
          limit: _pageSize,
          offset: state.entries.length,
        );
        if (isClosed) return;

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: DisplayFeedListStatus.failure,
              failure: failure,
              isLoadingMore: false,
            ),
          ),
          (nextEntries) => emit(
            state.copyWith(
              status: DisplayFeedListStatus.success,
              entries: [...state.entries, ...nextEntries],
              hasMore: nextEntries.length == _pageSize,
              isLoadingMore: false,
              failure: null,
            ),
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
        state.copyWith(
          status: DisplayFeedListStatus.loading,
          failure: null,
          isLoadingMore: false,
        ),
      );
    }

    final result = await _useCase(limit: _pageSize);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DisplayFeedListStatus.failure,
          failure: failure,
          isLoadingMore: false,
        ),
      ),
      (entries) => emit(
        state.copyWith(
          status: DisplayFeedListStatus.success,
          entries: entries,
          failure: null,
          hasMore: entries.length == _pageSize,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
