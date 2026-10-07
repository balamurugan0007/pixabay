import 'package:pixabay/core/network/status/Status_consts.dart';

class ResponseModel {
  final StatusConsts status;
  final String? errorMsg;
  final dynamic data;

  ResponseModel({this.data, this.errorMsg, required this.status});
}
