import 'dart:async';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:m3u8_download_ios/dt_model.dart';
import 'package:m3u8_download_ios/m3u8_download_ios.dart';

class M3u8HelperIos {
  static final M3u8HelperIos _instance = M3u8HelperIos._internal();

  factory M3u8HelperIos() {
    return _instance;
  }

  M3u8HelperIos._internal() {
    // init();
  }

  // ignore: close_sinks
  StreamController<DtModel>? controller;
  FlutterFFmpeg? _flutterFFmpeg;
  String documentsPath = "";
  bool isInit = false;

  Future<bool> init() async {
    _flutterFFmpeg = FlutterFFmpeg();
    controller = StreamController(onListen: () {
      print("onListen");
    }, onCancel: () {
      print("onCancel");
    });
    controller?.stream.listen(onData);

    await M3u8DownloadIos.initializeIos(debugModel: false, ctr: controller);
    documentsPath = await M3u8DownloadIos.documentsPath();
    isInit = true;
    return true;
  }

  void downloadIos({required String url}) {
    M3u8DownloadIos.downloadIos(url: url);
  }

  void onData(DtModel model) {
    print("onData---model数据");
    print(model.toJson());
    final state = model.state!;
    if (state == 3) {
      perform(model);
    }
  }

  void perform(DtModel model) {
    if (model.state! != 3) {
      return;
    }
    final name = "${model.name!}-${DateTime.now().microsecondsSinceEpoch}.mp4";
    final mp4File = documentsPath + "/mp4";
    M3u8DownloadIos.createFinder(path: mp4File);
    final filePath1 = mp4File + "/$name";
    String command = "";
    if (model.isDecryption! == false) {
      //无需解密
      String tsPath = model.tsPath!;
      command = "-i $tsPath $filePath1";
    } else {
      final m3u8FilePathNew = model.m3u8FilePathNew!;
      command = "-allowed_extensions ALL -i $m3u8FilePathNew -c copy $filePath1";
    }
    print("开始转码");
    _flutterFFmpeg!.execute(command).then((rc) {
      print("FFmpeg 转码状态 $rc");
      if (rc == 0) {
        //转码完成
        M3u8DownloadIos.removeFolder(folderUrl: model.deletePath!);
        M3u8DownloadIos.listFolder(folderUrl: documentsPath);
      }
    });
  }
}
