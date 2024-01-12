part of 'otp_cubit.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {
  @override
  List<Object> get props => [];
}

class OtpLoading extends OtpState {}

class OtpLoginSuccessFull extends OtpState {
  //save user data
  // final UserSession userSession;
  // final int? isCompany;
  // final bool? isCompleted;
  final String msge;
  OtpLoginSuccessFull(this.msge);
}


class OtpFailed extends OtpState {

  //show error
  final String msg;
  OtpFailed(this.msg);
}

class ResendOtpLoading extends OtpState {}

class ResendOtpLoginSuccessFull extends OtpState {
  //save user data
  // final UserSession userSession;
  // final int? isCompany;
  // final bool? isCompleted;
  final String otp;
  ResendOtpLoginSuccessFull(this.otp);
}

class ResendOtpFailed extends OtpState {

  //show error
  final String msg;
  ResendOtpFailed(this.msg);
}