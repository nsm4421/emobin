import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/hard_delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/update_feed_entry_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'feed_trash_cubit.freezed.dart';

part 'feed_trash_state.dart';

@injectable
class FeedTrashCubit extends Cubit<FeedTrashState> {
  FeedTrashCubit(FeedUseCase feedUseCase) : super(const FeedTrashState()) {
    _fetchEntriesUseCase = feedUseCase.fetchLocalEntries;
    _updateEntryUseCase = feedUseCase.updateLocalEntry;
    _hardDeleteEntryUseCase = feedUseCase.hardDeleteLocalEntry;
  }

  late final FetchLocalFeedEntriesUseCase _fetchEntriesUseCase;
  late final UpdateLocalFeedEntryUseCase _updateEntryUseCase;
  late final HardDeleteLocalFeedEntryUseCase _hardDeleteEntryUseCase;

  Future<void> load() async {
    emit(state.copyWith(status: FeedTrashStatus.loading, failure: null));

    final result = await _fetchEntriesUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: FeedTrashStatus.failure, failure: failure),
      ),
      (entries) {
        final deletedEntries =
            entries
                .where((entry) => entry.deletedAt != null)
                .toList(growable: false)
              ..sort((a, b) => b.deletedAt!.compareTo(a.deletedAt!));

        emit(
          state.copyWith(
            status: FeedTrashStatus.success,
            entries: deletedEntries,
            failure: null,
          ),
        );
      },
    );
  }

  Future<Either<FeedFailure, void>> restoreEntry(FeedEntry entry) async {
    _setBusy(entry.id, true);

    final result = await _updateEntryUseCase(entry.copyWith(deletedAt: null));
    if (isClosed) return result.fold(left, (_) => const Right(null));

    result.fold((_) {}, (_) {
      final nextEntries = state.entries
          .where((item) => item.id != entry.id)
          .toList(growable: false);
      emit(state.copyWith(entries: nextEntries));
    });

    _setBusy(entry.id, false);
    return result.fold(left, (_) => const Right(null));
  }

  Future<Either<FeedFailure, void>> hardDeleteEntry(String id) async {
    _setBusy(id, true);

    final result = await _hardDeleteEntryUseCase(id);
    if (isClosed) return result;

    result.fold((_) {}, (_) {
      final nextEntries = state.entries
          .where((item) => item.id != id)
          .toList(growable: false);
      emit(state.copyWith(entries: nextEntries));
    });

    _setBusy(id, false);
    return result;
  }

  void _setBusy(String id, bool value) {
    if (isClosed) return;

    if (value) {
      emit(state.copyWith(busyEntryIds: {...state.busyEntryIds, id}));
      return;
    }

    emit(
      state.copyWith(
        busyEntryIds: state.busyEntryIds.where((item) => item != id).toSet(),
      ),
    );
  }
}
