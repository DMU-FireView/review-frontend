import 'package:re_view_front/core/config/app_config.dart';
import 'package:re_view_front/core/network/api_client.dart';
import 'package:re_view_front/core/network/api_response.dart';
import 'package:re_view_front/features/settings/data/dtos/settings_dto.dart';
import 'package:re_view_front/features/settings/domain/entities/settings_data.dart';

abstract interface class SettingsRemoteDataSource {
  Future<SettingsDto> getSettings();
  Future<SettingsDto> updateSettings(SettingsData settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  const SettingsRemoteDataSourceImpl({
    required ApiClient apiClient,
    required AppConfig config,
  }) : _apiClient = apiClient,
       _config = config;

  final ApiClient _apiClient;
  final AppConfig _config;

  @override
  Future<SettingsDto> getSettings() async {
    final response = await _apiClient.get(_config.userSettingsPath);
    return _parse(response.data);
  }

  @override
  Future<SettingsDto> updateSettings(SettingsData settings) async {
    final response = await _apiClient.patch(
      _config.userSettingsPath,
      data: SettingsDto.toUpdateJson(settings),
    );
    return _parse(response.data);
  }

  SettingsDto _parse(Object? data) {
    if (data is Map<String, dynamic>) {
      final body = ApiResponse<Object?>.fromJson(data).requireSuccess();
      if (body is Map<String, dynamic>) return SettingsDto(body);
    }
    throw const FormatException('Invalid settings response');
  }
}
