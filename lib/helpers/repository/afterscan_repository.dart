// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:result_type/result_type.dart';
import '../networking/api_base_helper.dart';
import '../networking/api_base_helper_service.dart';
import '../networking/endpoints.dart';
import '../response/response.dart';

abstract class AfterscanRepository  {
  Future<Result> afterscan(String? id,String? filename);
}

class AfterScanRepository extends AfterscanRepository {
 // ApiBaseHelper _helper = ApiBaseHelper();
  ApiBaseHelperService _helper = ApiBaseHelperService();

  @override
  Future<Result> afterscan(String? id,String? filename) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.contentpathfetch),
        {
          "id":id,
          "file_name": filename,
        }));
    Response response = Response.fromJson(json.decode(responseString));

    if (response.status == "1") {

      log('********************SUCCESS RESPONSE********************${response.contentpath}');


      return Success(response.contentpath);
    } else {
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:${response.message}");
      return Failure(response.message);
    }
  }



}