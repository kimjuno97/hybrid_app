import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hybrid_app/utils/is_url.dart';
import 'package:hybrid_app/web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlListScreen extends StatefulWidget {
  const UrlListScreen({super.key});

  @override
  State<UrlListScreen> createState() => _UrlListScreenState();
}

class _UrlListScreenState extends State<UrlListScreen> {
  final String _localKey = 'webViewLink';
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _itemList = [];
  final TextStyle _textStyle = const TextStyle(color: Colors.white);

  @override
  void initState() {
    _getUrlList();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
    super.initState();
  }

  /// Checks if the App was initially launched via the Widget
  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      /// home_widget을 클릭 한 후에 하고 싶은 동작을 아래에 자유롭게 수정
      _navigateToWebView(_itemList.first);
    }
  }

  Future<void> _getUrlList() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      final localUrlList = preferences.getStringList(_localKey);
      if (localUrlList != null) {
        _itemList = localUrlList;
      }
    });
  }

  void _addUrlList() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => _fullTextFieldScreen(),
      ),
    );
  }

  Future<bool> _checkValidUrl(String value) async {
    if (isURL(value)) {
      return true;
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            '경고',
            textAlign: TextAlign.center,
          ),
          content: const Text('http, https로 시작하는 url이 아닙니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return false;
    }
  }

  Future<void> _textFiledSubmitted(String value) async {
    final preferences = await SharedPreferences.getInstance();
    _itemList.add(value);
    preferences.setStringList(_localKey, _itemList);
    setState(() {});
  }

  void _navigateToWebView(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WebViewScreen(
            url: url,
          );
        },
      ),
    );
  }

  /// url 삭제
  Future<void> _deleteSelectedUrl(String url) async {
    final preferences = await SharedPreferences.getInstance();
    _itemList.remove(url);
    preferences.setStringList(_localKey, _itemList);
    setState(() {});
  }

  /// url 삭제 확인 dialog
  Future<void> deleteDialog(String url) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '삭제 하기',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () async {
              await _deleteSelectedUrl(url);
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          TextButton(
            child: const Text('취소'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('링크 설정'),
      ),
      body: ListView.builder(
        itemCount: _itemList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_itemList[index]),
            onTap: () {
              _navigateToWebView(_itemList[index]);
            },
            onLongPress: () async {
              await deleteDialog(_itemList[index]);
            },
          );
        },
      ),
      floatingActionButton: IconButton(
        iconSize: 52,
        icon: const Icon(
          Icons.add_circle_outline_rounded,
        ),
        onPressed: _addUrlList,
      ),
    );
  }

  Widget _fullTextFieldScreen() {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.45,
      ),
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onSubmitted: (value) async {
              if (await _checkValidUrl(value)) {
                await _textFiledSubmitted(value);
                if (mounted) {
                  _textEditingController.text = '';
                  Navigator.of(context).pop();
                }
              }
            },
            controller: _textEditingController,
            style: _textStyle,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'https://example.com',
              hintStyle: _textStyle,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
