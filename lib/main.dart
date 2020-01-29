import 'package:flutter/material.dart';

import 'ui/home_page.dart';

void main() async
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Chat Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
      (
        primarySwatch: Colors.red,
        iconTheme: IconThemeData
        (
          color: Colors.red,
        )
      ),
      home: HomePage(),
    );
  }
}
