import 'package:dio/dio.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/network/network_exception.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/home/data/datasources/home_remote_data_source.dart';
import 'package:re_view_front/features/home/domain/entities/dashboard_summary.dart';
import 'package:re_view_front/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<DashboardSummary>> getHomeDashboard() async {
    try {
      final dashboard = await _remoteDataSource.getHomeDashboard();
      return Success(dashboard.toEntity());
    } on DioException catch (error) {
      return FailureResult(failureFromDioException(error));
    } on Object catch (error) {
      return FailureResult(
        Failure(message: '홈 데이터를 불러오지 못했습니다.', cause: error),
      );
    }
  }
}
