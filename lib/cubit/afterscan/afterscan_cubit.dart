import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

import '../../../helpers/repository/authentication_repository.dart';
import '../../helpers/repository/afterscan_repository.dart';

part 'afterscan_state.dart';

//after push
class AfterscanCubit extends Cubit<AfterscanState> {

  final AfterscanRepository afterscanRepository;

  AfterscanCubit(AfterscanState state, this.afterscanRepository) : super(AfterscanIntial());




  Future<void> afterscan(String? id,String? filename) async {
    emit(AfterscanLoading());
    Result? result = await afterscanRepository.afterscan(id,filename);

    if (result.isSuccess) {

      log('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${result.success}');

      emit(AfterscanSuccess(result.success));
    }
    else {
      emit(AfterscanFailed(result.failure));
    }
  }


}