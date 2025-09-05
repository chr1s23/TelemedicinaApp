import 'dart:async';
import 'dart:convert';

import 'package:chatbot/model/requests/message_request.dart';
import 'package:chatbot/model/requests/salud_sexual_request.dart';
import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/view/screens/scanner.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';

Logger _log = Logger('FormChat');

String? userId;

Future<String> getUserId() async {
  userId = await secureStorage.read(key: "user_id");
  if (userId != null) {
    _log.fine("Clean user ID: $userId");
  } else {
    _log.severe("User ID not found in secure storage.");
  }

  return userId!;
}

class FormChat extends StatefulWidget {
  const FormChat({super.key});

  @override
  State<FormChat> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<FormChat> {
  SesionChatRequest? sesionChat;
  SaludSexualRequest saludSexual = SaludSexualRequest(false, null, null, null, null, null, null);
  bool completeForm = false;
  bool colectInformation = false;
  final focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic> offlineMessages = {};
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool inputNumber = false;
  bool showInputText = false;
  bool showDatePickerSelector = false;
  List<Map<String, dynamic>>? _quickReplies;

  final DateTime now = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime firstAllowedDate =
        DateTime(now.year, now.month - 3, now.day);
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

  void initSesionChat() async {
    sesionChat = SesionChatRequest(await getUserId(), null, null, DateTime.now().toIso8601String().split('.').first, null);
  }

  @override
  void initState() {
    super.initState();
    loadChatForm();
  }

  void loadChatForm() async {
    final jsonString = await rootBundle.loadString('assets/offline_form.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    offlineMessages = Map<String, dynamic>.from(data);
    _sendMessage(offlineMessages["Iniciar proceso"]);
  }

  void _initVideoPlayer() async {
    var (video, chewie) = await initializeVideoPlayer(
      'assets/videos/automuestreo.mp4',
      autoPlay: false,
    );

    _videoController = video;
    _chewieController = chewie;

    setState(() {});
  }

  void _sendMessage([Map<String, dynamic>? dataPayload]) async {
    showInputText = false;
    if (dataPayload != null && dataPayload.containsKey('selector_fecha')) {
      showDatePickerSelector = true;
    }
    if (dataPayload != null && dataPayload.containsKey('teclado_numerico')) {
      inputNumber = true;
    }
    _quickReplies = null;
    String message =
        dataPayload?['title'] ?? _messageController.value.text.trim();
    if (message.isNotEmpty) {
      if (_messages.isNotEmpty) {
        if (_messages.last["response"].toString().startsWith(
            "Todo listo! Hemos determinado que **sí eres apta para realizarte el Automuestreo**.")) {
          saludSexual.fechaUltimaMenstruacion =
              dataPayload?['payload'] ?? message;
          dataPayload = offlineMessages["selecciono_fecha"];
        } else if (_messages.last["response"] ==
            "¿Hace cuánto fué tu útltimo examen de Papanicolaou (Pap)?") {
          saludSexual.ultimoExamenPap = dataPayload?['payload'];
          dataPayload = offlineMessages["ultimo_pap"];
        } else if (_messages.last["response"] ==
            "¿Cuándo fué tu última prueba de Virus del Papiloma Humano (VPH)?") {
          saludSexual.tiempoPruebaVph = dataPayload?['payload'];
        } else if (_messages.last["response"].toString().startsWith(
            "Por favor, indica el número de parejas sexuales que has tenido")) {
          saludSexual.numParejasSexuales = int.parse(message);
          dataPayload = offlineMessages["teclado_numerico"];
        } else if (_messages.last["response"].toString().startsWith(
            "¿Ha sido diagnosticado o sospecha de tener alguna Infección de Transmisión Sexual")) {
          saludSexual.tieneEts = message;
        } else if (_messages.last["response"].toString().startsWith(
            "Por favor, indica el nombre de la Infección de Transmisión Sexual (ITS) que tienes")) {
          saludSexual.nombreEts = message;
        }
      }
      setState(() {
        _messages.add({"response": message, "isBot": false});
      });

      FocusScope.of(context).unfocus();

      if (dataPayload?["response"] == "formulario_completo") {
        dataPayload = offlineMessages["formulario_completo"];
      }

      _messages.add({"response": dataPayload?['response'], "isBot": true});

      if (dataPayload?['quick_replies'] != null) {
        _quickReplies = List<Map<String, dynamic>>.from(
            dataPayload?['quick_replies'] as List<dynamic>);

        bool processFinished = _quickReplies!
            .any((answer) => (answer["title"] == "¡Escanear dispositivo!"));

        if (processFinished) {
          _initVideoPlayer();
          completeForm = true;
          _log.fine(jsonEncode(saludSexual).toString());
        }
      }

      if (_messages.isNotEmpty &&
          !_messages.last["response"].toString().startsWith(
              "Por favor, indica el número de parejas sexuales que has tenido") &&
          inputNumber) {
        inputNumber = false;
        dataPayload = offlineMessages["teclado_numerico"];
      }
      if (_messages.isNotEmpty &&
          !_messages.last["response"].toString().startsWith(
              "Todo listo! Hemos determinado que **sí eres apta para realizarte el Automuestreo**.") &&
          showDatePickerSelector) {
        showDatePickerSelector = false;
      }
    }
    _messageController.clear();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initSesionChat();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        final bool shouldPop = await modalYesNoDialog(
              context: context,
              title: "¿Salir del chat?",
              message: "Se perderá todo el proceso de Automuestreo.",
              onYes: () {},
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
                      text: message["response"],
                      sender: message["isBot"] ? Sender.bot : Sender.user,
                      loading: message["loading"] ?? false);

                  return _buildChatBubble(messageRequest);
                },
              )),
              if (_quickReplies == null || showInputText) _buildMessageInput(),
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
                  sesionChat!.fin =
                      DateTime.now().toIso8601String().split('.').first;
                  sesionChat!.contenido = jsonEncode(_messages);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Scanner(sesion: sesionChat, salud: saludSexual)));
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildChatBubble(MessageRequest message) {
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
                    _mostrarDialogo(context, answer["response"]);
                  } else if (answer["title"] == "Ver video") {
                    showVideoDialog(context);
                  } else if (answer["title"] == "¡Escanear dispositivo!") {
                    sesionChat!.fin =
                        DateTime.now().toIso8601String().split('.').first;
                    sesionChat!.contenido = jsonEncode(_messages);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scanner(
                                sesion: sesionChat, salud: saludSexual)));
                  } else {
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

  Widget _dateSelector() {
    return ElevatedButton(
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
            child:
                Icon(Icons.calendar_today, color: AllowedColors.gray, size: 20),
          ),
          Expanded(
            child: Text(
              "dd/MM/yyyy",
              style: TextStyle(fontSize: 16, color: AllowedColors.black),
            ),
          ),
        ],
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
                hintText: "Ingresa un número...",
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

  void showVideoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true, // Permite que el diálogo ocupe más espacio
      backgroundColor: Colors.transparent, // Fondo transparente
      builder: (context) {
        return Container(
          width: double.infinity, // Ocupa todo el ancho disponible
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white, // Fondo del diálogo
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.close, color: AllowedColors.red, size: 24),
                  onPressed: () {
                    _videoController?.pause();
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: buildVideoPlayer(_videoController, _chewieController),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  color: AllowedColors.red,
                  onPressed: () {
                    _videoController?.pause();
                    Navigator.pop(context);
                  },
                  label: "Entendido",
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
