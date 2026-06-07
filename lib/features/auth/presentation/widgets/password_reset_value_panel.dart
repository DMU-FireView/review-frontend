import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';

class PasswordResetValuePanel extends StatelessWidget {
  const PasswordResetValuePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Badge(),
          const SizedBox(height: AppSpacing.lg),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                height: 1.16,
              ),
              children: const [
                TextSpan(text: '안전하게 인증하고\n'),
                TextSpan(
                  text: '비밀번호를 다시 설정',
                  style: TextStyle(color: AppColors.primary),
                ),
                TextSpan(text: ' 하세요.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Re:view 계정의 저장 상품, 신뢰 필터, 피드백 내역을 보호하기 위해 이메일 후 새 비밀번호를 설정합니다.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 36),
          const _ProcessCard(),
          const SizedBox(height: AppSpacing.lg),
          const _BenefitGrid(),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          '계정 복구',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard();

  static const _steps = [
    (
      label: '이메일 확인',
      desc: '가입한 이메일 주소로 인증 코드를 발송합니다.',
    ),
    (
      label: '인증 코드 입력',
      desc: '메일로 받은 6자리 코드를 입력해 계정을 확인합니다.',
    ),
    (
      label: '새 비밀번호 설정',
      desc: '보안 기준을 만족하는 새 비밀번호를 등록합니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '비밀번호 재설정 과정',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SecurityBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '계정 소유 확인 후 안전하게 비밀번호를 변경합니다.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            for (int i = 0; i < _steps.length; i++) ...[
              _ProcessStep(
                number: i + 1,
                label: _steps[i].label,
                desc: _steps[i].desc,
              ),
              if (i < _steps.length - 1) const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '보안 인증',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({
    required this.number,
    required this.label,
    required this.desc,
  });

  final int number;
  final String label;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$number',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid();

  static const _items = [
    (
      label: 'A',
      title: '계정 데이터 유지',
      body: '비밀번호를 바꿔도 저장 필터 설정은 그대로',
    ),
    (
      label: 'B',
      title: '인증 코드 보호',
      body: '인증 코드는 일정 시간 후 만료되며 타인에게 공유하지 않아야 합니다.',
    ),
    (
      label: 'C',
      title: '로그인 재확인',
      body: '비밀번호 변경 후 새 다시 로그인합니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        final cards = [
          for (final item in _items)
            _BenefitCard(label: item.label, title: item.title, body: item.body),
        ];

        if (!useRow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[
                card,
                if (card != cards.last) const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final card in cards) ...[
              Expanded(child: card),
              if (card != cards.last) const SizedBox(width: AppSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.label,
    required this.title,
    required this.body,
  });

  final String label;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
