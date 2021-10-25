import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:m3u8_download_ios/dt_model.dart';
import 'package:m3u8_download_ios/m3u8_download_ios.dart';

import 'm3u8_helper_ios.dart';
import 'button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  final url1 = "https://testc.hzsy66.cn/short_video/20210916/m3u8/playlist"
      ".m3u8?auth_key=1634178600-a3f390d88e4c41f2747bfa2f1b5f87db-0"
      "-479f5e16941708ed594fac02683dfca8";
  final url2 = "https://testc.hzsy66.cn/upload/short_video/202108091446/m3u8/1.m3u8";
  final url3 = "https://v11.tkzyapi.com/20210914/hylcFIpO/1000kb/hls/index"
      ".m3u8?auth_key=1634707825-812b4ba287f5ee0bc9d43bbf5bbe87fb-0-c20242623ac0162944fe69dcac18e1e7";

  @override
  void initState() {
    super.initState();

    initPlatformState();

    perform();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // M3u8Downloader.initialize(
      //     saveDir: "saveDir",
      //     isConvert: true,
      //     debugMode: false,
      //     threadCount: 5);
      platformVersion = await M3u8DownloadIos.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion + "[刷新]";
    });
  }

  String speedText = "";
  String pText = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Running on: $_platformVersion\n'),
            Text('isM3u8HelperInit = $isM3u8HelperInit'),

            Text('speedText = $speedText'),
            Text('pText = $pText'),
            DButton(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: Theme.of(context).primaryColor,
              child: Text(
                "下载1",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
              ),
              onPressed: () {
                if (isM3u8HelperInit) {
                  M3u8HelperIos().downloadIos(url: url1,dtCallback: (DtModel md){
                    speedText = md.speedText!;
                    pText = md.progressText!;
                    setState(() {

                    });
                  });
                  return;
                } else {
                  print("等待初始化完成");
                }
              },
            ),
            DButton(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: Theme.of(context).primaryColor,
              child: Text(
                "下载2",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
              ),
              onPressed: () {
                if (isM3u8HelperInit) {
                  M3u8HelperIos().downloadIos(url: url2,dtCallback: (DtModel md){
                    speedText = md.speedText!;
                    pText = md.progressText!;
                    setState(() {

                    });
                  });
                  return;
                } else {
                  print("等待初始化完成");
                }
              },
            ),
            DButton(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: Theme.of(context).primaryColor,
              child: Text(
                "查询目录",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
              ),
              onPressed: () {
                M3u8HelperIos().listFolder();
              },
            ),
          ],
        )),
      ),
    );
  }

  bool isM3u8HelperInit = false;

  void perform() async {
    await M3u8HelperIos().init();
    isM3u8HelperInit = true;
    setState(() {});
  }
}
