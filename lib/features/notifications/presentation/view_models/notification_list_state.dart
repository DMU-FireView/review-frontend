import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';

class NotificationListState {
  const NotificationListState({
    this.items = const [],
    this.page = 0,
    this.isLast = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final List<AppNotification> items;

  /// 마지막으로 불러온 페이지 번호.
  final int page;
  final bool isLast;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get hasUnread => items.any((n) => !n.isRead);

  NotificationListState copyWith({
    List<AppNotification>? items,
    int? page,
    bool? isLast,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationListState(
      items: items ?? this.items,
      page: page ?? this.page,
      isLast: isLast ?? this.isLast,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
