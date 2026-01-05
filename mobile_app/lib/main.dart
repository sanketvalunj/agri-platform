import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import './core/app_routes.dart';
import './core/theme/app_themes.dart';
import './firebase_options.dart';
import './features/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AgriBotApp());
}

/// AgriBotApp
/// ----------
/// Root widget of the application
///
/// Responsibilities:
/// - Initialize MaterialApp
/// - Attach routes
/// - Set global theme
/// - Handle authentication state through AuthWrapper
///
/// NOTE:
/// - No business logic here
/// - Clean & production-ready
/// - AuthWrapper handles authentication flow

class AgriBotApp extends StatelessWidget {
  const AgriBotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Agri Bot',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routes: AppRoutes.routes,
          home: const AuthWrapper(),
        );
      },
    );
  }
}
