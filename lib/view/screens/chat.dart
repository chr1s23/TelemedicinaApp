import 'dart:async';

import 'package:chatbot/view/screens/scanner.dart';
import 'package:chatbot/service/chat_service.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<Chat> {
  final ChatService chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "¡Hola! Soy HelpyChat. ¿En qué puedo ayudarte hoy?",
      "isBot": true
    },
  ];

  bool _isLoading = false;
  int _loadingIndex = 0;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    chatService.connect();
    chatService.socket.on('bot_uttered', (data) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingTimer?.cancel(); // Detener animación
          // Elimina el mensaje de "Generando respuesta..."
          _messages.removeWhere((msg) => msg["loading"] == true);
          _messages.add({"text": "${data['text']}", "isBot": true});
        });
      }
    });
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"text": message, "isBot": false});
        _isLoading = true;
        _messages.add({"isLoading": true});
        //_messages.add({
        //  "text": "Generando respuesta...",
        //  "isBot": true,
        //  "loading": true
        //}); // Mensaje de carga
      });

      FocusScope.of(context).unfocus(); // Ocultar el teclado

      _startLoadingAnimation(); // Iniciar animación de puntos

      chatService.sendMessage(message,
          "a689c9c374a744efa19d498c68f54172"); //cambiar el identificador por el publicId del usuario
      _messageController.clear();
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
        _loadingIndex = (_loadingIndex + 1) % 4; // Rotar los puntos
      });
    });
  }

  @override
  void dispose() {
    chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatMessages()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Image.asset('assets/images/chatbot.png',
              height: 30), // Ícono del chatbot
          const SizedBox(width: 10),
          Text(
            "HELPYCHAT",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(165, 16, 08, 1)),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Image.asset('assets/images/qrscan.png',
              height: 30), // Ícono de QR
          onPressed: () {
            // Acción de escanear QR
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Scanner()));
          },
        ),
      ],
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(10),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildChatBubble(_messages[_messages.length - 1 - index]);
      },
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    if (message.containsKey('isLoading') && message['isLoading'] == true) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Escribiendo${'.' * _loadingIndex}",
            style: const TextStyle(fontSize: 11, color: Colors.black),
          ),
        ),
      );
    }

    bool isBot = message["isBot"];
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot ? Colors.white : const Color.fromRGBO(0, 40, 86, 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(12),
            bottomRight: isBot ? const Radius.circular(12) : const Radius.circular(0),
          ),
        ),
        child: Text(
          message["text"],
          style: TextStyle(fontSize: 11, color: isBot ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  // Animación de los tres puntos
  Widget _dotAnimation(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      onEnd: () {
        Future.delayed(Duration(milliseconds: delay), () {
          if (mounted) setState(() {});
        });
      },
      child: const CircleAvatar(radius: 3, backgroundColor: Colors.grey),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                hintStyle: TextStyle(
                    color: Color.fromRGBO(111, 111, 111, 1), fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Color.fromRGBO(0, 40, 86, 1),
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
