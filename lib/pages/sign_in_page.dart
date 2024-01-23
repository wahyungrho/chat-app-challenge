import 'package:chat_app_chalenge/controller/auth_controller.dart';
import 'package:chat_app_chalenge/data/models/response_model.dart';
import 'package:chat_app_chalenge/pages/home_page.dart';
import 'package:chat_app_chalenge/pages/sign_up_page.dart';
import 'package:chat_app_chalenge/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    void signin() async {
      ResponseModel response = await authController.signin();

      if (response.status == "success") {
        Get.off(() => const HomePage());
      } else {
        Get.dialog(AlertDialog(
            title: const Text('Registration Failed'),
            content: Text('${response.data}'),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'))
            ]));
      }
    }

    Widget headerWidget() => Container(
        margin: EdgeInsets.only(top: defaultMargin),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Login',
              style: primaryTextStyle.copyWith(
                  fontSize: 24, fontWeight: semiBold)),
          const SizedBox(height: 2),
          Text('Sign In to Continue', style: subtitleTextStyle)
        ]));

    Widget emailTextFieldWidget() => Container(
        margin: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email Address',
                style: primaryTextStyle.copyWith(
                    fontSize: 16, fontWeight: medium)),
            const SizedBox(height: 12),
            Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(borderRadius)),
                child: Center(
                    child: Row(children: [
                  const Icon(Icons.mail_outline),
                  const SizedBox(width: 16),
                  Expanded(
                      child: TextFormField(
                          controller: authController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: primaryTextStyle,
                          decoration: InputDecoration.collapsed(
                              hintText: 'Your Email Address',
                              hintStyle: subtitleTextStyle)))
                ])))
          ],
        ));

    Widget passwordTextFieldWidget() => Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Password',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
          const SizedBox(height: 12),
          Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(borderRadius)),
              child: Center(
                  child: Row(children: [
                const Icon(Icons.lock_outline),
                const SizedBox(width: 16),
                Expanded(
                    child: TextFormField(
                        controller: authController.passwordController,
                        style: primaryTextStyle,
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Your Password',
                            hintStyle: subtitleTextStyle)))
              ])))
        ]));

    Widget signInButtonWidget() => Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: TextButton(
            onPressed: signin,
            style: TextButton.styleFrom(
                backgroundColor: blackColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius))),
            child: Obx(() => authController.isLoading.value
                ? CircularProgressIndicator(color: whiteColor)
                : Text('Sign In',
                    style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: medium,
                        color: whiteColor)))));

    Widget footerWidget() => Container(
        margin: EdgeInsets.only(bottom: defaultMargin),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Don\'t have an account? ',
              style: subtitleTextStyle.copyWith(fontSize: 12)),
          GestureDetector(
            onTap: () => Get.to(() => const SignUpPage()),
            child: Text('Sign Up',
                style: primaryTextStyle.copyWith(fontWeight: semiBold)),
          ),
        ]));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.all(defaultMargin),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            headerWidget(),
            emailTextFieldWidget(),
            passwordTextFieldWidget(),
            signInButtonWidget(),
            const Spacer(),
            footerWidget()
          ])),
    );
  }
}
