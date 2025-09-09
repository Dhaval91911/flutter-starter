import 'dart:io';

import 'package:dio/dio.dart';

class ConnectivityInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check for internet connection
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Internet connection is available, proceed with the request
        handler.next(options);
      }
    } on SocketException catch (_) {
      // Fluttertoast.showToast(msg: 'No Internet Connection');
      // Loader.hide();
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'No Internet Connection',
          type: DioExceptionType.cancel,
        ),
        true,
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
