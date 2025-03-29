import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:chatbot/model/requests/message_request.dart';
import 'package:chatbot/view/screens/scanner.dart';
import 'package:chatbot/service/chat_service.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:logging/logging.dart';

Logger _log = Logger('Chat');

String? userId;

Future<String> getUserId() async {
  if (userId == null) {
    userId = await secureStorage.read(key: "user_id");

    if (userId != null) {
      _log.fine("Clean user ID: $userId");
    } else {
      _log.severe("User ID not found in secure storage.");
    }
  }

  return userId!;
}

class Chat extends StatefulWidget {
  Chat({super.key, this.autoStart = false});

  bool autoStart;
  bool completeForm = false;

  @override
  State<Chat> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<Chat> {
  final focusNode = FocusNode();
  final ChatService chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  int _loadingIndex = 0;
  Timer? _loadingTimer;
  List<Map<String, dynamic>>? _quickReplies;

  @override
  void initState() {
    super.initState();
    chatService.connect();
    chatService.socket.on('bot_uttered', (data) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingTimer?.cancel(); // Detener animación
          _messages.removeWhere((msg) => msg["loading"] == true);
          _messages.add({"text": "${data['text']}", "isBot": true});

          if (data['quick_replies'] != null) {
            _quickReplies = List<Map<String, dynamic>>.from(data['quick_replies'] as List<dynamic>);
          }
        });
      }
    });
  }

  void _sendMessage([Map<String, dynamic>? dataPayload]) async {
    String message = dataPayload?['title'] ?? _messageController.value.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"text": message, "isBot": false});
        _isLoading = true;
        _messages.add({"text": '', "loading": true, "isBot": true});
      });

      FocusScope.of(context).unfocus(); // Ocultar el teclado

      _startLoadingAnimation();

      chatService.sendMessage(dataPayload?['payload'] ?? message, await getUserId());
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
        _loadingIndex = (_loadingIndex + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    chatService.disconnect();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autoStart) {
      _sendMessage({"title": "Iniciar proceso", "payload:": "Iniciar proceso"});
      widget.autoStart = false;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        final bool shouldPop = await modalYesNoDialog(
          context: context, 
          title: "¿Salir del chat?", 
          message: "¿Seguro que desea salir? Se perderá todo el contenido del chat.", 
          onYes: () async {chatService.reset(await getUserId());},
        ) ?? false;

        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  //controller: chatProvider.chatScrollController,
                reverse: true,
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length + (_quickReplies != null ? 1: 0),
                itemBuilder: (context, index) {
                  //final message = chatProvider.messages[index];
                  
                  if (_quickReplies != null) {
                    index = index - 1;
                  }

                  if (index < 0) {
                    return _replyButtons(_quickReplies!);
                  }

                  final message = _messages[_messages.length - 1 - index];
                  final messageRequest = MessageRequest(
                      text: message["text"],
                      sender: message["isBot"] ? Sender.bot : Sender.user,
                      loading: message["loading"] ?? false);
      
                  return _buildChatBubble(messageRequest);
                },
              )),
              if (_quickReplies == null) _buildMessageInput(),
              //buildTextField(chatProvider.sendMessage)
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: AllowedColors.gray),
      elevation: 0,
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
      centerTitle: false,
      actions: [
        IconButton(
          icon: Image.asset('assets/images/qrscan.png',
              height: 30), // Ícono de QR
          onPressed: widget.completeForm ? () {
            // Acción de escanear QR
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Scanner()));
          } : null,
        ),
      ],
    );
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
          data:  message.text.replaceAll("\n", "  \n"),
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(color: isBot ? AllowedColors.black : AllowedColors.white),
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
                  answer["title"]!,
                  style: const TextStyle(
                    fontSize: 15
                  ),
                ),
                onPressed: () {
                  _quickReplies = null;
                  _sendMessage(answer);
                },
              ))
          .toList(),
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
                    color: AllowedColors.gray, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AllowedColors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: AllowedColors.blue,
            radius: 25,
            child: IconButton(
              icon: const Icon(Icons.send, color: AllowedColors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void showImageDialog(BuildContext context) {
    String base64String =
        "iVBORw0KGgoAAAANSUhEUgAAATMAAAGdCAYAAAB+TpTAAAAxL3pUWHRSYXcgcHJvZmlsZSB0eXBlIGV4aWYAAHjarZxZsly3ckX/MQoNAT0Sw0Eb4Rl4+F4bVSRFPenZYVskb1OqOg2QuZtE4rjzn/9x3R9//BFCqNnl0qz2Wj3/5Z57HPxg/vPffF+Dz+/r+y+l70/h99dd398fI9+T3vn5Hz1+D3Z4nZ/D9/f+PUn48f4fB/rxQxj8VH79jzG+r8/fX5/fA0b764G+V5DC58x+fz/wPVCK3yvKn9/X94pqt/bbre31PXP+vmS//uXUYi01tMzXHH1rtfOzRZ8b47l1oXfF/g5UPgP684Ufv/94a+Sa4kkheb7GFD9XmfQvpcH3zFded7wxJOOXwnd9TW/gPVPJJXCl/Xui761qMP88Nr/G6B/++5/c1jdMXhj8nLV5fp7ht/j4+dNfwqON7+vp8/rPA/n68/tv0/rj9VD+8nr6eZr42xXZrzPHP19RqHH8ds9/mtV7t9173ptdHrlyz/V7Uz9u5f3EG6dG632s8qfxr/Bze386f8wPvwid7fwioya/ .....";

    Uint8List imageBytes = base64Decode(base64String);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.memory(imageBytes, fit: BoxFit.contain),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(ValueChanged<String> onValue) {
    final outlineInputBorder = UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(30));

    return TextFormField(
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        focusNode: focusNode,
        controller: _messageController,
        onFieldSubmitted: (value) {
          _messageController.clear();
          focusNode.unfocus();
          onValue(value);
        },
        decoration: InputDecoration(
            filled: true,
            hintText: "Escribe tu mensaje...",
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            suffixIcon: IconButton(
                onPressed: () {
                  final value = _messageController.value.text;
                  onValue(value);
                },
                icon: const Icon(Icons.send_outlined))));
  }
}
