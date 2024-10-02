import 'package:deeplinking/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginController signInController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: () async {
        await signInController.logoutUser();
      },child: Text("LogOut"),),
    );
  }
}
