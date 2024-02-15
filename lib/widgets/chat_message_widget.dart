import 'package:chatbot/components/chat_message_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        color: chatMessageType == ChatMessageType.bot
            ? const Color(0xFF444654)
            : const Color(0xFF343541),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chatMessageType == ChatMessageType.bot
                ? Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(16, 162, 127, 1),
                      child: Image.asset(
                        "images/gemini.png",
                        scale: 1.5,
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF444654),
                      child: Icon(CupertinoIcons.person_alt),
                    ),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
