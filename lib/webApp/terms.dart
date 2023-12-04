import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsSrc extends StatefulWidget {
  const TermsSrc({Key? key}) : super(key: key);

  @override
  State<TermsSrc> createState() => _TermsSrcState();
}

class _TermsSrcState extends State<TermsSrc> {
    Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;


  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    super.initState();
  }
  
 @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
    
  }


  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        string = 'Terms and Conditions';
        break;
      case ConnectivityResult.wifi:
        string = 'Terms and Conditions';
        break;
      case ConnectivityResult.none:
      default:
        string = 'You are: Offline Please check your internet connection';
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(string),
        centerTitle: true,
      ),
      body:  const WebView(
        zoomEnabled: false,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://rateraters.github.io/terms2.html',
      ),
    );
  }
}
class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.done;
}