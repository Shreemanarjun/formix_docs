import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'theme_mode.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.auto;

  void setTheme(ThemeMode mode) => state = mode;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
