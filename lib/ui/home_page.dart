import 'package:chat_online/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  void _sendMessage(String text)
  {
    Firestore.instance.collection('messages').add(
    {
      'text': text,
      'date': DateTime.now().toUtc(),
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text("Chat online", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: TextComposer
      (
        (text)
        {
          print(text);
        }
      ),
    );
  }
}
