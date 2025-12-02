import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskapp/l10n/app_localizations.dart';
import 'package:taskapp/presentation/pages/post/posts_page.dart';
// import 'package:taskapp/presentation/pages/recipeScreen/recipe_page.dart';
import 'package:taskapp/presentation/providers/locale_provider.dart';
import 'package:taskapp/presentation/providers/theme_provider.dart';
import 'package:taskapp/presentation/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: TaskApp()));
}

class TaskApp extends ConsumerWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: "My Task App",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('km'), Locale('zh')],
      // home: RecipePage(),
      home: PostsPage(),
    );
  }
}
