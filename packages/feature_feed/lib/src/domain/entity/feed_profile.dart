import 'package:flutter/foundation.dart';

@immutable
class FeedProfile {
  final String id;
  final String username;
  final String? avatarUrl;

  const FeedProfile({required this.id, required this.username, this.avatarUrl});

  static const Object _unset = Object();

  FeedProfile copyWith({
    String? id,
    String? username,
    Object? avatarUrl = _unset,
  }) {
    return FeedProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl == _unset ? this.avatarUrl : avatarUrl as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedProfile &&
        other.id == id &&
        other.username == username &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => Object.hash(id, username, avatarUrl);
}
