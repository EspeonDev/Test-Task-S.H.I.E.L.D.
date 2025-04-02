import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/services/auth_service.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthService authService = AuthService();

    Future<void> signIn() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showErrorDialog(context, "Please fill all fields");
        return;
      }

      final user = await authService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (user == null) {
        _showErrorDialog(context, "Authentication failed. Please try again.");
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ACCESS CONTROL', style: AppStyles.appBarTextStyle),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/imgs/title2.png', height: 144),
              const SizedBox(height: 24),
              const Text(
                'Welcome, Agent. Security clearance required. Authenticate to access the system.',
                textAlign: TextAlign.center,
                style: AppStyles.casual,
              ),
              const SizedBox(height: 24),
              _buildTextField(emailController, Icons.mail, 'Agent ID'),
              const SizedBox(height: 16),
              _buildTextField(
                passwordController,
                Icons.lock,
                'Security Key',
                isPassword: true,
              ),
              const SizedBox(height: 32),
              const Text('Verify Identity', style: AppStyles.bigCasual),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  signIn();
                },
                borderRadius: BorderRadius.circular(50),
                splashColor: Colors.cyan.withValues(alpha: 0.3),
                highlightColor: Colors.cyan.withValues(alpha: 0.2),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.fingerprint,
                    size: 100,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String placeholder, {
    bool isPassword = false,
  }) {
    return CupertinoTextField(
      prefix: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Icon(icon, color: Colors.black54),
      ),
      placeholder: placeholder,
      obscureText: isPassword,
      keyboardType:
          isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
