import 'package:flutter/foundation.dart';

@immutable
class FeedProfileModel {
  final String id;
  final String username;
  final String? avatarUrl;

  const FeedProfileModel({
    required this.id,
    required this.username,
    this.avatarUrl,
  });

  static const Object _unset = Object();

  FeedProfileModel copyWith({
    String? id,
    String? username,
    Object? avatarUrl = _unset,
  }) {
    return FeedProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl == _unset ? this.avatarUrl : avatarUrl as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
    };
  }

  factory FeedProfileModel.fromMap(Map<String, dynamic> map) {
    return FeedProfileModel(
      id: map['id'] as String,
      username: map['username'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String? ?? map['avatarUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedProfileModel &&
        other.id == id &&
        other.username == username &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => Object.hash(id, username, avatarUrl);
}
