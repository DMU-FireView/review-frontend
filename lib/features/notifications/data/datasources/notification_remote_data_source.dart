import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/notifications/data/dtos/app_notification_dto.dart';
import 'package:re_view_front/features/notifications/domain/entities/app_notification.dart';

abstract interface class NotificationRemoteDataSource {
  Future<NotificationPage> getNotifications({
    required int page,
    required int size,
  });

  Future<int> getUnreadCount();

  Future<void> markRead(int id);

  Future<void> markAllRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  String get _base => _config.notificationBasePath;

  @override
  Future<NotificationPage> getNotifications({
    required int page,
    required int size,
  }) async {
    final response = await _apiClient.get(
      '$_base/me',
      queryParameters: {'page': page, 'size': size},
    );
    final body = _requireData(response.data);
    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }
    final content = body['content'];
    return NotificationPage(
      items: [
        if (content is List)
          for (final item in content.whereType<Map<String, dynamic>>())
            AppNotificationDto(item).toEntity(),
      ],
      page: page,
      isLast: body['last'] != false,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get('$_base/me/unread-count');
    final body = _requireData(response.data);
    if (body is Map<String, dynamic>) {
      return (body['unreadCount'] as num?)?.toInt() ?? 0;
    }
    return 0;
  }

  @override
  Future<void> markRead(int id) async {
    final response = await _apiClient.patch('$_base/$id/read');
    _requireData(response.data);
  }

  @override
  Future<void> markAllRead() async {
    final response = await _apiClient.patch('$_base/me/read-all');
    _requireData(response.data);
  }

  Object? _requireData(Object? data) {
    if (data is Map<String, dynamic>) {
      return ApiResponse<Object?>.fromJson(data).requireSuccess();
    }
    return null;
  }
}
