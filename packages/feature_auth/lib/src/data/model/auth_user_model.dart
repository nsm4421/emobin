import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
@JsonSerializable()
class AuthUserModel with _$AuthUserModel {
  const AuthUserModel({
    required this.id,
    this.email,
    this.phone,
    required this.createdAt,
    this.updatedAt,
    this.userMetadata = const <String, dynamic>{},
  });

  @override
  final String id;

  @override
  final String? email;

  @override
  final String? phone;

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  @JsonKey(
    readValue: _readUserMetadata,
    fromJson: _metadataFromJson,
    toJson: _metadataToJson,
  )
  final Map<String, dynamic> userMetadata;

  static AuthUserModel fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);
}

Object? _readUserMetadata(Map json, String key) {
  return json['user_metadata'] ?? json['raw_user_meta_data'];
}

Map<String, dynamic> _metadataFromJson(Object? value) {
  if (value is Map<String, dynamic>) {
    return Map<String, dynamic>.from(value);
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const {};
}

Object? _metadataToJson(Map<String, dynamic> value) => value;
