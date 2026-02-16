import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const AuthUser({
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
  final DateTime createdAt;

  @override
  final DateTime? updatedAt;

  @override
  final Map<String, dynamic> userMetadata;
}
