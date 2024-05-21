import 'dart:io';

import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  static void registerMyTask() async {
    if (Platform.isIOS) {
      await Workmanager().registerOneOffTask(
        'idOneOffTask',
        'show one off notification',
        initialDelay: const Duration(seconds: 5),
      );
    } else {
      await Workmanager().registerPeriodicTask(
        'idPeriodicTask',
        'show periodic notification',
        frequency: const Duration(hours: 6),
      );
    }
  }

  //init work manager service
  static Future<void> init() async {
    await Workmanager().initialize(
      actionTask,
      isInDebugMode: true,
    );
    registerMyTask();
  }

  void cancelTask(String id) {
    Workmanager().cancelAll();
  }
}

@pragma('vm-entry-point')
void actionTask() {
  //show notification
  Workmanager().executeTask((taskName, inputData) {
    return Future.value(true);
  });
}
