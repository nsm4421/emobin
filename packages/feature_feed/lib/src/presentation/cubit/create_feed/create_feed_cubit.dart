import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'create_feed_cubit.freezed.dart';
part 'create_feed_state.dart';

@injectable
class CreateFeedCubit extends Cubit<CreateFeedState> {
  CreateFeedCubit(this._feedUseCase) : super(const CreateFeedState());

  final FeedUseCase _feedUseCase;

  Future<void> submit(FeedEntryDraft draft) async {
    emit(
      state.copyWith(
        status: CreateFeedStatus.submitting,
        createdEntry: null,
        failure: null,
      ),
    );

    final result = await _feedUseCase.createLocalEntry(draft);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateFeedStatus.failure,
          createdEntry: null,
          failure: failure,
        ),
      ),
      (entry) => emit(
        state.copyWith(
          status: CreateFeedStatus.success,
          createdEntry: entry,
          failure: null,
        ),
      ),
    );
  }

  void reset() {
    emit(const CreateFeedState());
  }
}
