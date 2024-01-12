part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccessFull extends LoginState {
  //save user data
  // final UserSession userSession;
  // final int? isCompany;
  // final bool? isCompleted;
  final String otp;
  LoginSuccessFull(/*this.userSession,this.isCompany,this.isCompleted*/this.otp);
}

class LoginFailed extends LoginState {
  //show error
  final String msg;
  LoginFailed(this.msg);
}