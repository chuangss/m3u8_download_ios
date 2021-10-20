//
//  M3u8Helper.swift
//  WLM3U_Example
//
//  Created by one on 2021/10/15.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import WLM3U

func printDebug(_ str:Any){
    if M3u8Helper.debugMode {
        print(str)
    }
}


//解析回调
public typealias ParsingCall = (DTModel) -> ()



/// - [saveDir] 文件保存位置
/// - [showNotification] 是否显示通知
/// - [isConvert] 是否转成mp4  此版本默认false
/// - [connTimeout] 网络连接超时时间
/// - [readTimeout] 文件读取超时时间
/// - [threadCount] 同时下载的线程数
/// - [debugMode] 调试模式
/// - [onSelect] 点击通知的回调
///
///
///1、解析
///2、下载
///     下载完成返回：（是否需要解密,）
///3、合并  或者   解密合并
///
///不转码版本
class M3u8Helper {
    
    //保存根目录
    static let dPath = NSHomeDirectory() + "/Documents"
    //保存根目录
    static let m3Path = NSHomeDirectory() + "/Documents/WLM3U"
    
    static var debugMode:Bool = true
    
    //    static func printDebug(_ str:Any){
    //        if debugMode {
    //            print(str)
    //        }
    //    }
    
    //
    static var md = DTModel()
    
    static func updateState(_ st:Int){
        md.state = st
        sendMsg()
    }
    
    static func sendMsg(){
        printDebug("发送状态数据/n")
        //        printDebug(md.toDic())
        SwiftM3u8DownloadIosEvent.instace().events!(md.toDic())
    }
    ///任务列表
    //    static var taskDic:Dictionary<String, Workflow> = {}
    
    static var workflow:Workflow?
    
    //解析m3u8文件
    static func attach(urlStr:String, completion: AttachCompletion? = nil)->Workflow? {
        updateState(1)
        md.url = urlStr
        let url = URL(string: urlStr)!
        do {
            workflow = try WLM3U.attach(url: url,
                                        tsURL: { (path, url) -> URL? in
                if path.hasSuffix(".ts") {
                    printDebug("确定切片文件的URL-path:\(path)\n url :\(url)")
                    return url.appendingPathComponent(path)
                } else {
                    return nil
                }
            },
                                        completion:{ (result) in
                completion?(result)
                switch result {
                case .success(let model):
                    md.name = model.name!
                    printDebug("[Attach Success] " + model.name! + ",totalSize:\(model.totalSize!)")
                case .failure(let error):
                    printDebug("[Attach Failure] " + error.localizedDescription)
                }
            })
            download(workflow: workflow!)
            return workflow
            
        } catch  {
            updateState(-1)
        }
        return nil
    }
    
    
    
    
    static func download(workflow: Workflow, progressCall: DownloadProgress? = nil, completion: DownloadCompletion? = nil, parsingCall: ParsingCall? = nil) {
        ///开始下载分片
        workflow.download(progress: { (progress, completedCount) in
            var text = ""
            let mb = Double(completedCount) / 1024 / 1024
            if mb >= 0.1 {
                text = String(format: "%.1f", mb) + " M/s"
            } else {
                text = String(completedCount / 1024) + " K/s"
            }
            
            let pStr = String(format: "%.2f", progress.fractionCompleted * 100) + " %"
            printDebug("download speed: \(text)" + ", download progress:" + pStr)
            
            md.speed = completedCount
            md.speedText = text
            md.progress = progress.fractionCompleted
            md.progressText = pStr
            updateState(1)
        }, completion: { (result) in
            completion?(result)
            switch result {
            case .success(let url):
                printDebug("[Download Success] " + url.path)
                self.getAllFilePath(dPath)
                self.perform(workflow: workflow)
            case .failure(let error):
                updateState(-1)
                printDebug("[Download Failure] " + error.localizedDescription)
            }
        })
    }
    
    
    //暂停、取消
    static func pause(urlStr:String) {
        WLM3U.cancel(url: URL(string: urlStr)!)
    }
    
