import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:result_type/result_type.dart';

import '../../../helpers/repository/otp_repository.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {

  final OtpRepository otpverificationRepository;
  OtpCubit(this.otpverificationRepository) : super(OtpInitial());



  Future<void> otpauthenticateUser(String? otp,String? deviceId, String? modelId, String? mobileNumber,String id) async {

    emit(OtpLoading());
    Result? result = await otpverificationRepository.otpverification(otp,deviceId, modelId,mobileNumber,id);

    if (result.isSuccess) {

      // User userSession = User.fromJson(result.success);
      // UserManager.instance.setUserSession(userSession);

      log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${result.success}');

      emit(OtpLoginSuccessFull(result.success));
    } else {
      emit(OtpFailed(result.failure));
    }
  }


  Future<void> resentOtp(String id, String? mobileNumber) async {

    emit(ResendOtpLoading());
    Result? result = await otpverificationRepository.resentotp(id,mobileNumber);

    if (result.isSuccess) {

      // User userSession = User.fromJson(result.success);
      // UserManager.instance.setUserSession(userSession);

      log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${result.success}');

      emit(ResendOtpLoginSuccessFull(result.success));
    } else {
      emit(ResendOtpFailed(result.failure));
    }
  }


}