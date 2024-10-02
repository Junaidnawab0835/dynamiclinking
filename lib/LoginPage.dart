import 'package:deeplinking/LoginController.dart';
import 'package:deeplinking/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController signInController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      onChanged: (value) {
                        signInController.email.value = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter your Email',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.email),
                          onPressed: () {},
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      obscureText: _obscureText,
                      onChanged: (value) {
                        signInController.password.value = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter your Password',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter New Password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          signInController.isLoading(true);
                          try {
                            await signInController.loginUser();
                          } finally {
                            signInController.isLoading(false);
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(SignUpPage());
                        },
                        child: Text("SignUp")),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.dialog(ResetPasswordDialog());
                        },
                        child: Text("Reset Password"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordDialog extends StatefulWidget {
  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Reset Password",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'PoppinsRegular',
        ),
      ),
      content: Container(
        // Limits the height of the dialog box to a fraction of the screen height
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              TextFormField(
                onChanged: (value) {
                  loginController.email.value = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your Email',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () {},
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (loginController.email.value.isNotEmpty) {
              loginController.sendPasswordResetEmail();
              Get.back();  // Close the dialog after resetting password
              Get.snackbar("Success", "Password Reset Email Sent");
            } else {
              Get.snackbar("Error", "Empty Email");
            }
          },
          child: const Text("Reset Password"),
        ),
      ],
    );
  }
}