    //
    static func resume(urlStr:String, completion: AttachCompletion? = nil) {
        if let wf = workflow {
            download(workflow: wf)
        }else{
            printDebug("重试失败")
        }
    }
    
    
    //解析 加密与未加密分别处理
    // 下载并写入key 修改m3u8文件 ff转码MP4
    static func perform(workflow: Workflow, parsingCall: ParsingCall? = nil){
        updateState(2)
        let urlString:String = workflow.url.absoluteString
        let m3u8FileName = workflow.model.name!
        md.name = m3u8FileName
        
        //查询当前下载ts文件夹
        self.getAllFilePath(m3Path + "/\(m3u8FileName)")
        //查询文件
        //原m3u8
        let m3u8FilePath = m3Path + "/\(m3u8FileName)/file.m3u8"
        //解密修改m3u8写入路径
        let m3u8FilePathNew = NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/fileNew.m3u8"
        md.m3u8FilePath = m3u8FilePath
        md.m3u8FilePathNew = m3u8FilePathNew
        
        //读取真实m3u8文件
        //e: URI="/short_video/20210916/enc.key",IV=0x00000000000000000000000000000000
        let fileContent = readLoactionFile(m3u8FilePath)
        
        //提取key url
        let post1 = fileContent.positionOf(sub: "URI=")
        let post2 = fileContent.positionOf(sub: "key")
        if post2 >= 0 {
            //加密
            md.isDecryption = true
            ///截取目标字符串
            let keyUrl = fileContent[(post1 + 5)...(post2 + 2)]
            printDebug("提取keyUrl = \(keyUrl)")
            
            //获取域名 并 链接keyUrl
            let domainUrl = URL(string: urlString)!.host!
            printDebug("提取domainUrl = \(domainUrl)")
            
            
            //读取网络文件【解密key】 e: https://testc.hzsy66.cn/short_video/20210916/enc.key"
            let keyStr = readNetUrlKey("https://" + domainUrl + keyUrl)
            
            //写入文件key ts/
            FileOperation.writeStrToFile(writeFilePath: NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/ts/key.key", writeContent: keyStr)
            ///输出日志
            //            _ = readLoactionFile(NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/ts/key.key")
            printDebug("写入解密 key文件完成")
            self.getAllFilePath(m3Path)
            
            
            //修改 m3u8文件 写入文件 m3u8FilePath
            let newFileContent = fileContent.replacingOccurrences(of: keyUrl, with: "ts/key.key")
            FileOperation.writeStrToFile(writeFilePath: m3u8FilePathNew, writeContent: newFileContent)
            //            _ = readLoactionFile(m3u8FilePathNew)
            printDebug("修改m3u8文件完成")
            self.getAllFilePath(m3Path)
            md.deletePath = m3Path + "/\(md.name)"
            
            updateState(3)
        }else{
            //未加密
            md.isDecryption = false
            workflow.combine(completion: { [self] (result) in
                switch result {
                case .success(let url):
                    printDebug("[Combine Success] " + url.path)
                    md.tsPath = url.path
                    md.deletePath = m3Path + "/\(md.name)"
                    getAllFilePath(dPath)
                    updateState(3)
                case .failure(let error):
                    updateState(-2)
                    printDebug("[Combine Failure] " + error.localizedDescription)
                }
            })
        }
    }
    
    //读取本地文件
    static func readLoactionFile(_ path:String) -> String{
        //        path = "/Documents/WLM3U/playlist/file.m3u8"
        //        let m3u8FilePath = (NSHomeDirectory() + path)
        do {
            let fileContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            printDebug("m3u8文件信息：\n\(fileContent)")
            return fileContent
        } catch {
            printDebug("读取文件信息失败 path = \(path)")
            return ""
        }
    }
    
    
    ///从网络URL读取文本文件
    static func readNetUrlKey(_ urlStr:String) -> String{
        //        let urlStr = "https://testc.hzsy66.cn/short_video/20210916/enc.key"
        if let url = URL(string: urlStr) {
            do {
                let contents = try String(contentsOf: url)
                printDebug(contents)
                return contents
            } catch {
                printDebug("读取网络文本信息失败 urlStr = \(urlStr)")
                return ""
            }
        } else {
            printDebug("the URL was bad! urlStr = \(urlStr)")
            return ""
        }
    }
    
    //查询dirPath目录
    static func getAllFilePath(_ dirPath: String, _ isShow:Bool = false) {
        if isShow {
            print("查询文件夹:\(dirPath)：\n")
        }else{
            printDebug("查询文件夹:\(dirPath)：\n")
        }
        //获得此文档下所有内容，以及子文件夹下的内容，并储存在一个数组对象中
        let contents = FileManager.default.enumerator(atPath: dirPath)
        if let allObjects = contents?.allObjects {
            if isShow {
                print("\(allObjects)\n")
            }else{
                printDebug("\(allObjects)\n")
            }
        }
    }
}
