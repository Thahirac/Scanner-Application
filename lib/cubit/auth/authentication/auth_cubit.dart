import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

import '../../../helpers/repository/authentication_repository.dart';

part 'auth_state.dart';

//after push
class AuthenticationCubit extends Cubit<AuthenticationState> {

  final AuthenticationRepository authRepository;

  AuthenticationCubit(AuthenticationState state, this.authRepository) : super(AuthenticationIntial());




  Future<void> getoneUseroneDevice(String? mobileNumber,String? deviceId,String? modalId) async {
    emit(AuthenticationLoading());
    Result? result = await authRepository.getoneuseronedevice(mobileNumber,deviceId,modalId);

    if (result.isSuccess) {

      log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${result.success}');

      emit(AuthentionSuccess(result.success));
    }
    else {
      emit(AuthenticationFailed(result.failure));
    }
  }


}