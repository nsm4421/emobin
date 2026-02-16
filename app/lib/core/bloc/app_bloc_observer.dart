import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    AppLogger.log('bloc.create bloc=${bloc.runtimeType}', level: LogLevel.info);
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    AppLogger.log(
      'bloc.event bloc=${bloc.runtimeType} event=${event.runtimeType}',
      level: LogLevel.debug,
    );
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    AppLogger.log(
      'bloc.transition '
      'bloc=${bloc.runtimeType} '
      'current=${transition.currentState.runtimeType} '
      'event=${transition.event.runtimeType} '
      'next=${transition.nextState.runtimeType}',
      level: LogLevel.debug,
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.log(
      'bloc.error bloc=${bloc.runtimeType}',
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    AppLogger.log('bloc.close bloc=${bloc.runtimeType}', level: LogLevel.info);
    super.onClose(bloc);
  }
}
