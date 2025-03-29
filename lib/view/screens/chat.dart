import 'dart:async';
import 'dart:convert';

import 'package:chatbot/model/requests/message_request.dart';
import 'package:chatbot/service/archivo_service.dart';
import 'package:chatbot/view/screens/scanner.dart';
import 'package:chatbot/service/chat_service.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  State<Chat> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<Chat> {
  bool completeForm = false;
  final focusNode = FocusNode();
  final ChatService chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  bool inputNumber = false;
  bool showInputText = false;
  bool showDatePickerSelector = false;
  int _loadingIndex = 0;
  Timer? _loadingTimer;
  List<Map<String, dynamic>>? _quickReplies;

  final DateTime now = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime firstAllowedDate =
        DateTime(now.year, now.month - 2, now.day);
    final DateTime lastAllowedDate = now.subtract(Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: firstAllowedDate,
      lastDate: lastAllowedDate,
    );
    if (picked != null) {
      setState(() {
        _messageController.text = picked
            .toIso8601String()
            .split("T")[0]
            .split("-")
            .reversed
            .join("/");
        showDatePickerSelector = false;
        _sendMessage();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    chatService.connect();
    chatService.socket.on('bot_uttered', (data) {
      if (mounted) {
        setState(() {
          showInputText = false;
          if (data.containsKey('selector_fecha')) {
            showDatePickerSelector = true;
          }
          if (data.containsKey('teclado_numerico')) {
            inputNumber = true;
          }
          _isLoading = false;
          _loadingTimer?.cancel(); // Detener animación
          _messages.removeWhere((msg) => msg["loading"] == true);
          if (data.containsKey('text')) {
            _messages.add({"text": "${data['text']}", "isBot": true});
          }

          if (data['quick_replies'] != null) {
            _quickReplies = List<Map<String, dynamic>>.from(
                data['quick_replies'] as List<dynamic>);

            bool containsVPHOrDiabetes = _quickReplies!.any((answer) =>
                answer.containsKey("payload") &&
                (answer["payload"] == "VPH" ||
                    answer["payload"] == "Diabetes" ||
                    answer["payload"] == "Ver video"));

            if (containsVPHOrDiabetes) {
              showInputText = true;
            }

            bool containsVerVideo = _quickReplies!.any((answer) =>
                answer.containsKey("payload") &&
                (answer["payload"] == "Ver video"));

            if (containsVerVideo) {
              completeForm = true;
            }
          }
        });
      }
    });
  }

  void _sendMessage([Map<String, dynamic>? dataPayload]) async {
    String message =
        dataPayload?['title'] ?? _messageController.value.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        if (inputNumber) {
          inputNumber = false;
        }
        _messages.add({"text": message, "isBot": false});
        _isLoading = true;
        _messages.add({"text": '', "loading": true, "isBot": true});
      });

      FocusScope.of(context).unfocus(); // Ocultar el teclado

      _startLoadingAnimation();

      chatService.sendMessage(
          dataPayload?['payload'] ?? message, await getUserId());
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
              message:
                  "¿Seguro que desea salir? Se perderá todo el contenido del chat.",
              onYes: () async {
                chatService.reset(await getUserId());
              },
            ) ??
            false;

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
                      text: message["text"],
                      sender: message["isBot"] ? Sender.bot : Sender.user,
                      loading: message["loading"] ?? false);
      
                  return _buildChatBubble(messageRequest);
                },
              )),
              if (showInputText) _buildMessageInput(),
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
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.qr_code_scanner,
              size: 30,
              color: completeForm ? AllowedColors.blue : AllowedColors.gray),
          onPressed: completeForm
              ? () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Scanner()));
                }
              : null,
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
    var buttons = Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: answers
          .map((answer) => ElevatedButton(
                child: Text(
                  answer["title"]!,
                  style: const TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  if (answer["title"] == "Más información") {
                    _mostrarDialogo(context, answer["payload"]);
                  } else if (answer["title"] == "Ver video") {
                    showImageDialog(context);
                  } else {
                    _quickReplies = null;
                    _sendMessage(answer);
                  }
                },
              ))
          .toList(),
    );

    if (showDatePickerSelector) {
      buttons.children.add(_dateSelector());
    }
    return buttons;
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
            height:
                MediaQuery.of(context).size.height * 0.9,
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
                    child: Text("Cerrar"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dateSelector() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AllowedColors.white,
          elevation: 2,
        ),
        onPressed: () {
          _selectDate(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.calendar_today,
                  color: AllowedColors.gray, size: 20),
            ),
            Expanded(
              child: Text(
                "dd/MM/yyyy",
                style: TextStyle(fontSize: 16, color: AllowedColors.black),
              ),
            ),
          ],
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
              keyboardType:
                  inputNumber ? TextInputType.number : TextInputType.text,
              inputFormatters: [
                inputNumber
                    ? FilteringTextInputFormatter.digitsOnly
                    : FilteringTextInputFormatter.singleLineFormatter
              ],
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                hintStyle: TextStyle(color: AllowedColors.gray, fontSize: 13),
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

  void showImageDialog(BuildContext context,
      {String nombreArchivo = "clias.png"}) async {
    String? base64String =
        await ArchivoService.getArchivo(context, nombreArchivo);

    if (base64String == null) return;

    Uint8List imageBytes = base64Decode(base64String);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AllowedColors.white,
          insetPadding: EdgeInsets.zero, // Elimina los márgenes del diálogo
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenHeight = MediaQuery.of(context).size.height;
              double screenWidth = MediaQuery.of(context).size.width;

              return Container(
                width: screenWidth, // Ocupar todo el ancho de la pantalla
                height: screenHeight * 0.95, // 90% del alto de la pantalla
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
                        icon: Icon(Icons.close,
                            color: AllowedColors.red, size: 30),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
