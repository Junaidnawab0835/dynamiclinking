import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'ResetPasswordPage.dart';
import 'LoginPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) {
      handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print("This is error >>> " + error.message);
    });
    handleDynamicLink(initialLink);
  }

  void handleDynamicLink(PendingDynamicLinkData? dynamicLinkData) {
    final Uri? deepLink = dynamicLinkData?.link;
    print("Received deep link: $deepLink");
    if (deepLink != null) {
      if (deepLink.toString().contains('resetPassword')) {
        String? oobCode = deepLink.queryParameters['oobCode'];
        print(oobCode);
        if (oobCode != null) {
          Get.offAll(() => ResetPasswordPage(resetCode: oobCode));
        } else {
          print("oobCode parameter is missing in the deep link.");
          // Handle error or other navigation if no oobCode
        }
      } else {
        print("Deep link does not contain 'resetPassword' path segment.");
      }
    } else {
      initializeState();
      print("Deep link is null.");
    }
  }

  void initializeState() async {
    Timer(const Duration(seconds: 3), () async {
      Get.offAll(() => const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Container(
          decoration: BoxDecoration(color: Colors.purple),
          child: const Center(
            child: Icon(Icons.link),
          ),
        ));
  }
}
