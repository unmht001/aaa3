import 'package:beautifulsoup/beautifulsoup.dart';
import "package:dio/dio.dart";
import 'package:aaa3/value_listener.dart';


getS(MyListener lsn) async {
  try {
    var url = "https://www.23us.so/files/article/html/1/1569/19553493.html";
    Dio dio=new Dio();
    lsn.value = "等待";
    // var response = await http.get(url);  
    var response=await dio.get(url);
    if (response.statusCode == 200) {   
      // var s=Utf8Decoder().convert( response.data); 
      var s=response.data; 
      var soup = Beautifulsoup(s.toString());
      // if (soup==null){
      //   // print("soup is null");
      // }else{
      //   // print("soup is not null , is :");
      // }
      var _ss = soup.find(id: "#contents");
      // if (_ss != null) {
      //   var _sp=_ss.text.split("\n");
      //   _sp.removeWhere((ss)=> ss=="");
      //   lsn.value=_sp;
      //   print(lsn.value);
      // } else {
      //   lsn.value = ["没有找到"];
      // }
      if (_ss != null) {
        var _sp=_ss.text;
        lsn.value=_sp;
      } else {
        lsn.value = "没有找到";
      }
    } else {
      lsn.value ="Request failed with status: ${response.statusCode}.";
    }
  } catch (e) {
    lsn.value =e.toString();
  }
}
