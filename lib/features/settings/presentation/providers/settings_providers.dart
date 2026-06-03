import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_state.dart';
import 'package:re_view_front/features/settings/presentation/view_models/settings_view_model.dart';

final settingsViewModelProvider =
    NotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
      SettingsViewModel.new,
    );
