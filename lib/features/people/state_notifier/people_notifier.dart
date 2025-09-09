import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:starter_template_riverpod/core/widgets/constant_widgets.dart';
import 'package:starter_template_riverpod/core/widgets/custome_toast.dart';

import '../../../injectable/injectable.dart';
import '../../../services/web_service/api_service.dart';
import '../../people/model/people_model.dart';

final peopleNotifierProvider = StateNotifierProvider.autoDispose<PeopleNotifier, AsyncValue<List<PeopleModel>>>((ref) {
  return getIt<PeopleNotifier>();
});

@injectable
class PeopleNotifier extends StateNotifier<AsyncValue<List<PeopleModel>>> {
  final ApiService apiService;

  PeopleNotifier(this.apiService) : super(const AsyncValue.loading());

  Future<void> loadPeoples({bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }
      final data = await apiService.getPeoples();
      state = AsyncValue.data(data.users);
      showStyledToast('Get data', ToastType.success);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      showStyledToast('Error fetching people', ToastType.error);
    } finally {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
    }
  }
}
