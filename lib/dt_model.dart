
////数据标识
//     public var isDtModel: Bool = true
//
//
//     //下载m3u8链接
//     public var url: String = ""
//     //下载m3u8 文件名字
//     public var name: String = ""
//
//     /// 下载状态【0：默认，1-开始下载ts，2-下载ts完成，解析ts文件中， 3-解析ts文件成功,，4-暂停下载，5、开始转MP4，6、转MP4成功，-1、下载ts失败，-2、解析ts文件失败，-3、转MP4失败】
//     public var state: Int = 0
//
//
//     //    public var progress:Progress?
//     //（速度值，进度值， 速度文本， 进度文本）
//     public var speed: Int = 0
//     public var progress: Double = 0
//     public var speedText: String = ""
//     public var progressText: String = ""
//     //总大小
//     public var totalSize: Int = 0
//
//
//     /// 是否需要解密
//     public var isDecryption: Bool = false
//     /// 原来m3u8 文件绝对地址   【isDecryption == true】
//     public var m3u8FilePath: String = ""
//     /// 解密 new m3u8 文件绝对地址   【isDecryption == true】
//     public var m3u8FilePathNew: String = ""
//
//     /// [不解密]合并ts的绝对路径
//     public var tsPath: String = ""
//
//     /// 转码后需删除的路径
//     public var deletePath: String = ""

class DtModel {
  bool? isDtModel;
  String? url;
  String? name;

  //下载状态【0：默认，1-正在下载ts，2-下载ts完成，解析ts文件中， 3-解析ts文件成功,，4-暂停下载，5、开始转MP4，
  // 6、转MP4成功，-1、下载ts失败，-2、解析ts文件失败，-3、转MP4失败】
  int? state;
  int? speed;
  double? progress;
  String? speedText;
  String? progressText;
  int? totalSize;
  bool? isDecryption;
  String? m3u8FilePath;
  String? m3u8FilePathNew;
  String? tsPath;
  String? deletePath;

  DtModel({this.isDtModel,
    this.url,
    this.name,
    this.state,
    this.speed,
    this.progress,
    this.speedText,
    this.progressText,
    this.totalSize,
    this.isDecryption,
    this.m3u8FilePath,
    this.m3u8FilePathNew,
    this.tsPath,
    this.deletePath});

  DtModel.fromJson(Map<String, dynamic> json) {
    isDtModel = json['isDtModel'];
    url = json['url'];
    name = json['name'];
    state = json['state'];
    speed = json['speed'];
    progress = json['progress'];
    speedText = json['speedText'];
    progressText = json['progressText'];
    totalSize = json['totalSize'];
    isDecryption = json['isDecryption'];
    m3u8FilePath = json['m3u8FilePath'];
    m3u8FilePathNew = json['m3u8FilePathNew'];
    tsPath = json['tsPath'];
    deletePath = json['deletePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.isDtModel != null)
      data['isDtModel'] = this.isDtModel;
    if (this.url != null)
      data['url'] = this.url;
    if (this.name != null)
      data['name'] = this.name;
    if (this.state != null)
      data['state'] = this.state;
    if (this.speed != null)
      data['speed'] = this.speed;
    if (this.progress != null)
      data['progress'] = this.progress;
    if (this.speedText != null)
      data['speedText'] = this.speedText;
    if (this.progressText != null)
      data['progressText'] = this.progressText;
    if (this.totalSize != null)
      data['totalSize'] = this.totalSize;
    if (this.isDecryption != null)
      data['isDecryption'] = this.isDecryption;
    if (this.m3u8FilePath != null)
      data['m3u8FilePath'] = this.m3u8FilePath;
    if (this.m3u8FilePathNew != null)
      data['m3u8FilePathNew'] = this.m3u8FilePathNew;
    if (this.tsPath != null)
      data['tsPath'] = this.tsPath;
    if (this.deletePath != null)
      data['deletePath'] = this.deletePath;
    return data;
  }
}