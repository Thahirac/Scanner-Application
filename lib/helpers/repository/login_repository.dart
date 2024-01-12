// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:result_type/result_type.dart';
import '../managers/user_manager.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_base_helper_service.dart';
import '../networking/endpoints.dart';
import '../response/response.dart';
import 'authentication_repository.dart';

abstract class LoginRepository extends UserAuthenticationRepository {
  Future<Result> authenticateUser(String? mobileNumber,String? deviceId, String? modelId);
}

class UserLoginRepository extends LoginRepository {
  // ApiBaseHelper _helper = ApiBaseHelper();
  ApiBaseHelperService _helper = ApiBaseHelperService();

  @override
  Future<Result> authenticateUser(String? mobileNumber,String? deviceId, String? modelId) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.login),
        {
          "mobile": mobileNumber,
          "device_id": deviceId,
          "model_id": modelId
        }
        ));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == "1") {


      /// Saving the Username
      String username = response.username.toString();
      saveUsername(username.toString());

      /// Saving the MobileNumber
      String mobilenumber = response.mobilenumber.toString();
      saveMobilenumber(mobilenumber.toString());

      UserManager.instance.setUserLoggedIn(true);

      String otp = response.otp.toString();

      /// Saving the Id
      String token = response.id.toString();
      UserManager.instance.setToken(token);

      /// Saving the DeviceId
      String deviceID = response.deviceId.toString();
      saveDeviceId(deviceID);

      /// Saving the ModalId
      String modalId = response.modalId.toString();
      saveModalId(modalId);



      log('*************TOKEN***********$deviceID');

      print("**************************Username************************$username");

      print("**************************mobilenumber********************$mobilenumber");

      log('********************SUCCESS RESPONSE********************${response.message}');


      return Success(otp);
    } else {
      print(response.message);
      return Failure(response.message);
    }
  }



}