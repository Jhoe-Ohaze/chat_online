import 'package:chat_online/ui/text_composer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
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
      body: TextComposer(),
    );
  }
}
