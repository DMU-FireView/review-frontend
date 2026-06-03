import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';

class SettingsViewModel extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsIdle(settings: SettingsData());
  }

  SettingsData get _current => switch (state) {
    SettingsIdle(:final settings) => settings,
    SettingsSaving(:final settings) => settings,
    SettingsSaved(:final settings) => settings,
    SettingsError(:final settings) => settings,
  };

  void setEmailNotification(bool value) {
    state = SettingsIdle(settings: _current.copyWith(emailNotification: value));
  }

  void setPushNotification(bool value) {
    state = SettingsIdle(settings: _current.copyWith(pushNotification: value));
  }

  void setAdEmailNotification(bool value) {
    state =
        SettingsIdle(settings: _current.copyWith(adEmailNotification: value));
  }

  void setHighlightLowRti(bool value) {
    state = SettingsIdle(settings: _current.copyWith(highlightLowRti: value));
  }

  void setWishlistAlert(bool value) {
    state = SettingsIdle(settings: _current.copyWith(wishlistAlert: value));
  }

  void setCategoryFilter(String? id, String? label) {
    state = SettingsIdle(
      settings: _current.copyWith(
        categoryFilterId: id,
        categoryFilterLabel: label,
      ),
    );
  }

  void setMinReviewCount(int value) {
    state = SettingsIdle(settings: _current.copyWith(minReviewCount: value));
  }

  void setLowRtiThreshold(int value) {
    state = SettingsIdle(settings: _current.copyWith(lowRtiThreshold: value));
  }

  Future<void> save() async {
    final current = _current;
    state = SettingsSaving(settings: current);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = SettingsSaved(settings: current);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (state case SettingsSaved(:final settings)) {
      state = SettingsIdle(settings: settings);
    }
  }
}
