class Response {

  String? id;
  String? username;
  String? mobilenumber;
  String? status;
  String? message;
  String? deviceId;
  String? modalId;
  String? user;
  String? otp;
  String? contentpath;


  Response({this.id,this.username, this.mobilenumber,this.status,this.message,this.deviceId,this.user,this.modalId,this.otp,this.contentpath,});

  Response.fromJson(Map<String, dynamic> json) {
     id = json['userid'];
     username = json['username'];
     mobilenumber = json['mobile'];
     status = json['status'];
     message = json['message'];
     deviceId = json["device_id"];
     user = json["user"];
     modalId = json["model_id"];
     otp = json["otp"];
     contentpath =  json["final_path"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.id;
    data['username'] = this.username;
    data['mobile'] = this.mobilenumber;
    data['status'] = this.status;
    data['message'] = this.message;
    data["device_id"] = this.deviceId;
    data["user"] = this.user;
    data["model_id"] = this.modalId;
    data["otp"] = this.otp;
    data["final_path"] = this.contentpath;
    return data;
  }
}

