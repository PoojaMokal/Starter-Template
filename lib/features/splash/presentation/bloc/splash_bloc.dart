import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState.initial()) {
    on<SplashStarted>(_onStarted);
  }

  static const Duration splashDuration = Duration(seconds: 2);

  Future<void> _onStarted(SplashStarted event, Emitter<SplashState> emit) async {
    // TODO: add startup checks here (remote config, force update, session).
    await Future<void>.delayed(splashDuration);
    emit(const SplashState.navigateToLogin());
  }
}
