import 'dart:convert';

import 'package:chatbot/components/chat_message_type.dart';
import 'package:chatbot/widgets/chat_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = "AIzaSyCP_MgpARKDGO2tsc_2lghzYsZz3NP2hps";
  var url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey");
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": prompt,
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.8,
        "maxOutputTokens": 1000,
      }
    }),
  );

  Map<String, dynamic> newResponse = jsonDecode(response.body);

  return newResponse["candidates"][0]["content"]["parts"][0]["text"];
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI ChatBot"),
        backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF343541),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  ChatMessage message = _messages[index];
                  return ChatMessageWidget(
                    text: message.text,
                    chatMessageType: message.chatMessageType,
                  );
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(color: Colors.white),
                        controller: _textController,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFF444654),
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !isLoading,
                      child: Container(
                        color: const Color(0xFF444654),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded),
                          color: const Color.fromRGBO(142, 142, 160, 1),
                          onPressed: () async {
                            setState(() {
                              _messages.add(
                                ChatMessage(
                                  text: _textController.text,
                                  chatMessageType: ChatMessageType.user,
                                ),
                              );
                              isLoading = true;
                            });

                            var input = _textController.text;
                            _textController.clear();

                            Future.delayed(const Duration(milliseconds: 50))
                                .then((_) => _scrollDown());

                            generateResponse(input).then((value) {
                              setState(() {
                                isLoading = false;
                                _messages.add(
                                  ChatMessage(
                                      text: value,
                                      chatMessageType: ChatMessageType.bot),
                                );
                              });
                            });
                            _textController.clear();
                            Future.delayed(const Duration(milliseconds: 50))
                                .then((_) => _scrollDown());
                          },
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
