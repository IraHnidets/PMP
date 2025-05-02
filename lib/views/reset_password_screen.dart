  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class ResetPasswordScreen extends StatefulWidget {
    const ResetPasswordScreen({super.key});

    @override
    State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
  }

  class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
    final _emailController = TextEditingController();
    String? _message;
    bool _isLoading = false;

    Future<void> _resetPassword() async {
      setState(() {
        _isLoading = true;
        _message = null;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        setState(() {
          _message = 'Лист для відновлення пароля відправлено на ${_emailController.text.trim()}';
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _message = e.message ?? 'Помилка відправлення листа';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Відновлення пароля')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Введіть email, щоб отримати посилання для відновлення пароля'),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              if (_message != null)
                Text(_message!, style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Відновити пароль'),
              ),
            ],
          ),
        ),
      );
    }
  }