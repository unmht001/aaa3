import 'package:aaa3/support.dart';
import 'package:flutter/material.dart';
import 'package:mytts8/mytts8.dart';
// import 'package:aaa3/global_value.dart';
import 'value_listener.dart';
import "package:aaa3/tts_helper.dart";
import 'package:aaa3/get_string.dart';
// import 'support.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_plugin_tts/flutter_plugin_tts.dart';
// import 'package:mytts8/mytts8.dart';

void main() {
  // TtsHelper();
  ListenerBox.instance.el('lsner1');
  ListenerBox.instance.el('lsner2');
  ListenerBox.instance.el('lsner3');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key) {
    this.tts.setLanguage("zh-CN");
  }
  final tts = Mytts8();
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    getS(ListenerBox.instance.getel('lsner1'));
  }

  // Widget getbody()

  @override
  Widget build(BuildContext context) {
    ListenerBox.instance.getel('lsner1').afterSetter = () {
      print("lsner1.after.setter");
      setState(() {});
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WordPage(
          document: Textsheet.getTextsheetChain(ListenerBox.instance.getel('lsner1').value), tts: this.widget.tts),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '跳转',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
