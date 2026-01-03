import 'package:flutter/material.dart';
import 'package:resume_builder_project/core/screens/home_screen.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Android
  WebViewPlatform.instance = AndroidWebViewPlatform();

  // iOS (nếu sau này build iOS)
  // WebViewPlatform.instance = WebKitWebViewPlatform();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
