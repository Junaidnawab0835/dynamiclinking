import 'package:deeplinking/HomePage.dart';
import 'package:deeplinking/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var newPassword = ''.obs;
  var email = ''.obs;
  var password = ''.obs;


  Future<void> resetPassword(String? resetCode) async {
    try {
      // Assuming widget.resetCode contains the oobCode for password reset
      await FirebaseAuth.instance.confirmPasswordReset(
        code: resetCode!,
        newPassword: newPassword.value,
      );
      Get.snackbar("Success", "Your password has been reset successfully.",
          snackPosition: SnackPosition.TOP);
      Get.offAll(() => const LoginPage());  // Navigate to login page after reset
    } catch (e) {
      Get.snackbar("Error", "Failed to change password: $e",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> sendPasswordResetEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email.value, actionCodeSettings: ActionCodeSettings(
      url: 'https://hellocoding.page.link/restPassword?email=$email',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.deeplinking',
      androidPackageName: 'com.example.deeplinking',
      androidInstallApp: false,
    ));
  }

  Future<void> createUser() async {
    try {
      isLoading.value = true;
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(email: email.value, password: password.value);
      Get.snackbar('Success', 'Account created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Login method
  Future<void> loginUser() async {
    try {
      isLoading.value = true;
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email.value, password: password.value);
      Get.snackbar('Success', 'Account Login successfully');
      Get.offAll(const HomePage());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    try {
      isLoading.value = true;
      final FirebaseAuth auth = FirebaseAuth.instance;
        auth.signOut();
        Get.offAll(const LoginPage());

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}