import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import './core/app_routes.dart';
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

          // 🎨 Global theme (farmer-friendly)
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green.shade700,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56), // 👈 big buttons
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.green.shade50,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          // 🧭 Routing
          routes: AppRoutes.routes,

          // 🚀 App entry point - AuthWrapper handles authentication
          home: const AuthWrapper(),
        );
      },
    );
  }
}
