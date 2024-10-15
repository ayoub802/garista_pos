import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app_widget.dart';
import 'src/core/di/dependency_manager.dart';
import 'src/core/utils/utils.dart';
import 'dart:io' show Platform;
import 'package:flutter_logs/flutter_logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  setUpDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterLogs.initLogs(
    logLevelsEnabled: [
      LogLevel.INFO,
      LogLevel.WARNING,
      LogLevel.ERROR,
      LogLevel.SEVERE
    ],
    logTypesEnabled: ['device', 'network', 'error'],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_FULL_1,
    directoryStructure: DirectoryStructure.FOR_DATE,
    logFileExtension: LogFileExtension.LOG,
  );

  await LocalStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const ProviderScope(child: AppWidget()));
}
