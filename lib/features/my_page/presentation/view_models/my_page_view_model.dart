import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/my_page/presentation/providers/my_page_providers.dart';
import 'package:re_view_front/features/my_page/presentation/view_models/my_page_state.dart';

class MyPageViewModel extends Notifier<MyPageState> {
  @override
  MyPageState build() {
    ref.listen<bool>(isLoggedInProvider, (_, next) {
      if (next) {
        Future.microtask(load);
      }
    });
    Future.microtask(load);
    return const MyPageLoading();
  }

  Future<void> load() async {
    if (!ref.mounted) return;

    state = const MyPageLoading();
    final result = await ref.read(getMyProfileUseCaseProvider)();
    if (!ref.mounted) return;

    state = result.when(
      success: (profile) {
        if (profile.nickname.isNotEmpty) {
          ref
              .read(authTokenStoreProvider.notifier)
              .saveNickname(profile.nickname);
        }
        return MyPageSuccess(profile);
      },
      failure: MyPageFailure.new,
    );
  }
}
