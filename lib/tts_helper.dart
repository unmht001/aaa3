import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'dart:async';
// import 'tts';
import 'package:mytts8/mytts8.dart';

import 'support.dart';

class Pagestate {
  Textsheet currentHL;
  bool isReading = false;
  Function readingCompleteHandler;
  Function handler;
}

class WordPage extends StatefulWidget {
  WordPage({Key key, this.document, this.tts, Function fn}) : super(key: key) {

    this.pst.readingCompleteHandler = fn;
    this.pst.currentHL = this.document;
    if (this.document != null) this.document.changeHighlight();
  }
  final Mytts8 tts;
  final Pagestate pst = new Pagestate();
  final Textsheet document;
  @override
  _WordPageState createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  Widget textsheetToWidget(Textsheet sss) {
    return Container(
        color: sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child: Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () {
              setState(() {
                this.widget.pst.currentHL.changeHighlight();
                this.widget.pst.currentHL = sss;
                this.widget.pst.currentHL.changeHighlight();
              });
            }));
  }
  readhandler(){
    print("handler");
  }

  readOrStop() {
    if (this.widget.pst.isReading){
      this.widget.tts.stop();      
    }else{

      this.widget.tts.setCompletionHandler(readhandler);
      this.widget.tts.speak("这是一个中文朗读测试");
    }
    this.widget.pst.isReading = !this.widget.pst.isReading;  
  
    // this.widget.tts.speak(this.widget.pst.currentHL.text);
    setState(() {});
  }

  setRead() {
    print('fasdfasdfa');
  }

  chainToWidgetList(Chain sss) {
    List<Widget> a = [];
    var b = sss;
    while (b != null) {
      a.add(textsheetToWidget(b));
      b = b.son;
    }
    return a;
  }

  @override
  Widget build(BuildContext context) {
    // var wl=chainToWidgetList(this.widget.document);

    return Column(children: <Widget>[
      Container(
          height: 50,
          child: Row(children: <Widget>[
            IconButton(
                icon: Icon(this.widget.pst.isReading ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: !this.widget.pst.isReading ? Colors.green : Colors.orange),
                // icon: Icon(Icons.play_circle_filled, color: this.widget.pst.isReading ? Colors.green : Colors.grey),
                onPressed: readOrStop),
            IconButton(icon: Icon(Icons.settings), onPressed: setRead)
          ])),
      // ListView(children: <Widget>[textsheetToWidget(this.widget.document)],)
    ]);
  }
}
