import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/admin/domain/repositories/admin_user_repository.dart';
import 'package:re_view_front/features/admin/presentation/providers/admin_user_providers.dart';
import 'package:re_view_front/features/admin/presentation/view_models/admin_user_state.dart';

class AdminUserViewModel extends Notifier<AdminUserState> {
  AdminUserRepository get _repository => ref.read(adminUserRepositoryProvider);

  /// 페이지를 빠르게 넘길 때 늦게 온 이전 페이지 응답을 버리기 위한 번호.
  int _request = 0;

  @override
  AdminUserState build() {
    Future.microtask(loadList);
    return const AdminUserState(isLoading: true);
  }

  /// [page]를 불러온다. 성공했을 때만 현재 페이지를 바꿔, 실패해도 표시 중인
  /// 목록과 페이지 번호가 어긋나지 않게 한다.
  Future<void> loadList({int? page}) async {
    final targetPage = page ?? state.page;
    final request = ++_request;
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.getUsers(
      page: targetPage,
      size: state.pageSize,
    );
    if (!ref.mounted || request != _request) return;
    result.when(
      success: (data) => state = state.copyWith(
        items: data.items,
        page: targetPage,
        totalPages: data.totalPages,
        totalElements: data.totalElements,
        isLoading: false,
      ),
      failure: (f) =>
          state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
  }

  void changePage(int page) => loadList(page: page);
}
