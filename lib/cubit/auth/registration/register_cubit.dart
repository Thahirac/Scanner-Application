import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:result_type/result_type.dart';

import '../../../helpers/repository/registration_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {


  final RegistrationRepository registrationRepository;
  RegisterCubit(this.registrationRepository) : super(RegisterInitial());



  Future<void> authenticateUser(String? username,String? mobileNumber,String? deviceId, String? modelId) async {

    emit(RegistrationLoading());
    Result? result = await registrationRepository.registerUser(username,mobileNumber,deviceId,modelId);

    if (result.isSuccess) {

      // User userSession = User.fromJson(result.success);
      // UserManager.instance.setUserSession(userSession);

      log('&&&&&&&&&&&&&&&&&      &&&&&&&&&&&&&&${result.success}');


      emit(RegistrationLoginSuccessFull(result.success));
    } else {
      emit(RegistrationFailed(result.failure));
    }
  }



}