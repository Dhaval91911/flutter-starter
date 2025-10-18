import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
    final hasInternet = await InternetConnection().hasInternetAccess;
    if (hasInternet) {
      handler.next(options);
      return;
    }

    handler.reject(
      DioException(
        requestOptions: options,
        error: 'No Internet Connection',
        type: DioExceptionType.connectionError,
      ),
      true,
    );
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
