
import 'package:DepoSms/compontents/delete_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DepoSms/globals.dart' as globals;

import '../main.dart';
import '../compontents/refresh_button.dart';

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}


class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: globals.colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: "stat",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Eredmények", style: TextStyle(color: Color(0xff3f1272)),),

          actions: [
            BackButton(
              color: Color(0xff3f1272),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
            DeleteButton(
              iconColor: Color(0xff3f1272),
              onPressed: () async{
                //_deleteDB();
                _showDialog();

              },
            ),
            RefreshButton(
              iconColor: Color(0xff3f1272),
              onPressed: () async {
                await fillResultListFromDB();
                setState(() {

                });
              },
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: smsResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${smsResults[index]}', style: smsResults[index].contains("SMS küldése sikertelen!")?TextStyle(color: Colors.red): TextStyle(color: Colors.black),),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },

        ),
      ),
    );


  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Biztosan töröljük az adatbázist?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Töröl"),
              onPressed: () async {
                await _deleteDB();
                setState(() {
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Mégsem"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDB() async {
    await globals.dbHelper.deleteDB();
    smsResults.clear();
  }

  Future<void> fillResultListFromDB() async{
    smsResults.clear();
    final allRows = await globals.dbHelper.queryAllRows();
    for(int i=0;i<allRows.length;i++){
      smsResults.add(
          allRows[i]['number'] + "-részére: " + allRows[i]['feedback'] +"\n\n" + allRows[i]['time'] + " \n\n");
    }
  }


}

