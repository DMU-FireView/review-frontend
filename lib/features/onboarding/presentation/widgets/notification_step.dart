import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/app/theme/app_text_styles.dart';
import 'package:re_view_front/features/onboarding/domain/entities/notification_channel.dart';
import 'package:re_view_front/features/onboarding/presentation/view_models/onboarding_state.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class NotificationStep extends StatelessWidget {
  const NotificationStep({
    required this.state,
    required this.onToggleLowTrustReview,
    required this.onToggleRiskSurge,
    required this.onToggleAnalysisComplete,
    required this.onToggleWeeklyReport,
    required this.onToggleMarketing,
    required this.onToggleChannel,
    required this.onPrevious,
    required this.onComplete,
    super.key,
  });

  final OnboardingState state;
  final VoidCallback onToggleLowTrustReview;
  final VoidCallback onToggleRiskSurge;
  final VoidCallback onToggleAnalysisComplete;
  final VoidCallback onToggleWeeklyReport;
  final VoidCallback onToggleMarketing;
  final ValueChanged<NotificationChannel> onToggleChannel;
  final VoidCallback onPrevious;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _NotificationForm(
            state: state,
            onToggleLowTrustReview: onToggleLowTrustReview,
            onToggleRiskSurge: onToggleRiskSurge,
            onToggleAnalysisComplete: onToggleAnalysisComplete,
            onToggleWeeklyReport: onToggleWeeklyReport,
            onToggleMarketing: onToggleMarketing,
            onToggleChannel: onToggleChannel,
            onPrevious: onPrevious,
            onComplete: onComplete,
          ),
        ),
        if (!context.isMobile) ...[
          Container(width: 1, color: AppColors.border),
          const SizedBox(width: AppSpacing.xl),
          const SizedBox(width: 320, child: _NotificationPreviewPanel()),
        ],
      ],
    );
  }
}

class _NotificationForm extends StatelessWidget {
  const _NotificationForm({
    required this.state,
    required this.onToggleLowTrustReview,
    required this.onToggleRiskSurge,
    required this.onToggleAnalysisComplete,
    required this.onToggleWeeklyReport,
    required this.onToggleMarketing,
    required this.onToggleChannel,
    required this.onPrevious,
    required this.onComplete,
  });

  final OnboardingState state;
  final VoidCallback onToggleLowTrustReview;
  final VoidCallback onToggleRiskSurge;
  final VoidCallback onToggleAnalysisComplete;
  final VoidCallback onToggleWeeklyReport;
  final VoidCallback onToggleMarketing;
  final ValueChanged<NotificationChannel> onToggleChannel;
  final VoidCallback onPrevious;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.medium,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '알림 및 데이터 설정을 완료해 주세요',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '원하는 방식으로 중요한 리뷰 분석 결과와 상품 위험 변화를 받아보실 수 있습니다.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _NotificationToggleItem(
            icon: Icons.shield_outlined,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.primaryLight,
            title: '신뢰도 낮은 리뷰 알림',
            description: '신뢰도 낮아 감지된 리뷰나 높은 위험도가 감지되면 즉시 알려드려요.',
            value: state.lowTrustReviewAlert,
            onChanged: (_) => onToggleLowTrustReview(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _NotificationToggleItem(
            icon: Icons.trending_up,
            iconColor: AppColors.error,
            iconBgColor: AppColors.errorSoft,
            title: '위험 급증 상품 알림',
            description: '위험도가 급격히 상승한 상품을 조기에 감지하여 알려드려요.',
            value: state.riskSurgeAlert,
            onChanged: (_) => onToggleRiskSurge(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _NotificationToggleItem(
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.success,
            iconBgColor: AppColors.successSoft,
            title: '리뷰 분석 완료 알림',
            description: '요청하신 리뷰 분석이 완료되면 알려드려요.',
            value: state.analysisCompleteAlert,
            onChanged: (_) => onToggleAnalysisComplete(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _NotificationToggleItem(
            icon: Icons.description_outlined,
            iconColor: AppColors.info,
            iconBgColor: AppColors.infoSoft,
            title: '주간 리포트 수신',
            description: '매주 리뷰 요약 리포트와 주요 인사이트를 정기적으로 보내드려요.',
            value: state.weeklyReportAlert,
            onChanged: (_) => onToggleWeeklyReport(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _NotificationToggleItem(
            icon: Icons.campaign_outlined,
            iconColor: AppColors.textSecondary,
            iconBgColor: AppColors.surfaceMuted,
            title: '마케팅/이벤트 알림',
            description: '이벤트, 프로모션 등 다양한 소식을 받아보실 수 있어요.',
            value: state.marketingAlert,
            onChanged: (_) => onToggleMarketing(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '알림 채널 선택 (복수 선택 가능)',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: NotificationChannel.values
                .map(
                  (channel) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: channel != NotificationChannel.values.last
                            ? AppSpacing.sm
                            : 0,
                      ),
                      child: _ChannelCard(
                        channel: channel,
                        isSelected: state.selectedChannels.contains(channel),
                        onTap: () => onToggleChannel(channel),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              OutlinedButton(
                onPressed: onPrevious,
                child: const Text('이전'),
              ),
              const Spacer(),
              Text(
                '언제든지 마이페이지 > 설정에서 변경할 수 있습니다.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(width: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.arrow_forward, size: 18),
                iconAlignment: IconAlignment.end,
                label: const Text('시작하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationToggleItem extends StatelessWidget {
  const _NotificationToggleItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: AppRadius.small,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.channel,
    required this.isSelected,
    required this.onTap,
  });

  final NotificationChannel channel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: AppRadius.medium,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  channel.icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                if (isSelected)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: AppColors.onPrimary,
                    ),
                  )
                else
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderStrong),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                channel.label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                channel.description,
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationPreviewPanel extends StatelessWidget {
  const _NotificationPreviewPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('알림 미리보기', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '선택한 설정과 채널로 다음과 같은 알림을 받아보게 됩니다.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xl),
        _AppPushPreview(),
        const SizedBox(height: AppSpacing.md),
        _WeeklyReportPreview(),
      ],
    );
  }
}

class _AppPushPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.small,
                ),
                child: const Center(
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Re:view',
                style: AppTextStyles.labelLarge,
              ),
              const Spacer(),
              Text('앱 푸시 알림', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '신뢰도 낮은 리뷰가 감지되었어요',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '관심 상품에서 신뢰도 낮은 리뷰가 감지되었습니다. 지금 확인해 보세요.',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _WeeklyReportPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.small,
                ),
                child: const Center(
                  child: Text(
                    'R',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text('주간 리포트 미리보기', style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('이번 주 리뷰 요약', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '지난 한 주간의 주요 리뷰 분석 결과를 확인해보세요.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatItem(label: '분석 완료 상품', color: AppColors.primary),
              _StatItem(label: '신뢰도 낮은 리뷰', color: AppColors.primary),
              _StatItem(label: '위험 급증 상품', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '리포트 더보기',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: 13,
                ),
              ),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppRadius.small,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
      ],
    );
  }
}
