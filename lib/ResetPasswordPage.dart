import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginController.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? resetCode; // Reset code extracted from the dynamic link
  const ResetPasswordPage({super.key, required this.resetCode});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  LoginController signInController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "New Password",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      obscureText: _obscureText,
                      onChanged: (value) {
                        signInController.newPassword.value = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter your New Password',
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
                    const SizedBox(height: 15),
                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      obscureText: _obscureText,
                      onChanged: (value) {
                        // Handle confirm password
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter your Confirm Password',
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
                          return 'Please Enter Confirm Password';
                        }
                        if (value != signInController.newPassword.value) {
                          return 'Confirm Password does not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(() => (signInController.isLoading.value)
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          signInController.isLoading(true);
                          try {
                            await signInController.resetPassword(widget.resetCode);
                          } finally {
                            signInController.isLoading(false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50), backgroundColor: Colors.blue),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
