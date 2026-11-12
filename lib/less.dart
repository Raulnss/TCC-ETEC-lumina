import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lumina/full.dart';
import 'package:lumina/widgets/app_controler.dart';
import 'package:lumina/widgets/notification_controller.dart';
import 'package:provider/provider.dart';

class less extends StatelessWidget {
  const less({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<appcontroler>(
          create: (_) => appcontroler.instance,
        ),
        ChangeNotifierProvider<NotificationController>(
          create: (_) => NotificationController.instance,
        ),
      ],
      child: FutureBuilder(
        future: appcontroler.instance.loadThemeFromStorage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return Consumer<appcontroler>(
            builder: (context, controller, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: controller.isdarktheme ? Brightness.dark : Brightness.light,
                ),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('pt', 'BR'),
                ],
                locale: const Locale('pt', 'BR'),
                home: const full(),
              );
            },
          );
        },
      ),
    );
  }
}