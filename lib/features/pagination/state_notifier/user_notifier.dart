import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_template_riverpod/injectable/injectable.dart';

import '../../../services/web_service/api_service.dart';
import '../model/user_model.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<UserModel>>>(
      (ref) => getIt<UserNotifier>(),
    );

@injectable
class UserNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final ApiService apiService;

  int _page = 0;
  final int _limit = 15;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // UserNotifier(this.apiService) : super(const AsyncValue.loading()) {
  //   loadUsers(reset: true);
  // }

  UserNotifier(this.apiService) : super(const AsyncValue.loading());

  Future<void> loadUsers({bool reset = false}) async {
    if (_isLoadingMore || !_hasMore) return;

    if (reset) {
      _page = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    } else {
      _isLoadingMore = true;
      state = AsyncValue.data([...state.value ?? []]); // keep current list
    }

    final skip = _page * _limit;
    try {
      await Future.delayed(Duration(seconds: 1));

      final response = await apiService.getUsers(_limit, skip);

      if (response.users.isEmpty) {
        _hasMore = false;
      } else {
        final newList = reset
            ? response.users
            : [...(state.value ?? <UserModel>[]), ...response.users];
        state = AsyncValue.data(newList);
        _page++;
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
}
