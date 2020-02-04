import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget
{
  ChatMessage(this.data, this.mine);

  final bool mine;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context)
  {
    double boxSize = MediaQuery.of(context).size.width*0.6;

    return Container
    (
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row
      (
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>
        [
          mine ?
          CircleAvatar
          (
            backgroundImage: NetworkImage(data['senderPhotoUrl']),
          ) :
          Container(),

          Expanded
          (
            child: Padding
            (
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column
                (
                crossAxisAlignment: mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: <Widget>
                [
                  data['imgUrl'] != null ?
                    Image.network
                    (
                      data['imgUrl'],
                      width: boxSize,
                      height: boxSize,
                      fit: BoxFit.cover,
                    ) :
                    Text
                    (
                      data['text'],
                      style: TextStyle
                      (
                        fontSize: 16,
                      ),
                    ),

                  Text
                  (
                    data['senderName'],
                    style: TextStyle
                    (
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ),

          !mine ?
          CircleAvatar
            (
            backgroundImage: NetworkImage(data['senderPhotoUrl']),
          ) :
          Container(),
        ],
      ),
    );
  }
}
