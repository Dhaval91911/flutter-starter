import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:starter_template_riverpod/core/shared_pref/shared_pref.dart';
import 'package:starter_template_riverpod/core/shared_pref/storage_keys.dart';

import '../../injectable/injectable.dart';

class TokenInterceptor implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data is Map<String, dynamic>) {
      final errorData = err.response!.data;

      if (errorData['success'] == false && errorData['statuscode'] == 101) {
        handleBlockedAccount(errorData['message']);
      }
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getIt<SharedPrefService>().getString(StorageKeys.userToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data;

      if (data['success'] == false && data['statuscode'] == 101) {
        handleBlockedAccount(data['message']);
      }
    }

    handler.next(response);
  }

  void handleBlockedAccount(String msg) {
    // CommonApiCall().blockLogout(userJson["_id"]);
    // GlobalSnackBar.show(msg);
  }

  String encoder(dynamic value) {
    try {
      return JsonEncoder.withIndent(' ' * 4).convert(value);
    } catch (e) {
      return value;
    }
  }
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    required int maxRetries,
    required Duration initialBackoff,
    required double backoffMultiplier,
    required Duration maxBackoff,
  })  : _dio = dio,
        _maxRetries = maxRetries,
        _initialBackoff = initialBackoff,
        _backoffMultiplier = backoffMultiplier,
        _maxBackoff = maxBackoff;

  final Dio _dio;
  final int _maxRetries;
  final Duration _initialBackoff;
  final double _backoffMultiplier;
  final Duration _maxBackoff;

  static const _idempotentMethods = {'GET', 'HEAD', 'OPTIONS'};

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final method = requestOptions.method.toUpperCase();
    final isIdempotent = _idempotentMethods.contains(method);
    final shouldRetry = _shouldRetry(err) && isIdempotent;

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    final attempt = (requestOptions.extra['retry_attempt'] as int?) ?? 0;
    if (attempt >= _maxRetries) {
      handler.next(err);
      return;
    }

    final backoff = _computeBackoff(attempt);
    await Future<void>.delayed(backoff);

    final Options opts = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      validateStatus: requestOptions.validateStatus,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
    );

    try {
      final newOptions = requestOptions.copyWith(
        extra: Map<String, dynamic>.from(requestOptions.extra)..['retry_attempt'] = attempt + 1,
      );
      final Response response = await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: opts.copyWith(
          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
          extra: newOptions.extra,
        ),
        cancelToken: requestOptions.cancelToken,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
      );
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response != null && error.response!.statusCode != null && error.response!.statusCode! >= 500);
  }

  Duration _computeBackoff(int attempt) {
    final double factor = _backoffMultiplier <= 1 ? 2.0 : _backoffMultiplier;
    final int millis = (_initialBackoff.inMilliseconds * (factor * attempt + 1)).toInt();
    final jitter = (millis * 0.2).toInt();
    final value = millis + (jitter * (DateTime.now().millisecondsSinceEpoch % 2 == 0 ? 1 : -1));
    final duration = Duration(milliseconds: value.clamp(0, _maxBackoff.inMilliseconds));
    return duration;
  }
}
