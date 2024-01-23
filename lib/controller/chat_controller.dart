import 'package:chat_app_chalenge/data/models/channel_model.dart';
import 'package:chat_app_chalenge/data/models/message_model.dart';
import 'package:chat_app_chalenge/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  // UserController userController = Get.put(UserController());

  String channelId(String id1, String id2) {
    if (id1.hashCode < id2.hashCode) {
      return '$id1-$id2';
    }
    return '$id2-$id1';
  }

  Stream<List<ChannelModel>> channelStream(String userId) {
    return FirebaseFirestore.instance
        .collection('channels')
        .where('memberIds', arrayContains: userId)
        .orderBy('lastTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<ChannelModel> channels = [];
      for (var element in querySnapshot.docs) {
        channels.add(ChannelModel.fromDocumentSnapshot(element));
      }
      return channels;
    });
  }

  Future<void> updateChannel(
      String channelId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addMessage(MessageModel message) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<MessageModel>> messageStream(String channelId) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('channelId', isEqualTo: channelId)
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((snapshot) {
      List<MessageModel> messages = [];

      for (var message in snapshot.docs) {
        messages.add(MessageModel.fromDocumentSnapshot(message));
      }

      return messages;
    });
  }

  void sendMessage(UserModel partnerUser) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (messageController.text.trim().isEmpty) {
      return;
    }

    // channel not created yet
    final channel = ChannelModel(
        id: channelId(user!.uid, partnerUser.id),
        memberIds: [user.uid, partnerUser.id],
        lastMessage: messageController.text.trim(),
        lastTime: Timestamp.now(),
        unRead: {user.uid: false, partnerUser.id: false},
        members: [UserModel.fromFirebaseUser(user), partnerUser],
        sendBy: user.uid);

    await updateChannel(channel.id, channel.toMap());

    DocumentReference<Map<String, dynamic>> docRefMessage =
        FirebaseFirestore.instance.collection('messages').doc();

    /// NOTE: This is define the message
    final message = MessageModel(
        id: docRefMessage.id,
        textMessage: messageController.text.trim(),
        senderId: user.uid,
        sendAt: Timestamp.now(),
        channelId: channel.id);

    /// NOTE: Add message to Firebase Firestore
    addMessage(message);

    final channelUpdateData = {
      'lastMessage': message.textMessage,
      'sendBy': user.uid,
      'lastTime': message.sendAt,
      'unRead': {user.uid: false, partnerUser.id: false},
    };

    updateChannel(channel.id, channelUpdateData);

    messageController.clear();
  }
}
