import 'dart:async';
import 'dart:convert';

import 'package:chatbot/model/requests/message_request.dart';
import 'package:chatbot/utils/dashboard_listener.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OfflineChat extends StatefulWidget {
  const OfflineChat({super.key});

  @override
  State<OfflineChat> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<OfflineChat> {
  final focusNode = FocusNode();
  final List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic> offlineMessages = {};

  bool _isLoading = false;
  int _loadingIndex = 0;
  Timer? _loadingTimer;
  List<Map<String, dynamic>>? _quickReplies = [
    {"title": "¿Qué es el VPH?", "payload": ""},
    {"title": "¿Qué es el Cáncer de Cuello Uterino?", "payload": ""},
    {"title": "¿Qué es el Automuestreo?", "payload": ""},
    {"title": "Violencia de Género", "payload": ""}
  ];

  @override
  void initState() {
    super.initState();
    loadChatRules();
    _messages.add({
      "response":
          '👋 ¡Hola! Soy tu asistente virtual de salud.\nEn este momento **no tienes conexión a internet**. Sin embargo, puedo responderte las preguntas que están a continuación.\nPor favor, **presiona el botón con la pregunta que quieras conocer!**',
      "isBot": true
    });
  }

  void loadChatRules() async {
    final jsonString =
        await rootBundle.loadString('assets/offline_messages.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    offlineMessages = Map<String, dynamic>.from(data);
  }

  void _sendMessage([Map<String, dynamic>? dataPayload]) async {
    _quickReplies = null;
    String message = dataPayload?['title'];

    if (message == "¿Qué es el VPH?") {
      dataPayload = offlineMessages[message];
    } else if (message == "¿Qué es el Cáncer de Cuello Uterino?") {
      dataPayload = offlineMessages[message];
    } else if (message == "¿Qué es el Automuestreo?") {
      dataPayload = offlineMessages[message];
    } else if (message == "Violencia de Género") {
      dataPayload = offlineMessages[message];
    } else if (message == "Regresar") {
      _messages.clear();
      _messages.add({
        "response":
            '👋 ¡Hola! Soy tu asistente virtual de salud.\nEn este momento **no tienes conexión a internet**. Sin embargo, puedo responderte las preguntas que están a continuación.\nPor favor, **presiona el botón con la pregunta que quieras conocer!**',
        "isBot": true
      });
      _quickReplies = [
        {"title": "¿Qué es el VPH?", "payload": ""},
        {"title": "¿Qué es el Cáncer de Cuello Uterino?", "payload": ""},
        {"title": "¿Qué es el Automuestreo?", "payload": ""},
        {"title": "Violencia de Género", "payload": ""}
      ];
      setState(() {});
      return;
    }
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"response": message, "isBot": false});
        _isLoading = true;
        _messages.add({"response": '', "loading": true, "isBot": true});
      });

      FocusScope.of(context).unfocus(); // Ocultar el teclado

      _startLoadingAnimation();

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isLoading = false;
        _loadingTimer?.cancel(); // Detener animación
        _messages.removeWhere((msg) => msg["loading"] == true);

        _messages.add({"response": dataPayload?['response'], "isBot": true});

        if (dataPayload?['quick_replies'] != null) {
          _quickReplies = List<Map<String, dynamic>>.from(
              dataPayload?['quick_replies'] as List<dynamic>);
        }
      });
    }
  }

  void _startLoadingAnimation() {
    _loadingTimer?.cancel();
    _loadingIndex = 0;
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isLoading) {
        timer.cancel();
        return;
      }
      setState(() {
        _loadingIndex = (_loadingIndex + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        final bool shouldPop = await modalYesNoDialog(
              context: context,
              title: "¿Salir del chat?",
              message: "Se perderá todo el contenido del chat.",
              onYes: () {},
            ) ??
            false;

        if (context.mounted && shouldPop) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardListener(
                      wasOffline: true,
                      child: Dashboard(
                        hasInternet: false,
                      ))),
              (_) => false);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length + (_quickReplies != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_quickReplies != null) {
                    index = index - 1;
                  }

                  if (index < 0) {
                    return _replyButtons(_quickReplies!);
                  }

                  final message = _messages[_messages.length - 1 - index];
                  final messageRequest = MessageRequest(
                      text: message["response"],
                      sender: message["isBot"] ? Sender.bot : Sender.user,
                      loading: message["loading"] ?? false);

                  return _buildChatBubble(messageRequest);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        iconTheme: IconThemeData(color: AllowedColors.gray),
        elevation: 10,
        title: Row(
          children: [
            Image.asset('assets/images/chatbot.png',
                height: 30), // Ícono del chatbot
            const SizedBox(width: 10),
            Text(
              "SISA CHAT",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AllowedColors.red),
            ),
          ],
        ),
        centerTitle: false);
  }

  Widget _buildChatBubble(MessageRequest message) {
    if (message.loading) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AllowedColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '.' * _loadingIndex,
            style: const TextStyle(fontSize: 12, color: AllowedColors.black),
          ),
        ),
      );
    }

    bool isBot = message.sender == Sender.bot;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot ? AllowedColors.white : AllowedColors.blue,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isBot ? const Radius.circular(0) : const Radius.circular(12),
            bottomRight:
                isBot ? const Radius.circular(12) : const Radius.circular(0),
          ),
        ),
        child: MarkdownBody(
          data: message.text.replaceAll("\n", "  \n"),
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
                color: isBot ? AllowedColors.black : AllowedColors.white),
          ),
        ),
      ),
    );
  }

  Widget _replyButtons(List<Map<String, dynamic>> answers) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: answers
          .map((answer) => ElevatedButton(
                child: Text(
                  textAlign: TextAlign.center,
                  answer["title"]!,
                  style: const TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  if (answer["title"] == "Más información") {
                    _mostrarDialogo(context, answer["response"]);
                  } else {
                    //_quickReplies = null;
                    _sendMessage(answer);
                  }
                },
              ))
          .toList(),
    );
  }

  void _mostrarDialogo(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AllowedColors.white,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Más información",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: text.replaceAll("\n", "  \n"),
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: AllowedColors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                    child: Text(
                      "Cerrar",
                      style: TextStyle(color: AllowedColors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
