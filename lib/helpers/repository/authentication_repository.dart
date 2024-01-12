import 'dart:convert';
import 'dart:developer';

import 'package:result_type/result_type.dart';


import '../../models/auth/user.dart';
import '../managers/shared_preference_manager.dart';
import '../managers/user_manager.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_base_helper_service.dart';
import '../networking/endpoints.dart';
import '../response/response.dart';

abstract class AuthenticationRepository {


  Future<Result> getoneuseronedevice(String? mobileNumber,String? deviceId,String? modalId);
  Future<void> saveDeviceId(String deviceId);
  Future<void> saveModalId(String modalId);
  Future<String> getModalId();
  Future<String> getDeviceId();
  Future<void> saveUsername(String  is_userName);
  Future<String> getUserName();
  Future<void> saveMobilenumber(String mobileNumber);
  Future<String> getMobilenumber();
  Future<Result> logoutUser();



}

class UserAuthenticationRepository extends AuthenticationRepository {

  // ApiBaseHelper _helper = ApiBaseHelper();
  ApiBaseHelperService _helper = ApiBaseHelperService();


  @override
  Future<Result> getoneuseronedevice(String? mobileNumber,String? deviceId,String? modalId) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.checkuseranddevice),
        {
          "mobile": mobileNumber,
          "device_id": deviceId,
          "model_id": modalId
        }));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == "1") {

      /// Saving the Username
      String username = response.username.toString();
      saveUsername(username.toString());

      /// Saving the MobileNumber
      String mobilenumber = response.mobilenumber.toString();
      saveMobilenumber(mobilenumber.toString());

      UserManager.instance.setUserLoggedIn(true);

      /// Saving the DeviceId
      String deviceID = response.deviceId.toString();
      saveDeviceId(deviceID);

      /// Saving the ModalId
      String modalId = response.modalId.toString();
      saveModalId(modalId);


      log('*************TOKEN***********$deviceId');

      print("**************************Username************************$username");

      print("**************************mobilenumber********************$mobilenumber");

      log('********************SUCCESS RESPONSE********************${response.message}');


      return Success(response.user);
    } else {

      return Failure(response.message);
    }
  }


  @override
  Future<String> getDeviceId() {
    return SharedPreferenceManager.instance.getValueFor("deviceId");
  }


  @override
  Future<String> getModalId() {
    return SharedPreferenceManager.instance.getValueFor("modalId");
  }

  @override
  Future<String> getUserName() {
    return SharedPreferenceManager.instance.getValueFor("is_userName");
  }

  @override
  Future<String> getMobilenumber() {
    return SharedPreferenceManager.instance.getValueFor("mobile_number");
  }

  @override
  Future<Result> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }


  @override
  Future<void> saveDeviceId(String deviceId) async {
    SharedPreferenceManager.instance.setValue("deviceId", deviceId);
  }

  @override
  Future<void> saveModalId(String modalId) async {
    SharedPreferenceManager.instance.setValue("modalId", modalId);
  }

  @override
  Future<void> saveUsername(String  is_userName) async {
    SharedPreferenceManager.instance.setValue("is_userName", is_userName);
  }

  @override
  Future<void> saveMobilenumber(String mobileNumber) async {
    SharedPreferenceManager.instance.setValue("mobile_number", mobileNumber);
  }


}