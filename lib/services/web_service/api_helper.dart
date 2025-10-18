import 'package:dio/dio.dart';

import '../../core/widgets/constant_widgets.dart';
import '../../core/widgets/custome_toast.dart';

/// Generic API call wrapper to centralize loading and error handling.
Future<T> performApiCall<T>({
  required Future<T> Function() request,
  required T Function(Object error) buildDefaultOnError,
  bool showLoading = true,
  String networkErrorMessage = 'Something went wrong. Please check your connection.',
}) async {
  try {
    if (showLoading) showProgressIndicator();
    final result = await request();
    return result;
  } on DioException catch (error) {
    showStyledToast(networkErrorMessage, ToastType.error);
    return buildDefaultOnError(error);
  } catch (e) {
    showStyledToast(networkErrorMessage, ToastType.error);
    return buildDefaultOnError(e);
  } finally {
    if (showLoading) dismissProgressIndicator();
  }
}
