import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hybrid_app/url_list_screen.dart';

void main() async {
  // main() 함수에서 await 키워드를 사용하여 비동기 작업을 수행해야 하는 경우 사용해야함.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      builder: FToastBuilder(),
      home: const UrlListScreen(),
    ),
  );
}
