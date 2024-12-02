import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty_mobile_app/auth.dart';
import 'package:hedieaty_mobile_app/components/reusable/show_snack_bar.dart';
import 'package:hedieaty_mobile_app/static/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    try {
      await Auth().signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _phoneController.text,
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
            signUp();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller, String labelText, String fieldType) {
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

        if (fieldType == 'name' && value.length < 2) {
          return 'Name must be at least 2 characters long';
        }
        if (fieldType == 'email' &&
            !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (fieldType == 'phone' &&
            !RegExp(r"^\+?[0-9]{10,15}$").hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        if (fieldType == 'password' && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }

        return null;
      },
      obscureText: fieldType == 'password',
      keyboardType: fieldType == 'phone'
          ? TextInputType.phone
          : fieldType == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text,
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
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36.0,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                _textField(_nameController, 'Name', 'name'),
                const SizedBox(height: 10.0),
                _textField(_emailController, 'Email', 'email'),
                const SizedBox(height: 10.0),
                _textField(_phoneController, 'Phone', 'phone'),
                const SizedBox(height: 10.0),
                _textField(_passwordController, 'Password', 'password'),
                const SizedBox(height: 10.0),
                _submitButton(),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/sign-in');
                  },
                  child: const Text(
                    'Already have an account? Sign in',
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
