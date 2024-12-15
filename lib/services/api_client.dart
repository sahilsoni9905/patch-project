
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;


class ApiClient extends GetxService {
  late dio.Dio _dio;
  var options = dio.BaseOptions(
    baseUrl: "https://fakestoreapi.com",
  );



  ApiClient() {
        _dio = dio.Dio(options);
        _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response); 
      },
      onError: (DioException e, handler) async {
        print('Error received: ${e.response?.statusCode} ${e.response?.data}');
        handler.next(e);
      },
    ));
  }
    

  Future<ApiClient> init() async {
  
    return this;
  }


  Future loadProducts({
    required Function(dynamic resp) onSuccess,
    required Function(dynamic error) onError,
    Map requestData = const {},
  }) async {
    try {
      var response = await _dio.get("/products?limit=50." , data: requestData);
      if (response.statusCode == 200) {
        onSuccess(response.data);
      } else {
        throw Exception('Something Went Wrong!');
      }
    } catch (e) {
      onError('Something Went Wrong!');
    }
  }
}
