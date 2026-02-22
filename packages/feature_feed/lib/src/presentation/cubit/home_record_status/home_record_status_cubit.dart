import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_record_status_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_record_status_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

part 'home_record_status_cubit.freezed.dart';

part 'home_record_status_state.dart';

@lazySingleton
class HomeRecordStatusCubit extends Cubit<HomeRecordStatusState> {
  HomeRecordStatusCubit(FeedUseCase feedUseCase)
    : _fetchRecordStatusUseCase = feedUseCase.fetchLocalRecordStatus,
      _observeRecordStatusUseCase = feedUseCase.observeLocalRecordStatus,
      _fetchEntriesUseCase = feedUseCase.fetchLocalEntries,
      super(const HomeRecordStatusState());

  final FetchLocalFeedRecordStatusUseCase _fetchRecordStatusUseCase;
  final ObserveLocalFeedRecordStatusUseCase _observeRecordStatusUseCase;
  final FetchLocalFeedEntriesUseCase _fetchEntriesUseCase;
  StreamSubscription? _subscription;

  Future<void> initialize() async {
    await refresh(showLoading: true);
    _subscription ??= _observeRecordStatusUseCase().listen((recordStatus) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, recordStatus: recordStatus));
    });
  }

  Future<void> refresh({bool showLoading = false}) async {
    if (showLoading) {
      emit(state.copyWith(isLoading: true));
    }

    final result = await _fetchRecordStatusUseCase();
    if (isClosed) return;

    result.fold((_) => emit(state.copyWith(isLoading: false)), (recordStatus) {
      emit(state.copyWith(isLoading: false, recordStatus: recordStatus));
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  Future<Either<FeedFailure, List<FeedEntry>>> fetchDraftEntries() async {
    final result = await _fetchEntriesUseCase();
    if (isClosed) return result;

    return result.map(
      (entries) => entries
          .where((entry) => entry.isDraft && entry.deletedAt == null)
          .toList(growable: false),
    );
  }
}
