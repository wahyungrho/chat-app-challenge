import 'package:chat_app_chalenge/controller/auth_controller.dart';
import 'package:chat_app_chalenge/controller/user_controller.dart';
import 'package:chat_app_chalenge/data/models/user_model.dart';
import 'package:chat_app_chalenge/pages/chat_page.dart';
import 'package:chat_app_chalenge/pages/sign_in_page.dart';
import 'package:chat_app_chalenge/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    UserController userController = Get.put(UserController());

    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Chat App Challenge',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: blackColor,
          actions: [
            IconButton(
                onPressed: () {
                  Get.dialog(AlertDialog(
                      title: const Text('Sign Out'),
                      content:
                          const Text('Are you sure you want to sign out ?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('NO', style: subtitleTextStyle)),
                        TextButton(
                            onPressed: () {
                              Get.back();
                              authController.signout();
                              Get.offAll(() => const SignInPage());
                            },
                            child: Text(
                              'YES',
                              style:
                                  primaryTextStyle.copyWith(color: Colors.red),
                            ))
                      ]));
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: StreamBuilder<List<UserModel>>(
          stream: userController.fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<UserModel> users = (snapshot.data ?? [])
                .where((element) => user?.uid != element.id)
                .toList();

            //if user is empty or null
            if (users.isEmpty) {
              return const Center(child: Text('No user found'));
            }

            return ListView.separated(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: subtitleColor,
                      radius: 25,
                      child: Text(users[index].userName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(users[index].userName),
                    subtitle: Text('No message',
                        style: primaryTextStyle.copyWith(
                            fontStyle: FontStyle.italic)),
                    onTap: () =>
                        Get.to(() => ChatPage(userToChat: users[index])),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                });
          },
        ));
  }
}
