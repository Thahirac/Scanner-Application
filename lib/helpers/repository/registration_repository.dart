// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:result_type/result_type.dart';
import '../managers/shared_preference_manager.dart';
import '../managers/user_manager.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_base_helper_service.dart';
import '../networking/endpoints.dart';
import '../response/response.dart';
import 'authentication_repository.dart';


abstract class RegistrationRepository extends  UserAuthenticationRepository{
  Future<Result> registerUser(String? username,String? mobile_number,String? device_id, String? model_id);

}

class UserRegRepository extends RegistrationRepository {
  // ApiBaseHelper _helper = ApiBaseHelper();
  ApiBaseHelperService _helper = ApiBaseHelperService();

  @override
  Future<Result> registerUser(String? username,String? mobileNumber,String? deviceId, String? modelId) async {
    String responseString =
    await (_helper.post(APIEndPoints.urlString(EndPoints.registration),
        {
        "name": username,
        "mobile": mobileNumber,
        "device_id":deviceId,
        "model_id":modelId
        }
    ));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == "1") {


      String otp = response.otp.toString();

      /// Saving the Id
      String token = response.id.toString();
      UserManager.instance.setToken(token);

      UserManager.instance.setUserLoggedIn(true);

      /// Saving the DeviceId
      String deviceID = response.deviceId.toString();
      saveDeviceId(deviceID);

      /// Saving the ModalId
      String modalId = response.modalId.toString();
      saveModalId(modalId);

      //log('*************TOKEN***********$token');
      // String username = response.username.toString();
      // saveUsername(username.toString());
      //
      //
      // String mobilenumber = response.mobilenumber.toString();
      // saveMobilenumber(mobilenumber.toString());
      //
      // print("**************************Username************************$username");
      //
      // print("**************************mobilenumber********************$mobilenumber");


      log('********************SUCCESS RESPONSE********************${response.message}');
      log('********************SUCCESS RESPONSE********************${otp}');


      return Success(otp);
    } else {
      log('********************FAILURE RESPONSE     ********************${response.message}');
      return Failure(response.message);
    }
  }


}