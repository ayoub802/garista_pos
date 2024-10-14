import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/presentation/components/components.dart';
import 'package:garista_pos/src/presentation/theme/app_colors.dart';
import 'package:garista_pos/src/presentation/theme/theme/theme.dart';
import 'package:garista_pos/src/repository/repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:provider/provider.dart';
import 'core/di/dependency_manager.dart';
import './presentation/pages/pages.dart';

@pragma('vm:entry-point')
// Future<int> getOtherTranslation(int arg) async {
//   final settingsRepository = SettingsRepositoryImpl();
//   final res = await settingsRepository.getLanguages();
//   res.when(
//       success: (l) {
//         l.data?.forEach((e) async {
//           final translations =
//               await settingsRepository.getMobileTranslations(lang: e.locale);
//           translations.when(
//               success: (d) {
//                 LocalStorage.setOtherTranslations(
//                     translations: d.data, key: e.id.toString());
//               },
//               failure: (f) => null);
//         });
//       },
//       failure: (f) => null);
//   return 0;
// }

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  // Future<Future<FlutterIsolate>> isolate() async {
  //   return FlutterIsolate.spawn(getOtherTranslation, 0);
  // }

  @override
  void initState() {
    super.initState();
    // Check the translations
    final translations = LocalStorage.getTranslations();
    print("Translations from local storage: $translations");
    if (translations.isNotEmpty) {
      try {
        final decodedTranslations = translations;
        print("Decoded Translations: $decodedTranslations");
      } catch (e) {
        print("Error decoding translations: $e");
      }
      fetchSettingNoAwait();
    }
  }

  Future fetchSetting() async {
    final connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      try {
        await settingsRepository.getGlobalSettings();
        await settingsRepository.getLanguages();
        final translations = await settingsRepository.getTranslations();
        print("Fetched translations: $translations");
        // Optionally decode JSON if it's fetched as a string
        // final decodedTranslations = json.decode(translations);
        // print("Decoded Fetched Translations: $decodedTranslations");
      } catch (e) {
        print("Error fetching settings: $e");
      }
    }
  }

  Future fetchSettingNoAwait() async {
    settingsRepository.getGlobalSettings();
    settingsRepository.getLanguages();
    settingsRepository.getTranslations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        AppTheme.create,
        if (LocalStorage.getTranslations().isEmpty) fetchSetting(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final AppTheme theme = snapshot.data?[0];
          return ScreenUtilInit(
            designSize: const Size(1194, 900),
            builder: (context, child) {
              return ChangeNotifierProvider(
                create: (BuildContext context) => theme,
                child: MaterialApp(
                  theme: ThemeData(useMaterial3: false),
                  scrollBehavior: CustomScrollBehavior(),
                  debugShowCheckedModeBanner: false,
                  // Uncomment if you use these routers:
                  // routerDelegate: appRouter.delegate(),
                  // routeInformationParser: appRouter.defaultRouteParser(),
                  home: const LoginPage(),
                  locale: Locale(LocalStorage.getLanguage()?.locale ?? 'en'),
                  color: AppColors.white,
                  builder: (context, child) {
                    // Safely ensure child is not null
                    return ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                ),
              );
            },
          );
        } else {
          // Return an empty widget if no data is available (shouldn't happen with Future.wait())
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
