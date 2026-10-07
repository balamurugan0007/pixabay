import 'package:pixabay/core/network/api/ApiRoutes.dart';
import 'package:pixabay/core/network/api/base_api.dart';
import 'package:pixabay/core/network/status/Status_consts.dart';
import 'package:pixabay/core/network/status/responseModel.dart';
import 'package:pixabay/features/Images/data/model/PixabayResponse.dart';

class ImagesRepository {
  final _baseApi = BaseApi();

  
  Future<PixabayResponse?> getImages({int page = 1}) async {
    try {
      final url =
          '${ApiRoutes.baseURL}?key=${ApiRoutes.apiKey}&image_type=photo&pretty=true&page=$page&per_page=20';
      ResponseModel response = await _baseApi.get(url);
      if (response.status == StatusConsts.SUCESS) {
        return PixabayResponse.fromJson(response.data);
      } else {
        throw Exception(response.errorMsg ?? 'Something went wrong');
      }
    } catch (e) {
      throw Exception('Parse error: $e');
    }
  }
}