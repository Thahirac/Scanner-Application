enum EndPoints {
  registration,
  login,
  otp,
  resendotp,
  checkuseranddevice,
  contentpathfetch,
}

class APIEndPoints {
  ///development
  //static String baseUrl = "http://";

  ///Live
  static String baseUrl = "http://";

  static String urlString(EndPoints endPoint) {
    return baseUrl + endPoint.endPointString;
  }
}


extension EndPointsExtension on EndPoints {
  String get endPointString {
    switch (this) {
      case EndPoints.registration:
        return "RegisterForm.php";
      case EndPoints.login:
        return "loginForm.php";
      case EndPoints.otp:
        return "otpconfirm.php";
      case EndPoints.resendotp:
        return "ResendOTP.php";
      case EndPoints.checkuseranddevice:
        return "old_users_login.php";
      case EndPoints.contentpathfetch:
        return "contentpath_fetch.php";
    }
  }
}
