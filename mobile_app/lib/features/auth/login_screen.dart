import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final auth = AuthService();

  void sendOtp() async {
    await auth.sendOtp(
      phone: "+91${phoneController.text}",
      onCodeSent: (verificationId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(verificationId: verificationId),
          ),
        );
      },
      onError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone number"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendOtp,
              child: const Text("Send OTP"),
            )
          ],
        ),
      ),
    );
  }
}
