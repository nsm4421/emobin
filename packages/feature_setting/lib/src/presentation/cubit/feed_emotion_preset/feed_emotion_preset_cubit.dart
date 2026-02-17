import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/defaults.dart';
import '../../../core/constants/keys.dart';

part 'feed_emotion_preset_state.dart';

part 'feed_emotion_preset_cubit.freezed.dart';

@injectable
class FeedEmotionPresetCubit extends Cubit<FeedEmotionPresetState> {
  FeedEmotionPresetCubit(this._sharedPreferences)
    : super(const FeedEmotionPresetState.idle());

  final SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    emit(FeedEmotionPresetState.loading(state.emotions));

    final exists = _sharedPreferences.containsKey(
      SettingPreferenceKeys.feedEmotionPreset,
    );
    if (!exists) {
      await _sharedPreferences.setStringList(
        SettingPreferenceKeys.feedEmotionPreset,
        SettingDefaults.feedEmotionPresets,
      );
    }

    final saved =
        _sharedPreferences.getStringList(
          SettingPreferenceKeys.feedEmotionPreset,
        ) ??
        const <String>[];
    emit(FeedEmotionPresetState.fetched(saved, failure: null));
  }

  Future<void> addEmotion(String emotion) async {
    _update([...state.emotions, emotion]);
  }

  Future<void> removeEmotion(String emotion) async {
    _update(
      state.emotions
          .map((e) => e.trim().toLowerCase())
          .where((e) => e != emotion.trim().toLowerCase())
          .toList(growable: false),
    );
  }

  Future<void> _update(List<String> emotions) async {
    final cleaned = emotions
        .map((emotion) => emotion.trim())
        .where((emotion) => emotion.isNotEmpty)
        .toList(growable: false);
    final normalized = emotions.map((emotion) => emotion.toLowerCase()).toSet();
    final isDuplicated = normalized.length != emotions.length;
    if (isDuplicated) {
      emit(
        FeedEmotionPresetState.fetched(
          state.emotions,
          failure: 'Duplicate emotions are not allowed.',
        ),
      );
      return;
    }

    emit(FeedEmotionPresetState.loading(state.emotions));

    await _sharedPreferences.setStringList(
      SettingPreferenceKeys.feedEmotionPreset,
      cleaned,
    );

    emit(FeedEmotionPresetState.fetched(cleaned, failure: null));
  }
}
