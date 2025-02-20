import 'package:chatbot/scanner.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"text": "¡Hola! Soy HelpyChat. ¿En qué puedo ayudarte?", "isBot": true},
  ];

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"text": message, "isBot": false});
        _messages.add({"text": "Estoy procesando tu solicitud...", "isBot": true});
      });
      _messageController.clear();
    }
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
          Image.asset('assets/images/chatbot.png', height: 30), // Ícono del chatbot
          const SizedBox(width: 10),
          Text(
            "HELPYCHAT",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromRGBO(165, 16, 08, 1)),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Image.asset('assets/images/qrscan.png', height: 30), // Ícono de QR
          onPressed: () {
            // Acción de escanear QR
            Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner()));
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
    bool isBot = message["isBot"];
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot ? Color.fromRGBO(111, 111, 111, 1) : Color.fromRGBO(0, 40, 86, 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(12),
            bottomRight: isBot ? const Radius.circular(12) : const Radius.circular(0),
          ),
        ),
        child: Text(
          message["text"],
          style: TextStyle(fontSize: 10, color: Colors.black)
        ),
      ),
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
                          color: Color.fromRGBO(111, 111, 111, 1),
                          fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
