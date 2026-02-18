import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/defaults.dart';
import '../../../core/constants/keys.dart';

part 'feed_hashtag_preset_state.dart';

part 'feed_hashtag_preset_cubit.freezed.dart';

@injectable
class FeedHashtagPresetCubit extends Cubit<FeedHashtagPresetState> {
  FeedHashtagPresetCubit(this._sharedPreferences)
    : super(const FeedHashtagPresetState.idle());

  final SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    emit(FeedHashtagPresetState.loading(state.hashtags));

    final exists = _sharedPreferences.containsKey(
      SettingPreferenceKeys.feedHashtagPreset,
    );
    if (!exists) {
      await _sharedPreferences.setStringList(
        SettingPreferenceKeys.feedHashtagPreset,
        SettingDefaults.feedHashtagPresets,
      );
    }

    final saved =
        _sharedPreferences.getStringList(
          SettingPreferenceKeys.feedHashtagPreset,
        ) ??
        const <String>[];
    emit(FeedHashtagPresetState.fetched(saved, failure: null));
  }

  Future<void> addHashtag(String hashtag) async {
    await _update([...state.hashtags, hashtag]);
  }

  Future<void> removeHashtag(String hashtag) async {
    await _update(
      state.hashtags
          .where((h) => h.trim().toLowerCase() != hashtag.trim().toLowerCase())
          .toList(growable: false),
    );
  }

  Future<void> _update(List<String> hashtags) async {
    final cleaned = hashtags
        .map((hashtag) => hashtag.trim())
        .where((hashtag) => hashtag.isNotEmpty)
        .toList(growable: false);
    final normalized = cleaned.map((hashtag) => hashtag.toLowerCase()).toSet();
    final isDuplicated = normalized.length != cleaned.length;
    if (isDuplicated) {
      emit(
        FeedHashtagPresetState.fetched(
          state.hashtags,
          failure: 'Duplicate hashtags are not allowed.',
        ),
      );
      return;
    }

    emit(FeedHashtagPresetState.loading(state.hashtags));

    await _sharedPreferences.setStringList(
      SettingPreferenceKeys.feedHashtagPreset,
      cleaned,
    );

    emit(FeedHashtagPresetState.fetched(cleaned, failure: null));
  }
}
