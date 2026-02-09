import 'package:flutter/material.dart';
import 'package:tasky_app/core/helper/validetor_app.dart';
import 'package:tasky_app/core/network/result_firebase.dart';
import 'package:tasky_app/core/widgets/app_dialog.dart';
import 'package:tasky_app/feature/auth/data/firebase/auth_firebase_database.dart';
import 'package:tasky_app/feature/auth/screen/register_screen.dart';
import 'package:tasky_app/feature/home/widgets/text_form_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isRequestRunning = false;

  @override
  void initState() {
    super.initState();
    _clearFields();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 53),
                TextFormFieldWidget(
                  label: "Email",
                  controller: emailController,
                  keybroardType: TextInputType.emailAddress,
                  myValidator: ValidatorApp.validateEmail,
                ),
                const SizedBox(height: 26),
                TextFormFieldWidget(
                  label: "Password",
                  controller: passwordController,
                  obscureText: true,
                  isPassword: true,
                  myValidator: ValidatorApp.validatePassword,
                ),
                const SizedBox(height: 71),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:() {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5F33E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Color(0xffFFFFFF)),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        children: [
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              color: Color(0xff5F33E1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    AppDialog.showLoading(context);
    if (_isRequestRunning) return;

  _isRequestRunning = true;
    final result = await AuthFunctions.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    _isRequestRunning = false;
    AppDialog.hideLoading(context);
    switch (result) {
      case Success<String>():
        break;
      case ErrorState<String>():
        AppDialog.showError(
          context: context,
          message: 'wrong password or email',
        );
        break;
    }
  }
    void _clearFields() {
      emailController.clear();
      passwordController.clear();

      _formKey.currentState?.reset();
    }
}
