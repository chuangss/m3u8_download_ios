
import 'dart:async';

import 'package:flutter/services.dart';
import 'dt_model.dart';

class M3u8DownloadIos {
  static const MethodChannel _channel = const MethodChannel('m3u8_download_ios');
  static const EventChannel eventChannel = const EventChannel('m3u8_download_ios_event');
  static StreamController<DtModel>? _streamController;

  ///开启数据接受监听
  static void openEventListen() {
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  /// 数据接收（IOS）
  static void _onEvent(dynamic value) {
    final result = Map<String, dynamic>.from(value);
    ///下载数据标识
    if (result.containsKey("isDtModel")) {
      DtModel model = DtModel.fromJson(result);
      _streamController?.add(model);
    } else {
      print("_________(event ios数据)result:$result");
    }
  }


  /// 数据接收: 错误处理(ios)
  static void _onError(dynamic value) {
    print("flutter_jl_bluetooth_plugin_event _onError: $value");
  }

  //-------------------------性感的分割线-----------------------------------

  ///获取版本号
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///获取 ios documents文件夹绝对路径
  static Future<String> documentsPath() async {
    final String path = await _channel.invokeMethod('documentsPath', {});
    // print("path:" + path);
    return path;
  }




  /// 初始化
  /// * -[debugModel] 是否开启调试模式
  static Future<bool> initializeIos({bool debugModel = false, StreamController<DtModel>? ctr})
  async {
    if(ctr != null)
      _streamController = ctr;
    openEventListen();

    ///[debugModel] 调试模式
    ///[url] 调试模式
    final value = await _channel.invokeMethod<bool>('initializeIos', {
      "debugModel": debugModel,
    });
    print(value);
    return false;
  }


  /// 下载m3u8  ts文件
  /// * -[url] 下载Url
  static Future<Map<String, dynamic>> downloadIos({required String url}) async {
    final data = await _channel.invokeMethod<bool>('downloadIos', {"url": url});
    print(data);
    Map<String, dynamic> result = Map<String, dynamic>();
    // try {
    //   final data = await _channel.invokeMethod<bool>('downloadIos',{"url": url});
    //   print("_________(原始数据)_________data:$data");
    //   result = Map<String, dynamic>.from(data);
    //   print("_________(转换数据)_________result:$result");
    // } on PlatformException catch (e) {
    //   print(e.toString());
    // }
    return result;
  }


  /// 删除文件
  /// * -[folderUrl] 删除文件夹
  static void removeFolder({required String folderUrl, bool rmFolder = true}) async {
    final value = await _channel.invokeMethod('removeFolder', {
      "folderUrl": folderUrl, "rmFolder": rmFolder
    });
  }

  /// 创建
  /// * -[path] 文件夹
  static void createFinder({required String path}) async {
    final value = await _channel.invokeMethod('createFinder', {
      "path": path
    });
  }

  /// 查询
  /// * -[folderUrl] 文件夹
  static void listFolder({required String folderUrl}) async {
    final value = await _channel.invokeMethod('listFolder', {
      "folderUrl": folderUrl
    });
  }
}


