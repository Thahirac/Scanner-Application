part of 'auth_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationIntial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthentionSuccess extends AuthenticationState {
  final String? user;


  AuthentionSuccess(this.user,);
}

class AuthenticationFailed extends AuthenticationState {

  final String? msg;


  AuthenticationFailed(this.msg,);

}