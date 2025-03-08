enum Sender { bot, user}

class MessageRequest {
  final String text;
  final String? link;
  final Sender sender;
  final bool loading;

  MessageRequest({required this.text, this.link, required this.sender, required this.loading});

}