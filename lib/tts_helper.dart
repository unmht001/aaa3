// import 'package:tts/tts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'lanuageMap.dart';
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

class WordPageData {
  Map data = {};
  static num max = -1;
  static final List<WordPageData> _instance = [];

  WordPageData(
      {String document: "",
      int documentlength: 0,
      num position: -1,
      Color color1: Colors.greenAccent,
      Color color2: Colors.yellowAccent}) {
    this.data["document"] = document;
    this.data["documentlength"] = documentlength;
    this.data["position"] = position;
    this.data["color1"] = color1;
    this.data["color2"] = color2;
    this.data["No."] = WordPageData.max + 1;
    WordPageData.max += 1;
    WordPageData._instance.add(this);
  }
  WordPageData.fromMap(mp)
      : this(
          document: mp["document"] ?? "",
          documentlength: mp["documentlength"] ?? 0,
          position: mp["position"] ?? -1,
          color1: mp["color1"] ?? Colors.greenAccent,
          color2: mp["color2"] ?? Colors.yellowAccent,
        );
}

class WordPage extends StatefulWidget {
  WordPage({Key key, this.document}) : super(key: key);
  final List<String> document;
  final List cl = [Colors.greenAccent, -1, 0];
  @override
  _WordPageState createState() => _WordPageState();
  next() {
    cl[1] += 1;
    if (cl[1] >= cl[2]) {
      if (cl[2] == 0) {
        cl[1] = -1;
      } else {
        cl[1] = 0;
      }
    }
  }
}

class _WordPageState extends State<WordPage> {
  Widget ff(List sss) {
    return Container(
        color: sss[0] == this.widget.cl[1] ? Colors.greenAccent : Colors.yellowAccent,
        padding: EdgeInsets.all(5),
        child: GestureDetector(
            child:
                Text(sss[1].toString(), softWrap: true, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
            onTap: () {
              setState(() {
                this.widget.cl[1] = sss[0];
              });
              //  TtsHelper.instance.setLanguageAndSpeak(sss.toString(), "zh").then((r){print(333);});
            }));
  }

  @override
  Widget build(BuildContext context) {
    this.widget.cl[2] = this.widget.document.length;
    var _ctr = -1;
    var mp = widget.document.map((sss) {
      _ctr += 1;
      return [_ctr, sss];
    });
    return ListView(children: mp.map((sss) => ff(sss)).toList());
  }
}
