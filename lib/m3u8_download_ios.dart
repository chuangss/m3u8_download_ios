import 'dart:async';

import 'package:flutter/services.dart';
import 'dt_model.dart';

//
class M3u8DownloadIos {
  static const MethodChannel _channel = const MethodChannel('m3u8_download_ios');
  static const EventChannel eventChannel = const EventChannel('m3u8_download_ios_event');
  static StreamController<DtModel>? _streamController;

  ///开启数据接受监听
  static void openEventListen() {
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  /// 数据流接收（IOS）
  static void _onEvent(dynamic value) {
    final result = Map<String, dynamic>.from(value);

    ///下载数据标识
    if (result.containsKey("isDtModel")) {
      DtModel model = DtModel.fromJson(result);
      _streamController?.add(model);
    } else {
      print("M3u8DownloadIos 其他result:$result");
    }
  }

  /// 数据接收: 错误处理(ios)
  static void _onError(dynamic value) {
    print("M3u8DownloadIos_event _onError: $value");
  }

  //-------------------------性感的分割线-----------------------------------

  ///获取版本号
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
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
  static Future<bool> initializeIos(
      {bool debugModel = false, StreamController<DtModel>? ctr}) async {
    if (ctr != null) _streamController = ctr;
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
  static Future<void> downloadIos({required String url}) async {
    await _channel.invokeMethod('downloadIos', {"url": url});
  }

  /// 暂停或者取消
  /// * -[url] 下载Url
  static Future<void> pause({required String url}) async {
    await _channel.invokeMethod<bool>('pause', {"url": url});
  }

  /// 取消下载
  /// - [url] 下载链接地址
  /// - [isDelete] 取消时是否删除文件
  static Future<void> cancel(String url, {bool isDelete = false}) async {
    assert(url.isNotEmpty);
    await _channel.invokeMethod("cancel", {"url": url, "isDelete": isDelete});
  }

  //--------------------------------------------------------------------------------

  /// 删除文件
  /// * -[sourceUrl] 文件url
  static Future<void> removeFile({required String sourceUrl}) async {
    await _channel.invokeMethod('removeFile', {"sourceUrl": sourceUrl});
  }

  /// 删除文件夹
  /// * -[folderUrl] 文件夹url
  static Future<void> removeFolder({required String folderUrl, bool rmFolder = true}) async {
    await _channel.invokeMethod('removeFolder', {"folderUrl": folderUrl, "rmFolder": rmFolder});
  }

  /// 创建文件夹
  /// * -[path] 文件夹
  static Future<void> createFinder({required String path}) async {
    await _channel.invokeMethod('createFinder', {"path": path});
  }

  /// 打印此文件夹下所有item
  /// * -[folderUrl] 文件夹url
  static Future<void> listFolder({required String folderUrl}) async {
    await _channel.invokeMethod('listFolder', {"folderUrl": folderUrl});
  }
}
