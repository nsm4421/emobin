import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/get_feed_entry_by_id_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'detail_feed_cubit.freezed.dart';
part 'detail_feed_state.dart';

@injectable
class DetailFeedCubit extends Cubit<DetailFeedState> {
  DetailFeedCubit(FeedUseCase feedUseCase, @factoryParam String feedId)
    : _feedId = feedId,
      super(const DetailFeedState.loading()) {
    _getByIdUseCase = feedUseCase.getById;
    unawaited(load());
  }

  final String _feedId;
  late final GetLocalFeedEntryByIdUseCase _getByIdUseCase;

  Future<void> load() async {
    emit(const DetailFeedState.loading());

    final result = await _getByIdUseCase.call(_feedId);
    if (isClosed) return;

    result.fold((failure) => emit(DetailFeedState.failure(failure)), (entry) {
      if (entry == null) {
        emit(const DetailFeedState.notFound());
        return;
      }

      emit(DetailFeedState.loaded(entry));
    });
  }
}
