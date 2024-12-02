import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/auth.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        context,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBarError(context, e.toString());
    }
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            signIn();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String labelText, bool obscureText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      style: const TextStyle(
        color: AppColors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        if (labelText == 'Email' &&
            !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (labelText == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
      obscureText: obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36.0,
                      color: AppColors.white),
                ),
                const SizedBox(height: 20.0),
                _textField(_emailController, 'Email', false),
                const SizedBox(height: 10.0),
                _textField(_passwordController, 'Password', true),
                const SizedBox(height: 10.0),
                _submitButton(),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/sign-up');
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
