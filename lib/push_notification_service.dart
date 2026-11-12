import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/widgets/save_file_noti.dart';
import 'package:lumina/widgets/var_globais.dart';  // Ajuste o caminho conforme seu projeto

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel', // ID do canal
    'Notificações', // Nome visível
    description: 'Canal padrão para notificações do app',
    importance: Importance.high,
  );

  // Inicializa o serviço de notificações
  static Future<void> initialize(String userId) async {
    // Solicita permissão para notificações (iOS)
    await _messaging.requestPermission();

    // Obtem o token FCM
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    if (token != null) {
      // Envia o token para o backend
      await http.post(
        Uri.parse("http://minhaapiemphp.elementfx.com/salvar_token.php"),
        body: {
          'user_id': userId,
          'fcm_token': token,
        },
      );
    }

    // Criação do canal de notificação (Android 8+)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Inicializa o plugin de notificações locais
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        print("Notificação aberta com payload: $payload");
        // Navegação ou ação desejada
      },
    );

    // Listener para notificações recebidas com o app em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Mensagem recebida em foreground: ${message.notification?.title}");

      final storageNoti = CounterStorage_noti();
      String permissao = await storageNoti.readCounter();

      if (permissao == "1") {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      } else {
        print("Usuário não permitiu notificações, não mostrando.");
      }
    });

    // Listener quando o app é aberto pela notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Usuário abriu a notificação: ${message.notification?.title}");
      // Você pode navegar para uma tela específica aqui
    });

    // Inscrever o usuário automaticamente nas notificações (opcional)
    await subscribeToNotifications(userId);
  }

  // Função pública para inscrever o usuário nas notificações
  static Future<void> subscribeToNotifications(String userId) async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        // Inscreve o usuário em um tópico específico (usando userId como exemplo)
        await _messaging.subscribeToTopic(userId);
        print('Usuário $userId inscrito nas notificações');

        // Envia o token para o backend (caso precise associar ao banco)
        await http.post(
          Uri.parse('http://minhaapiemphp.elementfx.com/subscribeUser.php'),
          body: {'user_id': userId, 'fcm_token': token},
        );
      }
    } catch (e) {
      print('Erro ao inscrever nas notificações: $e');
    }
  }

  // Função pública para desinscrever o usuário das notificações
  static Future<void> unsubscribeFromNotifications(String userId) async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        // Desinscreve o usuário do tópico
        await _messaging.unsubscribeFromTopic(userId);
        print('Usuário $userId desinscrito das notificações');

        // Envia a requisição ao backend para remover o token, se necessário
        await http.post(
          Uri.parse(apiBaseUrl+'/unsubscribeUser.php'),
          body: {'user_id': userId, 'fcm_token': token},
        );
      }
    } catch (e) {
      print('Erro ao desinscrever das notificações: $e');
    }
  }

  // Função chamada quando o usuário ativa/desativa notificações no perfil
  static Future<void> updateNotificationPreference(
      String userId, bool enableNotifications) async {
    if (enableNotifications) {
      // Inscreve nas notificações
      await subscribeToNotifications(userId);
    } else {
      // Desinscreve das notificações
      await unsubscribeFromNotifications(userId);
    }
  }
}