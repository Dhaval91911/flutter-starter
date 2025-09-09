// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:luuverr_project/injectable/injectable.dart';
// import 'package:luuverr_project/main.dart';
// import 'package:luuverr_project/utils/get_storage/get_storage.dart';
// import 'package:luuverr_project/utils/pref_util.dart';
//
// class TokenInterceptor implements Interceptor {
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     handler.next(err);
//   }
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final token = isNewToken.value ? getIt<StorageService>().get(createNewUserToken) : getIt<StorageService>().get(userToken);
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//
//     handler.next(options);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     handler.next(response);
//   }
//
//   String encoder(dynamic value) {
//     try {
//       return JsonEncoder.withIndent(" " * 4).convert(value);
//     } catch (e) {
//       return value;
//     }
//   }
// }

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:starter_template_riverpod/core/shared_pref/shared_pref.dart';

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
    final token = getIt<SharedPrefService>().getString('userToken');
    if (token != null) {
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
