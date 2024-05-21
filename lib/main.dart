import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/services/cach_service.dart';
import 'package:todoapp/ui/pages/splash_page.dart';
import 'dp/dp_helper.dart';
import 'services/notification_services.dart';
import 'services/theme_services.dart';
import 'ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    CacheService.init(),
    NotificationServices.init(),
    // WorkManagerService.init(),
  ]);
  await DpHelper.initDp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      theme: Themes.liGht,
      darkTheme: Themes.daRk,
      themeMode: ThemeServices().theme,
      home: const SplashScreen(),
    );
  }
}
