import 'package:feature_auth/src/core/constants/auth_status.dart';
import 'package:feature_auth/src/domain/usecase/scenario/observe_auth_state_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('ObserveAuthStateUseCase', () {
    late MockAuthRepository repository;
    late ObserveAuthStateUseCase useCase;

    setUp(() {
      repository = MockAuthRepository();
      useCase = ObserveAuthStateUseCase(repository);
    });

    test('인증 상태 스트림을 그대로 반환한다', () async {
      final payloads = [
        (status: AuthStatus.unknown, user: null),
        (status: AuthStatus.authenticated, user: buildAuthUser()),
        (status: AuthStatus.unauthenticated, user: null),
      ];

      when(
        () => repository.authStatus(),
      ).thenAnswer((_) => Stream.fromIterable(payloads));

      final result = useCase();

      await expectLater(result, emitsInOrder([...payloads, emitsDone]));
      verify(() => repository.authStatus()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
