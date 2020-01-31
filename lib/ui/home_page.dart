import 'dart:io';

import 'package:chat_online/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  void _sendMessage({String text, File imgFile}) async
  {
    Map<String, dynamic> data = {};

    Firestore.instance.collection('messages').add(
    {
      'text': text,
    });
    if(imgFile != null)
    {
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
          DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    if(text != null) data['text'] = text;
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
      body: Column
      (
        children: <Widget>
        [
          Expanded
          (
            child: StreamBuilder
            (
              stream: Firestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot)
              {
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center
                    (
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    return ListView.builder
                    (
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index)
                        {
                          
                        }
                    );
                }
              },
            ),
          ),
          TextComposer(_sendMessage),
        ]
      ),
    );
  }
}
