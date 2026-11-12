import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lumina/less.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lumina/push_notification_service.dart';
import 'package:lumina/widgets/notification_controller.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  final CounterStorage storage = CounterStorage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('pt_BR', null);
  await _checkFirstLaunch(storage);
  String? userId = await storage.readCounter();

  if (userId != null && userId.isNotEmpty) {
    await PushNotificationService.initialize(userId);
    NotificationController.instance.initializeUser(userId);
  }
  runApp(const less());
}
Future<void> _checkFirstLaunch(CounterStorage storage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await storage.deleteCounter();
    await prefs.setBool('isFirstLaunch', false);
  }
}