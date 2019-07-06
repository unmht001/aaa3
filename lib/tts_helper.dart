// import 'package:tts/tts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'lanuageMap.dart';
import 'support.dart';
// import 'dart:math';

class Tts {
  static const MethodChannel _channel = const MethodChannel('github.com/blounty-ak/tts');

  static Future<bool> isLanguageAvailable(String language) async {
    final bool languageAvailable =
        await _channel.invokeMethod('isLanguageAvailable', <String, Object>{'language': language});
    return languageAvailable;
  }

  static Future<bool> setLanguage(String language) async {
    final bool isSet = await _channel.invokeMethod('setLanguage', <String, Object>{'language': language});
    return isSet;
  }

  static Future<List<String>> getAvailableLanguages() =>
      _channel.invokeMethod('getAvailableLanguages').then((result) => result.cast<String>());

  static Future<void> speak(String text) async {
    await _channel.invokeMethod('speak', <String, Object>{'text': text});
  }
}

class TtsHelper {
  // Locale to tss language map
  static final Map<String, String> _languageMap = languageMap;
  static final String _defaultL = "zh-CN";
  List<String> _languages;
  static TtsHelper _instance;
  static TtsHelper get instance => _getInstance();

  factory TtsHelper() => _getInstance();
  static TtsHelper _getInstance() {
    if (_instance == null) {
      _instance = new TtsHelper._internal();
    }
    return _instance;
  }

  TtsHelper._internal() {
    // Initialize
    _initPlatformState();
  }

  _initPlatformState() async {
    _languages = await Tts.getAvailableLanguages();

    // If getAvailableLanguages is null, add "en-US" to _languages.
    if (_languages == null) {
      _languages = [_defaultL];
    }
    // Default set en-US language
    _setLanguage(_defaultL);
  }

  String _getTtsLanguage(String localeStr) {
    if (localeStr == null || localeStr.isEmpty || !_languageMap.containsKey(localeStr)) {
      return _defaultL;
    }
    return _languageMap[localeStr];
  }

  // Return whether the result if set language is successful
  Future<bool> _setLanguage(String lang) async {
    String language = _getTtsLanguage(lang);
    if (language == null || language.isEmpty) {
      language = _defaultL;
    }
    if (Platform.isIOS && !_languages.contains(language)) {
      return false;
    }
    final bool isSet = await Tts.setLanguage(language);
    return isSet;
  }

  // Returns whether the supported language is supported
  Future<bool> _isLanguageAvailable(String language) async {
    final bool isSupport = await Tts.isLanguageAvailable(language);
    return isSupport;
  }

  Future<void> speak(String text) async {
    if (text == null || text.isEmpty) {
      return;
    }
    await Tts.speak(text);
  }

  Future<void> setLanguageAndSpeak(String text, String language) async {
    String ttsL = _getTtsLanguage(language);
    var setResult = await _setLanguage(ttsL);
    if (setResult != null) {
      var available = await _isLanguageAvailable(ttsL);
      if (available != null) {
        await speak(text);
      }
    }
  }
}





class WordPage extends StatefulWidget {
  WordPage({Key key, this.document,Function fn}) : super(key: key){fd[0]=fn;}
  final Textsheet document;
  final List<Textsheet> hl=[null];
  final List<Function> fd=[null];
  @override
  _WordPageState createState() => _WordPageState();
  next(){
    Textsheet _now;
    if(hl[0]==null){
      _now=document;
      document.changeHighlight();
    }else{
      _now=hl[0];
    }
    if (_now.son==null){
      _now.data["highlight"]=false;
      hl[0]=null;
    }else{
      hl[0]=_now.son;
      _now.data['highlight']=true;
    }
  }
}

class _WordPageState extends State<WordPage> {
  Widget ff(Textsheet sss) {
    return Container(
        color: sss.cl,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child:
                Text(sss.text, softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () {
              setState(() {
                if (this.widget.hl[0]!=null){
                  this.widget.hl[0].changeHighlight();
                }
                sss.changeHighlight();
                this.widget.hl[0]=sss;
                if(this.widget.fd[0]!=null){
                  var a=this.widget.fd[0];                  
                 a(this.widget.hl[0],setState((){}));
                }
              });
              //  TtsHelper.instance.setLanguageAndSpeak(sss.toString(), "zh");
            }));
  }
   ff2(Textsheet sss){
     List<Widget> a=[];
     var b=sss;
     while (b!=null){
       a.add(ff(b));
       b=b.son;
     }
     return a;
   }
  @override
  Widget build(BuildContext context) {
    return ListView(children: ff2(this.widget.document));
  }
}
