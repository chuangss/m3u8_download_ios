class DtModel {
  // bool isDtModel;
  // String url;
  // String name;
  // int state;
  // int speed;
  // double progress;
  // String speedText;
  // String progressText;
  // int totalSize;
  // bool isDecryption;
  // String m3u8FilePath;
  // String m3u8FilePathNew;
  // String tsPath;
  // String deletePath;
  bool? isDtModel;
  String? url;
  String? name;

  //下载状态【0：默认， 1-下载中，2-下载完成，解析中, 3-解析成功, 4[保存完成]，-1下载失败 ，  -2解析失败，】
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