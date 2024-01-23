import 'package:chat_app_chalenge/theme.dart';
import 'package:flutter/material.dart';

class BubbleChatWidget extends StatelessWidget {
  final bool isSender;
  final String message;
  const BubbleChatWidget(
      {super.key, required this.isSender, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
          crossAxisAlignment:
              (isSender) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  (isSender) ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Flexible(
                    child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: (isSender) ? blackColor : subtitleColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular((isSender) ? 12 : 0),
                          topRight: Radius.circular((isSender) ? 0 : 12),
                          bottomRight: const Radius.circular(12),
                          bottomLeft: const Radius.circular(12))),
                  child: Text(message,
                      style: primaryTextStyle.copyWith(color: whiteColor)),
                ))
              ],
            )
          ]),
    );
  }
}
