import 'package:flutter/material.dart';
// import 'package:aaa3/global_value.dart';
import 'value_listener.dart';
import "package:aaa3/tts_helper.dart";
import 'package:aaa3/get_string.dart';
import 'support.dart';


void main(){
  TtsHelper();
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
  MyHomePage({Key key, this.title}) : super(key: key);
  
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
    ListenerBox.instance.getel('lsner1').afterSetter=(){setState(() { });};
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:WordPage(document: Textsheet.getTextsheetChain( ListenerBox.instance.getel('lsner1').value),fn:(Textsheet ts,fn)=>{TtsHelper.instance.setLanguageAndSpeak(ts.text.toString(), "zh")}),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '跳转',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


