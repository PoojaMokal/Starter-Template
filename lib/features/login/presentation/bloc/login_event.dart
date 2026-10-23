part of 'login_bloc.dart';

@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.submitted({
    required String userId,
    required String password,
  }) = LoginSubmitted;
}
