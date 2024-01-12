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


abstract class OtpRepository extends  UserAuthenticationRepository{
  Future<Result> otpverification(String? otp,String? deviceId, String? modelId, String? mobileNumber,String? id);
  Future<Result> resentotp(String? id,String? mobileNumber);

}

class UserOtpRepository extends OtpRepository {
  // ApiBaseHelper _helper = ApiBaseHelper();
  ApiBaseHelperService _helper = ApiBaseHelperService();

  @override
  Future<Result> otpverification(String? otp,String? deviceId, String? modelId, String? mobileNumber,String? id) async {
    String responseString = await (_helper.post(APIEndPoints.urlString(EndPoints.otp),
        {
        "otp": otp,
        "device_id": deviceId,
        "model_id": modelId,
        "mobile": mobileNumber,
          "id": id,
        }
    ));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == "1") {


      /// Saving the Username
      String username = response.username.toString();
      saveUsername(username.toString());

      /// Saving the MobileNumber
      String mobilenumber = response.mobilenumber.toString();
      saveMobilenumber(mobilenumber .toString());

      UserManager.instance.setUserLoggedIn(true);

/*      /// Saving the DeviceId
      String deviceID = response.deviceId.toString();
      saveDeviceId(deviceID);

      /// Saving the ModalId
      String modalId = response.modalId.toString();
      saveModalId(modalId);


      log('*************TOKEN***********$deviceId');*/

      print("**************************Username************************$username");

      print("**************************mobilenumber********************$mobilenumber");

      log('********************SUCCESS RESPONSE********************${response.message}');



      return Success(response.message);
    } else {
      log('********************FAILURE RESPONSE********************${response.message}');
      return Failure(response.message);
    }
  }

  @override
  Future<Result> resentotp(String? id,String? mobileNumber) async {
    String responseString = await (_helper.post(APIEndPoints.urlString(EndPoints.resendotp),
        {
          "id": id,
          "mobile": mobileNumber,
        }
    ));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == "1") {

      String otp = response.otp.toString();

      ///New code
      return Success(otp);
    } else {
      log('********************FAILURE RESPONSE********************${response.message}');
      return Failure(response.message);
    }
  }


}