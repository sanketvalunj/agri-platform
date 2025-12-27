import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final cred = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: otpController.text,
                );
                await FirebaseAuth.instance.signInWithCredential(cred);
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}
