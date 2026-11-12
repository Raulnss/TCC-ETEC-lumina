import 'package:flutter/material.dart';
import 'package:lumina/push_notification_service.dart';

class NotificationController extends ChangeNotifier {
  static final NotificationController instance = NotificationController._internal();

  String? _userId;
  bool _notificationsEnabled = false;

  NotificationController._internal();

  bool get notificationsEnabled => _notificationsEnabled;

  // Chamada no perfil.dart
  void initializeUser(String userId) {
    _userId = userId;
  }

  // Atualiza o estado local + inscreve/desinscreve o usuário nas notificações
  Future<void> updateNotification(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();

    if (_userId != null) {
      await PushNotificationService.updateNotificationPreference(_userId!, enabled);
    }
  }
}