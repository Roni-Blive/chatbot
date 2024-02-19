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
  const apiKey = "apicode_goes_here";
  var url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$apiKey");
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "O que é o Jaé?"},
            {
              "text":
                  "O Jaé é uma plataforma de bilhetagem digital e mobilidade urbana.Com o Jaé você poderá pagar a sua passagem de forma simples e prática com QR Code, utilizando apenas o seu celular.Nosso objetivo é trazer simplicidade, facilidade e praticidade para o usuário de transporte, oferecendo produtos e serviços de qualidade."
            },
            {"text": "Com quem estou falando?"},
            {"text": "Olá sou assitente virtual da Conta Pagamento Jaé"},
            {
              "text":
                  "Como vai funcionar a Operação Parcial BRT (primeira fase)?"
            },
            {
              "text":
                  "Em julho iniciamos a operação parcial no BRT (primeira fase).Nesta fase não temos integração com outros modais de transporte (ônibus, vans, VLT, etc). Você, que utiliza somente o BRT como meio de transporte, pode pagar sua passagem com QR Code ou cartão Jaé, que pode ser adquirido nas máquinas de autoatendimento localizadas nas estações do BRT."
            },
            {"text": "Olá"},
            {
              "text":
                  "Você está conversando com um assistente virtual da Conta Pagamento Jaé. Como posso te ajudar?"
            },
            {
              "text":
                  "Quais são os meios de pagamento aceitos para pagar a passagem no BRT?"
            },
            {"text": "Você pode pagar sua passagem com QR Code ou cartão Jaé."},
            {"text": "O que é o App Jaé?"},
            {
              "text":
                  "O App Jaé foi desenvolvido para você ter praticidade ao realizar o pagamento da sua passagem no transporte público. Com o App você pode: \n- Pagar a sua passagem no celular, por meio de QR Code Consultar saldo,\n- Ver o extrato de utilizaçãoFazer recarga por PIX, crédito ou boleto,\n- E muito mais!"
            },
            {"text": "Quais são as formas de pagamento aceitas no App/Site?"},
            {
              "text":
                  "PIX, Cartão de crédito (Visa, Mastercard ou Elo), Boleto."
            },
            {
              "text": "Qual é o valor mínimo e máximo para recarga no App/Site?"
            },
            {
              "text":
                  "Valor mínimo:\n- R\$ 10,00 (pix e crédito)\n- R\$ 50,00 (boleto)\n\nValor máximo:\n- R\$ 2.000,00 (PIX)\n- R\$ 200,00 (cartão de crédito) – 1x ao dia"
            },
            {"text": "Como pagar minha passagem por QR Code?"},
            {
              "text":
                  "O usuário gera a imagem do QR Code no App, aproxima o celular na parte de baixo do validador e paga a passagem.Este QR Code tem validade por até 4 horas."
            },
            {"text": "Bom dia"},
            {
              "text":
                  "Bom dia! Você está conversando com um assistente virtual da Conta Pagamento Jaé. Como posso te ajudar?"
            },
            {"text": "O que é a conta pagamento Jaé"},
            {
              "text":
                  "A conta pagamento Jaé é uma conta digital pré-paga com a qual você pode movimentar recursos financeiros e fazer transações de pagamento usando seu Cartão Jaé."
            },
            {"text": "Boa tarde"},
            {
              "text":
                  "Boa tarde! Você está conversando com um assistente virtual da Conta Pagamento Jaé. Como posso te ajudar?"
            },
            {"text": "Bora noite"},
            {
              "text":
                  "Boa noite! Você está conversando com um assistente virtual da Conta Pagamento Jaé. Como posso te ajudar?"
            },
            {"text": "Boa tarde!"},
            {"text": prompt},
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
