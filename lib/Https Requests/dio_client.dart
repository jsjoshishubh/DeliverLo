import 'dart:developer';
import 'package:deliverylo/Commons%20and%20Reusables/loader.dart';
import 'package:deliverylo/Https%20Requests/server_configs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';

final xApiKey = 'qwertyuiop12345zxcvbnmkjh:U2FsdGVkX1/NsFV/wfHncKBib6chJ7JGhfJyt9aSv/ltg0s/P/NaMtyNM7tSiB78clryjyNDUxlNwLeS/O5AlSXoL3x+rVxpetSQJYyjoiA9miQ99RKT7VaRhJBUFDXk+DfeyvsUNpUr6jw0sMZwyANc429j3cRp+Ow7QsLp2Uq33GxJJ2MYzd1hFrg7sfDDRGHLiZaR3V2eXryzqj0GSA==';

class DioClient {
  static final baseUrl = ApibaseUrl;
  static BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    responseType: ResponseType.json,
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
    contentType: 'application/json',
    
  );

  static Dio addInterceptors(Dio dio,{bool? isFormImageUpload = false}) {
    final storage = GetStorage();
    bool isllogedin = true;
    Map<String, dynamic> map = isFormImageUpload == true ? {
      'Accept': 'application/json'
    } :{
      'contentType': 'application/json',
      'Accept': 'application/json'
    };
    if (isllogedin) {
      final jwtToken = storage.read('token');
      map.update('Authorization', (v) => "Bearer ${jwtToken}", ifAbsent: () => "Bearer ${jwtToken}");
    }
    opts.headers = map;
    Dio dio = new Dio(opts);
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          return handler.next(response); // continue
        },
        onError: (DioException e, handler) async {
          print('dio client err - ${e.type} -- ${e.response} - ${e.response?.statusCode} -- ${dio.options.baseUrl} -- ${dio.options.queryParameters}');
          handler.next(e);
        },
      ),
    );
    return dio;
  }

  static final dio = Dio(opts);

  Future<Response> getRequest(String url, [dynamic params]) async {
    try {
      
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
      log('get url -- ${url} -- ${params} ---- ${baseRequest}');
      Response response = await baseRequest.get(url, queryParameters: params);
      return response;
    } on DioException catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }

  Future<Response> postRequest(String url, {dynamic data, bool? showLoading = false,BuildContext? context}) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
      log('post url -- ${url} -- ${data}');
      Response response = await baseRequest.post(url, data: data);
      return response;
    } on DioError catch (e) {
      log('eee -- ${e.message}');
      // Handle error
      return Future.error(e is CustomResponse ? e : getFormattedResponse(e));
    }
  }

  Future<Response> imageUploadTOS3postRequest(String url, {dynamic data, bool? showLoading = false,BuildContext? context}) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio,isFormImageUpload: true);
      Response response = await baseRequest.post(url, data: data);
      return response;
    } on DioError catch (e) {
      // log('eee -- ${e.message}');
      return Future.error(e is CustomResponse ? e : getFormattedResponse(e));
    }
  }

  Future<Response> patchRequest(String url, {dynamic data}) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
            print('patch url -- ${url} -- ${data}');
      Response response = await baseRequest.patch(url, data: data);
      return response;
    } on DioException catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e.response.toString():getFormattedResponse(e));
    }
  }

  Future<Response> putRequest(String url, [dynamic data]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
      print('put url -- ${url} -- ${data}');
      Response response = await baseRequest.put(url, data: data);
      return response;
    } on DioException catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }

  Future<Response> deleteRequest(String url, [dynamic data]) async {
    try {
      await checkNetworkConnetion();
      final baseRequest = addInterceptors(dio);
      log('base requestt ----- ${baseRequest}');
       print('delete url -- ${url} -- ${data}');
      Response response = await baseRequest.delete(url, data: data);
      return response;
    } on DioException catch (e) {
      // Handle error
      return Future.error(e is CustomResponse ? e:getFormattedResponse(e));
    }
  }
}

class CustomResponse {
  int? statusCode;
  dynamic? message;
  dynamic? error;
  CustomResponse({this.statusCode,this.message,this.error});
  
  factory CustomResponse.fromJson(Map<String,dynamic> json) => CustomResponse(
    statusCode: json['code'] ?? json['statusCode'],
    message: json['errorMessage'] ?? json['message'],
    error: json['error'] ?? json['errors'],
  );
}

networkErrorResponse(){
  return new CustomResponse.fromJson({'code': 502, 'errorMessage': 'no_network'.tr, 'error': 'no_network'.tr});
}

getFormattedResponse(res){
 try{
   final response = res.response;
  final statusCode = response?.statusCode;
  final responseData = response?.data;

  if ([DioExceptionType.receiveTimeout, DioExceptionType.connectionTimeout].contains(res.type)) {
     return CustomResponse.fromJson({
       'code': 422,
       'errorMessage': 'connection timeout, please try again',
       'error': 'connection timeout, please try again'
     });
  }

  if (responseData is Map<String, dynamic>) {
    return CustomResponse.fromJson({
      'code': statusCode ?? responseData['code'] ?? responseData['statusCode'],
      'errorMessage': responseData['message'] ?? responseData['errorMessage'] ?? 'Something went wrong',
      'error': responseData['error'] ?? responseData['errors'] ?? responseData,
    });
  }

  if (responseData is String) {
    return CustomResponse.fromJson({
      'code': statusCode,
      'errorMessage': responseData,
      'error': responseData,
    });
  }

  if(statusCode == 401){
    // showSnackBar(message: 'Authorization Denied, please login again.',isError: true);
    // onClearLocalSetup();
    return CustomResponse.fromJson(response.data);
  }else if(statusCode == 422){
    return CustomResponse.fromJson({'code': 422, 'errorMessage': response.data['errorMessage'], 'error': response.data['error'] ?? 'server error, please try again'});
  }
  return CustomResponse.fromJson({'code': statusCode, 'errorMessage': 'Something went wrong', 'error': responseData});
 }catch(er){
  print('e -- ${er}');
  return CustomResponse.fromJson({
    'code': 500,
    'errorMessage': 'Something went wrong',
    'error': er.toString(),
  });
 }
}

checkNetworkConnetion() async{
    final isOnline = true;
    // if(!isOnline){
    //   final cc = networkErrorResponse();
    //   return Future.error(cc);
    // }
}
