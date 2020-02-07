import 'dart:io';

import 'package:chat_online/ui/chat_message.dart';
import 'package:chat_online/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser _currentUser;
  bool _isLoading = false;

  @override
  void initState()
  {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user)
    {
      _currentUser = user;
    });
  }

  Future<FirebaseUser> _getUser() async
  {
    if(_currentUser != null) return _currentUser;
    try
    {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential  = GoogleAuthProvider.getCredential
      (
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      final FirebaseUser user = authResult.user;
      return user;
    }
    catch(error)
    {
      return null;
    }
  }

  void _sendMessage({String text, File imgFile}) async
  {
    final FirebaseUser user = await _getUser();

    if (user == null)
    {
      _scaffoldKey.currentState.showSnackBar
        (
        SnackBar
          (
          content: Text('Não foi possível fazer o Login. Tente novamente!'),
          backgroundColor: Colors.red,
        ),
      );
    }

    Map<String, dynamic> data =
    {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
    };

    if (imgFile != null)
    {
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
          DateTime
              .now()
              .microsecondsSinceEpoch
              .toString()).putFile(imgFile);

      setState((){_isLoading = true;});
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
      setState((){_isLoading = false;});
    }

    if (text != null) data['text'] = text;
    Firestore.instance.collection('messages').document(
        DateTime
            .now()
            .microsecondsSinceEpoch
            .toString()).setData(data);

  }
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      key: _scaffoldKey,
      appBar: AppBar
      (
        title: Text("Chat online", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: <Widget>
        [
          _currentUser != null ?
              IconButton
              (
                icon: Icon(Icons.exit_to_app),
                onPressed: ()
                {
                  setState(()
                  {
                    FirebaseAuth.instance.signOut();
                    googleSignIn.signOut();
                    _currentUser = null;
                    _scaffoldKey.currentState.showSnackBar
                    (
                      SnackBar(content: Text('Você saiu com sucesso!'),)
                    );
                  });
                },
              ):
              Container(),
        ],
      ),
      body: Column
      (
        children: <Widget>
        [
          Expanded
          (
            child: StreamBuilder<QuerySnapshot>
            (
              stream: Firestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot)
              {
                if(_currentUser == null) return Center
                (
                  child: RaisedButton
                  (
                    child: Text("Log in"),
                    onPressed: () async
                    {
                      final FirebaseUser user = await _getUser();
                      setState(()
                      {
                        _currentUser = user;
                      });
                    },
                  ),
                );
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    _getUser();
                    return Center
                    (
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                    return ListView.builder
                    (
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index)
                      {
                        return ChatMessage(documents[index].data, documents[index].data['uid'] == _currentUser.uid);
                      }
                    );
                }
              },
            ),
          ),
          _isLoading ? LinearProgressIndicator():Container(),
          TextComposer(_sendMessage),
        ]
      ),
    );
  }
}
