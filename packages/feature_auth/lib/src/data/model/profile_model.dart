import 'package:feature_auth/src/domain/entity/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
@JsonSerializable()
class ProfileModel with _$ProfileModel {
  const ProfileModel({
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
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  final String? bio;

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  static ProfileModel fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
