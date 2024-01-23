import 'package:chat_app_chalenge/controller/chat_controller.dart';
import 'package:chat_app_chalenge/data/models/message_model.dart';
import 'package:chat_app_chalenge/data/models/user_model.dart';
import 'package:chat_app_chalenge/theme.dart';
import 'package:chat_app_chalenge/widgets/bubble_chat_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final UserModel userToChat;
  const ChatPage({super.key, required this.userToChat});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController());
    User? user = FirebaseAuth.instance.currentUser;

    Widget messageTextField() => Container(
        padding: const EdgeInsets.all(10),
        child: Container(
            height: 50,
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Center(
                child: Row(children: [
              Expanded(
                  child: TextFormField(
                      controller: chatController.messageController,
                      textCapitalization: TextCapitalization.words,
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Type a message...',
                          hintStyle: subtitleTextStyle))),
              IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => chatController.sendMessage(userToChat)),
            ]))));

    return Scaffold(
        appBar: AppBar(
            leading: CupertinoButton(
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(userToChat.userName,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: blackColor),
        body: Column(children: [
          Expanded(
              child: StreamBuilder<List<MessageModel>>(
            stream: chatController.messageStream(
                chatController.channelId(userToChat.id, user!.uid)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<MessageModel> messages = snapshot.data ?? [];

              if (messages.isEmpty) {
                return const Center(
                  child: Text('No message found'),
                );
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                reverse: true,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return BubbleChatWidget(
                      isSender: message.senderId == user.uid ? true : false,
                      message: message.textMessage);
                },
              );
            },
          )),
          messageTextField(),
        ]));
  }
}
