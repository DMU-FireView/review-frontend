sealed class SettingsState {
  const SettingsState();
}

final class SettingsIdle extends SettingsState {
  const SettingsIdle({required this.settings});
  final SettingsData settings;
}

final class SettingsSaving extends SettingsState {
  const SettingsSaving({required this.settings});
  final SettingsData settings;
}

final class SettingsSaved extends SettingsState {
  const SettingsSaved({required this.settings});
  final SettingsData settings;
}

final class SettingsError extends SettingsState {
  const SettingsError({required this.settings, required this.message});
  final SettingsData settings;
  final String message;
}

class SettingsData {
  const SettingsData({
    this.emailNotification = true,
    this.pushNotification = true,
    this.adEmailNotification = false,
    this.highlightLowRti = true,
    this.wishlistAlert = true,
    this.categoryFilterId,
    this.categoryFilterLabel,
    this.minReviewCount = 10,
    this.lowRtiThreshold = 60,
  });

  final bool emailNotification;
  final bool pushNotification;
  final bool adEmailNotification;
  final bool highlightLowRti;
  final bool wishlistAlert;
  final String? categoryFilterId;
  final String? categoryFilterLabel;
  final int minReviewCount;
  final int lowRtiThreshold;

  SettingsData copyWith({
    bool? emailNotification,
    bool? pushNotification,
    bool? adEmailNotification,
    bool? highlightLowRti,
    bool? wishlistAlert,
    Object? categoryFilterId = _sentinel,
    Object? categoryFilterLabel = _sentinel,
    int? minReviewCount,
    int? lowRtiThreshold,
  }) {
    return SettingsData(
      emailNotification: emailNotification ?? this.emailNotification,
      pushNotification: pushNotification ?? this.pushNotification,
      adEmailNotification: adEmailNotification ?? this.adEmailNotification,
      highlightLowRti: highlightLowRti ?? this.highlightLowRti,
      wishlistAlert: wishlistAlert ?? this.wishlistAlert,
      categoryFilterId: categoryFilterId == _sentinel
          ? this.categoryFilterId
          : categoryFilterId as String?,
      categoryFilterLabel: categoryFilterLabel == _sentinel
          ? this.categoryFilterLabel
          : categoryFilterLabel as String?,
      minReviewCount: minReviewCount ?? this.minReviewCount,
      lowRtiThreshold: lowRtiThreshold ?? this.lowRtiThreshold,
    );
  }
}

const _sentinel = Object();
