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

  /// 화면에서 먼저 읽음 처리하고, 서버 요청이 실패하면 되돌린다.
  Future<void> markRead(int id) async {
    final before = state.items;
    if (!before.any((n) => n.id == id && !n.isRead)) return;
    state = state.copyWith(
      items: [for (final n in before) n.id == id ? n.markedRead() : n],
    );
    final result = await _repository.markRead(id);
    if (!ref.mounted) return;
    result.when(
      success: (_) => ref.invalidate(unreadNotificationCountProvider),
      failure: (f) =>
          state = state.copyWith(items: before, errorMessage: f.message),
    );
  }

  Future<void> markAllRead() async {
    final before = state.items;
    if (!state.hasUnread) return;
    state = state.copyWith(items: [for (final n in before) n.markedRead()]);
    final result = await _repository.markAllRead();
    if (!ref.mounted) return;
    result.when(
      success: (_) => ref.invalidate(unreadNotificationCountProvider),
      failure: (f) =>
          state = state.copyWith(items: before, errorMessage: f.message),
    );
  }
}
