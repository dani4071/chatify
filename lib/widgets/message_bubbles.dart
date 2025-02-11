import 'package:chatify/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class textMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  textMessageBubble({
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorSheme = isOwnMessage
        ? [
            const Color.fromRGBO(0, 136, 249, 1.0),
            const Color.fromRGBO(0, 82, 218, 1.0),
          ]
        : [
            const Color.fromRGBO(51, 49, 68, 1.0),
            const Color.fromRGBO(51, 49, 68, 1.0),
          ];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: _colorSheme,
            stops: [0.30, 0.70],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            message.content,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            timeago.format(message.sentTime),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}



class imageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  imageMessageBubble({
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorSheme = isOwnMessage
        ? [
      const Color.fromRGBO(0, 136, 249, 1.0),
      const Color.fromRGBO(0, 82, 218, 1.0),
    ]
        : [
      const Color.fromRGBO(51, 49, 68, 1.0),
      const Color.fromRGBO(51, 49, 68, 1.0),
    ];

    DecorationImage _image = DecorationImage(
      image: NetworkImage(message.content), fit: BoxFit.cover,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: _colorSheme,
            stops: [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          Text(
            timeago.format(message.sentTime),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }


}
