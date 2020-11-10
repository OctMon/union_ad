import 'package:flutter/material.dart';
import 'dart:async';

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

  String testAppIdAndroid = '5001121';
  String testRewardCodeIdAndroid = '901121365';

  @override
  void initState() {
    initRegister();
    super.initState();
  }

  Future<void> initRegister() async {

    await UnionAd.register(iosAppId: '5000546', androidAppId: testAppIdAndroid,debug: true);
    setState(() {
      _status = "Success";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('头条穿山甲广告插件'),
        ),
        body: Column(
          children: [
            Text(_status),
            RaisedButton(
              onPressed: () {
                UnionAd.loadRewardVideo(codeIdAndroid:testRewardCodeIdAndroid,);
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
