import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

import '../../../helpers/repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  // int? isCompany;
  // bool? isCompleted;


  final LoginRepository loginRepository;
  LoginCubit(this.loginRepository) : super(LoginInitial());



  Future<void> authenticateUser(String? mobileNumber,String? deviceId, String? modelId) async {
    emit(LoginLoading());
    Result? result = await loginRepository.authenticateUser(mobileNumber,deviceId,modelId);

    if (result.isSuccess) {
      // UserSession userSession = UserSession.fromJson(result.success);
      // UserManager.instance.setUserSession(userSession);

      log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${result.success}');

      emit(LoginSuccessFull(result.success));
    }
    else {
      emit(LoginFailed(result.failure));
    }
  }

}