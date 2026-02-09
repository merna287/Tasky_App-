import 'package:flutter/material.dart';
import 'package:tasky_app/core/helper/validetor_app.dart';
import 'package:tasky_app/core/network/result_firebase.dart';
import 'package:tasky_app/core/widgets/app_dialog.dart';
import 'package:tasky_app/feature/auth/data/firebase/auth_firebase_database.dart';
import 'package:tasky_app/feature/auth/data/model/user_model.dart';
import 'package:tasky_app/feature/auth/screen/login_screem.dart';
import 'package:tasky_app/feature/home/widgets/text_form_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmHidden = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _clearFields();
  }
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
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
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 23),
                TextFormFieldWidget(
                  label: "Username",
                  controller: usernameController,
                  myValidator: ValidatorApp.validateName,
                ),
                const SizedBox(height: 16),
                TextFormFieldWidget(
                  label: "Email",
                  controller: emailController,
                  keybroardType: TextInputType.emailAddress,
                  myValidator: ValidatorApp.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormFieldWidget(
                  label: "Password",
                  controller: passwordController,
                  isPassword: true,
                  obscureText: true,
                  myValidator: ValidatorApp.validatePassword,
                ),
                SizedBox(height: 16),
                TextFormFieldWidget(
                  label: "Confirm Password",
                  controller: confirmController,
                  isPassword: true,
                  obscureText: true,
                  myValidator: (value) {
                    return ValidatorApp.validateConfirmPassword(
                      value,
                      passwordController.text,
                    );
                  },
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5F33E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 16, color: Color(0xffFFFFFF)),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: "Login",
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
                const SizedBox(height: 33),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    AppDialog.showLoading(context);
    final result = await AuthFunctions.registerUser(
      user: UserModel(
        email: emailController.text,
        password: passwordController.text,
        userName: usernameController.text,
      ),
    );
    Navigator.of(context).pop();
    switch (result) {
      case Success<UserModel>():
        Navigator.of(context).pop();
      case ErrorState<UserModel>():
        AppDialog.showError(context: context, message: result.error);
    }
  }
  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
    usernameController.clear();

    _formKey.currentState?.reset();
  }
}
