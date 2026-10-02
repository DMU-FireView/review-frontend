import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/notifications/domain/repositories/notification_repository.dart';
import 'package:re_view_front/features/notifications/presentation/providers/notification_providers.dart';
import 'package:re_view_front/features/notifications/presentation/view_models/notification_list_state.dart';

class NotificationListViewModel extends Notifier<NotificationListState> {
  static const _pageSize = 20;

  NotificationRepository get _repository =>
      ref.read(notificationRepositoryProvider);

  @override
  NotificationListState build() {
    Future.microtask(refresh);
    return const NotificationListState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.getNotifications(page: 0, size: _pageSize);
    if (!ref.mounted) return;
    result.when(
      success: (page) => state = NotificationListState(
        items: page.items,
        page: 0,
        isLast: page.isLast,
      ),
      failure: (f) =>
          state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
    ref.invalidate(unreadNotificationCountProvider);
  }

  Future<void> loadMore() async {
    if (state.isLast || state.isLoading || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true);
    final next = state.page + 1;
    final result = await _repository.getNotifications(
      page: next,
      size: _pageSize,
    );
    if (!ref.mounted) return;
    result.when(
      success: (page) => state = state.copyWith(
        items: [...state.items, ...page.items],
        page: next,
        isLast: page.isLast,
        isLoadingMore: false,
      ),
      failure: (f) =>
          state = state.copyWith(isLoadingMore: false, errorMessage: f.message),
    );
  }

  UnreadNotificationCount get _unreadCount =>
      ref.read(unreadNotificationCountProvider.notifier);

  /// 화면과 배지를 먼저 바꾸고, 서버 요청이 실패하면 그 알림만 되돌린다.
  /// 배지는 화면이 사라져도 남는 provider라 이동 직후에도 맞게 유지된다.
  Future<void> markRead(int id) async {
    if (!state.items.any((n) => n.id == id && !n.isRead)) return;
    _setRead({id}, read: true);
    _unreadCount.adjust(-1);

    final result = await _repository.markRead(id);
    if (!ref.mounted) return;
    result.when(
      success: (_) {},
      failure: (f) {
        _setRead({id}, read: false);
        _unreadCount.adjust(1);
        state = state.copyWith(errorMessage: f.message);
      },
    );
  }

  Future<void> markAllRead() async {
    final unreadIds = {
      for (final n in state.items)
        if (!n.isRead) n.id,
    };
    if (unreadIds.isEmpty) return;
    _setRead(unreadIds, read: true);
    _unreadCount.clear();

    final result = await _repository.markAllRead();
    if (!ref.mounted) return;
    result.when(
      success: (_) {},
      failure: (f) {
        _setRead(unreadIds, read: false);
        ref.invalidate(unreadNotificationCountProvider);
        state = state.copyWith(errorMessage: f.message);
      },
    );
  }

  /// [ids]에 해당하는 알림만 읽음 상태를 바꾼다. 그 사이 불러온 항목은 그대로 둔다.
  void _setRead(Set<int> ids, {required bool read}) {
    state = state.copyWith(
      items: [
        for (final n in state.items)
          if (ids.contains(n.id)) n.withRead(read) else n,
      ],
    );
  }
}
