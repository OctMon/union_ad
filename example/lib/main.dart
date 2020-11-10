import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:union_ad/union_ad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Unknown';

  @override
  void initState() {
    super.initState();
    initRegister();
  }

  Future<void> initRegister() async {
    await UnionAd.register(iosAppId: '5000546', androidAppId: '5118122');
    setState(() {
      _status = "Success";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text(_status),
            RaisedButton(
              onPressed: () {
                UnionAd.loadRewardVideo();
              },
              child: Text('加载激励视频广告'),
            ),
            RaisedButton(
              onPressed: () {
                UnionAd.showRewardVideo();
              },
              child: Text('展示激励视频广告'),
            ),
          ],
        ),
      ),
    );
  }
}
