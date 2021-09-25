import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DepoSms/globals.dart' as globals;

import '../main.dart';

class FilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("asd");
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: globals.colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: "file",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white/*Color(0x773f1272)*/,
          title: Text("A beolvasott tartalom" ,style: TextStyle(color: Color(0xff3f1272)),),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: Color(0xff3f1272),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: smsListToShow.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${smsListToShow[index]}'),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );
  }

}