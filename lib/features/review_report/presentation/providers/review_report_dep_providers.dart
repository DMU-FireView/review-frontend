import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/features/review_report/data/datasources/review_report_remote_data_source.dart';
import 'package:re_view_front/features/review_report/data/repositories/review_report_repository_impl.dart';
import 'package:re_view_front/features/review_report/domain/repositories/review_report_repository.dart';
import 'package:re_view_front/features/review_report/domain/usecases/submit_review_report_use_case.dart';

final reviewReportRemoteDataSourceProvider =
    Provider<ReviewReportRemoteDataSource>((ref) {
  return ReviewReportRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
    config: ref.watch(appConfigProvider),
  );
});

final reviewReportRepositoryProvider =
    Provider<ReviewReportRepository>((ref) {
  return ReviewReportRepositoryImpl(
    ref.watch(reviewReportRemoteDataSourceProvider),
  );
});

final submitReviewReportUseCaseProvider =
    Provider<SubmitReviewReportUseCase>((ref) {
  return SubmitReviewReportUseCase(ref.watch(reviewReportRepositoryProvider));
});
