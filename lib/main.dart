import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/water_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const HydroPingApp());
}

class HydroPingApp extends StatelessWidget {
  const HydroPingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WaterProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'HydroPing',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              foregroundColor: Colors.black,
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: Colors.blue),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF181925),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: Colors.blue),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
