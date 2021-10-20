//
//  DTModel.swift
//  m3u8_download_ios
//
//  Created by one on 2021/10/19.
//

import Foundation

/// 解密数据模型
open class DTModel {
    //数据标识
    public var isDtModel: Bool = true
    
    
    //下载m3u8链接
    public var url: String = ""
    //下载m3u8 文件名字
    public var name: String = ""
    
    /// 下载状态【0：默认，1-正在下载ts，2-下载ts完成，解析ts文件中， 3-解析ts文件成功,，4-暂停下载，5、开始转MP4，6、转MP4成功，-1、下载ts失败，-2、解析ts文件失败，-3、转MP4失败】
    public var state: Int = 0
    
    
    //    public var progress:Progress?
    //（速度值，进度值， 速度文本， 进度文本）
    public var speed: Int = 0
    public var progress: Double = 0
    public var speedText: String = ""
    public var progressText: String = ""
    //总大小
    public var totalSize: Int = 0
    
    
    /// 是否需要解密
    public var isDecryption: Bool = false
    /// 原来m3u8 文件绝对地址   【isDecryption == true】
    public var m3u8FilePath: String = ""
    /// 解密 new m3u8 文件绝对地址   【isDecryption == true】
    public var m3u8FilePathNew: String = ""
    
    /// [不解密]合并ts的绝对路径
    public var tsPath: String = ""
    
    /// 转码后需删除的路径
    public var deletePath: String = ""
    
    public func toDic() -> Dictionary<String, Any>{
        let dic : Dictionary<String, Any> = [
            "isDtModel":isDtModel,
            "url":url,
            "name":name,
            "state":state,
            "speed":speed,
            "progress":progress,
            "speedText":speedText,
            "progressText":progressText,
            "totalSize":totalSize,
            "isDecryption":isDecryption,
            "m3u8FilePath":m3u8FilePath,
            "m3u8FilePathNew":m3u8FilePathNew,
            "tsPath":tsPath,
            "deletePath":deletePath
        ]
        return dic
    }
    
    
}
