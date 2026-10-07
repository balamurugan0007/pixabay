

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pixabay/core/network/status/Status_consts.dart';
import 'package:pixabay/core/network/status/responseModel.dart';

class BaseApi {




  Future<ResponseModel> get(String endpoint) async {
    final response = await http.get(
      Uri.parse(endpoint),
    );

    return _handleResponse(response);
  }

  Future<ResponseModel> post(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Uint8List?> getRawBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    }
    return null;
  }

  ResponseModel _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return ResponseModel(status: StatusConsts.SUCESS , data: data) ;
    }

    return ResponseModel(status: StatusConsts.ERROR , errorMsg: data['message'] ?? 'Something went wrong');
  }
}