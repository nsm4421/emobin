import 'package:feature_auth/src/data/datasource/auth_datasource.dart';
import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}
