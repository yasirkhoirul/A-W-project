part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class OnLoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const OnLoginWithEmailEvent({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
}

class OnLoginWithGoogleEvent extends AuthEvent {
  const OnLoginWithGoogleEvent();
}

class OnSignUpEvent extends AuthEvent {
  final UserEntities data;
  
  const OnSignUpEvent(this.data);
  
  @override
  List<Object?> get props => [data];
}

class OnLoginInstantEvent extends AuthEvent {
  const OnLoginInstantEvent();
}

class OnLogoutEvent extends AuthEvent {
  const OnLogoutEvent();
}