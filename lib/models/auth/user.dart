class User {
  String? message;
  String? id;
  String? username;
  String? mobileNo;
  String? activationKey;
  String? deviceId;
  String? modelId;
  String? otp;
  String? status;

  User({
    this.message,
    this.id,
    this.username,
    this.mobileNo,
    this.activationKey,
    this.deviceId,
    this.modelId,
    this.otp,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    message: json["message"],
    id: json["id"],
    username: json["username"],
    mobileNo: json["mobile_no"],
    activationKey: json["activation_key"],
    deviceId: json["device_id"],
    modelId: json["model_id"],
    otp: json["otp"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "id": id,
    "username": username,
    "mobile_no": mobileNo,
    "activation_key": activationKey,
    "device_id": deviceId,
    "model_id": modelId,
    "otp": otp,
    "status": status,
  };
}


/*class UserSession {
  String? lastLogin;
  String? token;
  String? userId;
  String? role;
  String? districtId;

  UserSession(
      {
        this.lastLogin,
        this.token,
        this.userId,
        this.role,
        this.districtId
      });

  UserSession.fromJson(Map<String, dynamic> json) {
    lastLogin = json['lastLogin'];
    token = json['token'];
    userId = json['userId'];
    role = json['role'];
    districtId = json['districtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastLogin'] = this.lastLogin;
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['districtId'] = this.districtId;
    return data;
  }
}*/

/*class UserProfile {
  String? id;
  String? name;
  String? address;
  String? email;
  String? phone;
  String? password;
  String? businessName;
  String? businessEmail;
  String? businessPhone;
  String? pincode;
  String? districtId;
  String? gstin;
  String? code;

  UserProfile(
      {this.id,
        this.name,
        this.address,
        this.email,
        this.phone,
        this.password,
        this.businessName,
        this.businessEmail,
        this.businessPhone,
        this.pincode,
        this.districtId,
        this.gstin,
        this.code});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    businessName = json['businessName'];
    businessEmail = json['businessEmail'];
    businessPhone = json['businessPhone'];
    pincode = json['pincode'];
    districtId = json['districtId'];
    gstin = json['gstin'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['businessName'] = this.businessName;
    data['businessEmail'] = this.businessEmail;
    data['businessPhone'] = this.businessPhone;
    data['pincode'] = this.pincode;
    data['districtId'] = this.districtId;
    data['gstin'] = this.gstin;
    data['code'] = this.code;
    return data;
  }
}*/




