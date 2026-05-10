import 'package:flutter/material.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/app/theme/app_spacing.dart';
import 'package:re_view_front/shared/extensions/context_extensions.dart';

class SignupCard extends StatelessWidget {
  const SignupCard({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.obscurePassword,
    required this.obscurePasswordConfirm,
    required this.agreedToTerms,
    required this.agreedToMarketing,
    required this.onPasswordVisibilityPressed,
    required this.onPasswordConfirmVisibilityPressed,
    required this.onTermsChanged,
    required this.onMarketingChanged,
    required this.onSignupPressed,
    required this.onLoginPressed,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final bool obscurePassword;
  final bool obscurePasswordConfirm;
  final bool agreedToTerms;
  final bool agreedToMarketing;
  final VoidCallback onPasswordVisibilityPressed;
  final VoidCallback onPasswordConfirmVisibilityPressed;
  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onMarketingChanged;
  final VoidCallback onSignupPressed;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 42,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? AppSpacing.lg : 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create your account',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '회원가입',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Re:view 계정을 만들고 저장 상품, 신뢰 필터, 알림 설정을 시작하세요.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _SocialSignupButton(
                label: '네이버 계정으로 가입하기',
                mark: 'N',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              _SocialSignupButton(
                label: 'Google 계정으로 가입하기',
                mark: 'G',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
              const _DividerLabel(label: '또는 이메일로 가입'),
              const SizedBox(height: AppSpacing.lg),
              _SignupInputField(
                controller: nameController,
                label: '이름',
                hintText: '이름을 입력하세요',
                prefixIcon: Icons.person_outline,
                helperText: '서버 전송 시 nickname 필드로 전달됩니다.',
              ),
              const SizedBox(height: AppSpacing.md),
              _SignupInputField(
                controller: emailController,
                label: '이메일',
                hintText: '이메일을 입력하세요',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: AppSpacing.md),
              _SignupInputField(
                controller: passwordController,
                label: '비밀번호',
                hintText: '비밀번호를 입력하세요',
                obscureText: obscurePassword,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.lock_outline,
                helperText: '영문, 숫자, 특수문자를 포함해 8자 이상으로 설정해주세요.',
                trailing: TextButton(
                  onPressed: onPasswordVisibilityPressed,
                  child: Text(obscurePassword ? '보기' : '숨김'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SignupInputField(
                controller: passwordConfirmController,
                label: '비밀번호 확인',
                hintText: '비밀번호를 한 번 더 입력하세요',
                obscureText: obscurePasswordConfirm,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.check,
                trailing: TextButton(
                  onPressed: onPasswordConfirmVisibilityPressed,
                  child: Text(obscurePasswordConfirm ? '보기' : '숨김'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AgreementBox(
                agreedToTerms: agreedToTerms,
                agreedToMarketing: agreedToMarketing,
                onTermsChanged: onTermsChanged,
                onMarketingChanged: onMarketingChanged,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: agreedToTerms ? onSignupPressed : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('회원가입하고 온보딩 시작'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _NextStepNotice(),
              const SizedBox(height: AppSpacing.xl),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '이미 계정이 있나요?',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: onLoginPressed,
                    child: const Text('로그인하기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupInputField extends StatelessWidget {
  const _SignupInputField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.helperText,
    this.trailing,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? helperText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 56,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(prefixIcon),
              suffixIcon: trailing,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}

class _AgreementBox extends StatelessWidget {
  const _AgreementBox({
    required this.agreedToTerms,
    required this.agreedToMarketing,
    required this.onTermsChanged,
    required this.onMarketingChanged,
  });

  final bool agreedToTerms;
  final bool agreedToMarketing;
  final ValueChanged<bool> onTermsChanged;
  final ValueChanged<bool> onMarketingChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          children: [
            CheckboxListTile(
              value: agreedToTerms,
              onChanged: (value) => onTermsChanged(value ?? false),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '이용약관 및 개인정보처리방침에 동의합니다. (필수)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            CheckboxListTile(
              value: agreedToMarketing,
              onChanged: (value) => onMarketingChanged(value ?? false),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                '저장 상품 알림과 신뢰도 변화 알림을 받겠습니다. (선택)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStepNotice extends StatelessWidget {
  const _NextStepNotice();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '다음 단계는 온보딩입니다. 가입 후 관심 카테고리와 기본 RTI 필터를 설정합니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialSignupButton extends StatelessWidget {
  const _SocialSignupButton({
    required this.label,
    required this.mark,
    required this.onPressed,
  });

  final String label;
  final String mark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              mark,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      ),
    );
  }
}
