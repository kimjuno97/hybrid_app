import 'package:flutter/material.dart';
import 'package:hybrid_app/web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // main() 함수에서 await 키워드를 사용하여 비동기 작업을 수행해야 하는 경우 사용해야함.
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(const MaterialApp(home: WebViewScreen()));
}
