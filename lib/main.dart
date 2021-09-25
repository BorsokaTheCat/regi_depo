import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:DepoSms/compontents/custom_textfield.dart';
import 'package:DepoSms/compontents/list_item.dart';
import 'package:DepoSms/screens/content_screen.dart';
import 'package:DepoSms/screens/results_screen.dart';
import 'package:DepoSms/services/database_service.dart';
import 'package:DepoSms/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:sms/sms.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

import 'services/permission_service.dart';
import 'package:DepoSms/model/bean/Sms.dart';

Future<void> main() async {
  runApp(MyApp());
}

List<Sms> currentSmsList = List<Sms>();
List<String> smsResults = List<String>();
List<String> smsListToShow = List<String>();
List<Sms> smsListFromDb = List<Sms>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMS',
      theme: ThemeData(
        primarySwatch: globals.colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

String _path = 'Még nincs kiválasztva fájl.';

class _MyAppState extends State<MyHomePage> {
  String _status = ' ';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  bool _isButtonDisabled = false;
  bool _isInTheRightFormat = false;
  int currentSmsCounter = 0;
  int dbFirstIndex = 0;
  String showSms;

  var errorTxt = TextEditingController();
  final myController = TextEditingController(/*text: "5"*/);
  var txt = TextEditingController();

  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );

  @override
  void initState() {
    permissionAcessPhone();
    super.initState();
    _isButtonDisabled = false;
    currentSmsCounter = 0;
  }

  //db stuffs
  Future<int> _insert(Sms sms) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnNumber: sms.number,
      DatabaseHelper.columnMessage: sms.message,
      DatabaseHelper.columnFeedback: sms.feedback,
      DatabaseHelper.columnTime: sms.time
    };
    final id = await globals.dbHelper.insert(row);
    print('inserted row id: $id');
    if(currentSmsCounter==0 && dbFirstIndex==0){
      print('inserted row id: $currentSmsCounter and $dbFirstIndex');
      dbFirstIndex=id;
    }
    return id;
  }

  void _query() async {
    final allRows = await globals.dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  void _deleteDB() async {
    await globals.dbHelper.deleteDB();
  }

  Future<void> _update(int id, String feedback) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnTime: formattedDate,
      DatabaseHelper.columnFeedback: feedback,
    };
    final rowsAffected = await globals.dbHelper.update(row);
    print('updated $rowsAffected row(s)');

    print(id.toString() + "  " + feedback);
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await globals.dbHelper.queryRowCount();
    print(id);
    final rowsDeleted = await globals.dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _deleteId(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final id = await globals.dbHelper.queryRowCount();
    print(id);
    final rowsDeleted = await globals.dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  Future permissionAcessPhone() {
    PermissionService().requestPermission(onPermissionDenied: () {
      print('Permission has been denied');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: globals.colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.save, color: Color(0xff595669),),
            onPressed: () async {
              await fillResultListFromDB();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.open_in_new, color:Color(0xff595669),),
              onPressed: _pickFileInProgress ? null : _pickDocument,
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Center(
                  child: Image.asset(
                    "images/depo.png",
                    height: size.height * 0.45,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {
                    _showTheReadedNumbers();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilePage()),
                    );
                  },
                  child: ListItem(
                    title: '$_path',
                  ),
                ),
                CustomTextField(controller: myController,),
                SizedBox(
                  height: 50.0,
                ), Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    color: _isButtonDisabled ? Colors.grey : Color(0xff3f1272),
                    onPressed: () {
                      //smsList.clear();
                      _query();
                    },
                    child: const Text('db!',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    //elevation: 5,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    color: _isButtonDisabled ? Colors.grey : Color(0xff3f1272),
                    onPressed: () {
                      //smsList.clear();
                      for(int i=0;i<currentSmsList.length;i++){
                        print(currentSmsList[i].toString());
                      }
                    },
                    child: const Text('current!',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    //elevation: 5,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    color: _isButtonDisabled ? Colors.grey : Color(0xff3f1272),
                    onPressed: () {
                      _canWeSendSmses();
                    },
                    child: const Text('Küldés!',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    //elevation: 5,
                  ),
                ),
                Center(child: Text('$_status')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _canWeSendSmses() {
    if (_isButtonDisabled == true) {
    } else if (myController.text != "" && _path !='Még nincs kiválasztva fájl.' && _isInTheRightFormat==true) {
      _var();
    } else {
      Toast.show("Kérlek helyesen töltsd ki az adatokat.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  bool isEnded() {
    int tmp = 0;
    if (currentSmsList[currentSmsCounter].feedback == "Várjuk az eredményt.")
      tmp++;
    if (tmp == 0) return true;
    return false;
  }

  void _var() {

    Timer(Duration(seconds: int.parse(myController.text)), () {
      if (currentSmsCounter < currentSmsList.length) {
        _smsSend(currentSmsCounter);//?
        currentSmsCounter += 1;
        _var();
      }
    });

    setState(() {
      _status = "Elkezdtük a kiküldést!";
      _isButtonDisabled = true;
      if (currentSmsCounter == currentSmsList.length) {
        _isButtonDisabled = false;
        _status = "Végeztünk a kiküldéssel.";
      }
    });
  }

  Future<void> _smsSend(int i) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    currentSmsList[i].addTime(formattedDate);

    int currentDbIndex= dbFirstIndex + i;
    print(i);
    print(currentDbIndex);


    SmsSender sender = new SmsSender();
    String number = currentSmsList[i].number;
    print(currentDbIndex.toString()+" czrrrent");
    SmsMessage message = new SmsMessage(number, currentSmsList[i].message);
    message.onStateChanged.listen((state) async {
      if (state == SmsMessageState.Sent) {
        currentSmsList[i].addFeedback("SMS elküldve!");
         await _update(currentDbIndex, "SMS elküldve!");
      } else if (state == SmsMessageState.Delivered) {
        currentSmsList[i].addFeedback("SMS kézbesítve!");
        await _update(currentDbIndex, "SMS kézbesítve!");
      } else if (state == SmsMessageState.Sending) {
        currentSmsList[i].addFeedback("SMS küldés alatt!");
        await _update(currentDbIndex, "SMS küldés alatt!!");
      } else if (state == SmsMessageState.Fail) {
        currentSmsList[i].addFeedback("SMS küldése sikertelen!");
        await _update(currentDbIndex, "SMS küldése sikertelen!");
      } else if (state == SmsMessageState.None) {
        currentSmsList[i].addFeedback("SMS elveszett!");
        await _update(currentDbIndex, "SMS elveszett!");
      } else {
        currentSmsList[i].addFeedback("Várjuk az eredményt.");
        await _update(currentDbIndex, "Várjuk az eredményt.");
      }
    });

    sender.sendSms(message);
    /*for(int i=0;i<currentSmsList.length;i++){
      _update(currentSmsList[i].id, currentSmsList[i].feedback);
    }*/
  }


  Future<void> fillResultListFromDB() async {
    smsResults.clear();

    final allRows = await globals.dbHelper.queryAllRows();
    for (int i = 0; i < allRows.length; i++) {
      smsResults.add(allRows[i]['number'] +
          "-részére: " +
          allRows[i]['feedback'] +
          "\n\n" +
          allRows[i]['time'] +
          " \n\n");
    }
  }

  Future<void> _read() async {

    final file = new File(_path);
    Stream<List<int>> inputStream = file.openRead();

    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) async {
      var arr = new List(5);


      if(_isItARightNumber(line)){
      arr = line.split(";");
      Sms currentSms = new Sms(0, arr[0], arr[1]);
      currentSmsList.add(currentSms);
      _isInTheRightFormat=true;
      await _insert(currentSms);

      /*if(currentSmsCounter==0 && dbindex==0){
        dbindex= await _insert(currentSms);
        print("dbindex: "+ dbindex.toString());
      }else{
      }*/
      }else{
        print("nemjo");
        _isInTheRightFormat=false;
        Toast.show("A fájl formátuma nem megfelelő.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    }, onDone: () {
      print('File is now closed.');
    }, onError: (e) {
      Toast.show("Hiba a fájl beolvasása közben: "+e.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      print(e.toString());
    });
  }

  bool _isItARightNumber(String line){
    RegExp regExp = new RegExp(
      r"\+?[0-9]{11,12};.*\n?",
      caseSensitive: false,
      multiLine: true,
    );
    print(regExp.allMatches(line).toString());
    return regExp.hasMatch(line);
  }

  _showTheReadedNumbers() {
    smsListToShow.clear();
    //id=1;

    for (int i = 0; i < currentSmsList.length; i++) {
      smsListToShow.add((i + 1).toString() +
          ". telefonszám: " +
          currentSmsList[i].number +
          "\nüzenet: " +
          currentSmsList[i].message +
          "\n\n");
    }
  }

  _pickDocument() async {
    String result;
    currentSmsCounter = 0;
    currentSmsList.clear();

    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeTypes: _checkByMimeType
            ? _mimeTypeController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });

    final file = new File(_path);
    Stream<List<int>> inputStream = file.openRead();

    currentSmsList.clear();
    _read();

  }
}

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: ListView.builder(
        itemCount: smsResults.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => Text(smsResults[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => smsResults.add('text')),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
