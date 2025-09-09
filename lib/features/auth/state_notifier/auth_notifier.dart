import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_template_riverpod/core/widgets/constant_widgets.dart';
import 'package:starter_template_riverpod/core/widgets/custome_toast.dart';

import '../../../injectable/injectable.dart';
import '../../../services/web_service/api_service.dart';
import '../model/signup_request_model.dart';
import '../model/signup_response_model.dart';

final authNotifierProvider = StateNotifierProvider.autoDispose<AuthNotifier, AsyncValue<UserData?>>((ref) {
  return getIt<AuthNotifier>();
});

@injectable
class AuthNotifier extends StateNotifier<AsyncValue<UserData?>> {
  final ApiService apiService;

  AuthNotifier(this.apiService) : super(const AsyncValue.data(null));

  Future<void> signUp({required SignupRequestModel request, bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }

      final response = await apiService.signUp(request);

      if (response.success != null && response.success == true && response.data != null) {
        state = AsyncValue.data(response.data);
        showStyledToast(response.message ?? 'Sign up successful', ToastType.success);
      } else {
        state = AsyncValue.error(Exception(response.message), StackTrace.current);
        showStyledToast(response.message ?? 'Sign up failed', ToastType.error);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      showStyledToast('Sign up failed. Please try again.', ToastType.error);
    } finally {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
    }
  }

  void clearAuthState() {
    state = const AsyncValue.data(null);
  }

  void setUser(UserData user) {
    state = AsyncValue.data(user);
  }
}
