import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const Profile({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  final String id;

  @override
  final String username;

  @override
  final String? avatarUrl;

  @override
  final String? bio;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;
}
