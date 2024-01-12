import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'app_exception.dart';

class ApiBaseHelperService {
  Map<String, String> commonHeaders = {'Content-Type': 'application/json'};

  Future<dynamic> post(String url, dynamic body) async {
    log('Api Post, url: $url');

    var responseJson;

    const r = RetryOptions(maxAttempts: 5);

    final response = await r.retry(
      () => http
          .post(Uri.parse(url), body: json.encode(body), headers: commonHeaders)
          .timeout(const Duration(minutes: 1)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    responseJson = _returnResponse(response);

    log("------------------------track lineStart---------------------------");
    log("------------------------track line--------------------------------");
    log("------------------------track line--------------------------------");
    log("------------------------track  End--------------------------------");

    log('*****************************RESPONSE BODY: ${response.body}');

    return responseJson;
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return response.body.toString();
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
