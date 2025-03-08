import 'package:chatbot/model/requests/message_request.dart';
import 'package:chatbot/service/chat_service.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final chatScrollController = ScrollController();
  final ChatService chatService = ChatService();
  final List<MessageRequest> messages = [
    MessageRequest(
        text: "¡Hola! Soy HelpyChat. ¿En qué puedo ayudarte hoy?",
        sender: Sender.bot,
        loading: false)
  ];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    final newMessage =
        MessageRequest(text: text, sender: Sender.user, loading: false);

    messages.add(newMessage);

    notifyListeners();
    moveScrollToBottom();
    getMessage(text);
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Future<void> getMessage(text) async {
    final newMessage =
        MessageRequest(text: text, sender: Sender.user, loading: false);

    messages.add(newMessage);

    notifyListeners();
    moveScrollToBottom();
  }
}
