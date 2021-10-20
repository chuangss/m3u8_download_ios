////
////  M3u8Helper.swift
////  WLM3U_Example
////
////  Created by one on 2021/10/15.
////  Copyright © 2021 CocoaPods. All rights reserved.
////
//
//import Foundation
//
//import WLM3U
////import mobileffmpeg
//
///// - [saveDir] 文件保存位置
///// - [showNotification] 是否显示通知
///// - [isConvert] 是否转成mp4
///// - [connTimeout] 网络连接超时时间
///// - [readTimeout] 文件读取超时时间
///// - [threadCount] 同时下载的线程数
///// - [debugMode] 调试模式
///// - [onSelect] 点击通知的回调
/////
/////
/////转码 库失败版本
//class M3u8Helper2 {
//    
//    //保存根目录
//    static let dPath = NSHomeDirectory() + "/Documents"
//    //MP4下载目录
//    static private var _mp4Path = NSHomeDirectory() + "/Documents/M3u8Mp4"//默认
//    static var mp4Path:String{
//        get{
//            return _mp4Path
//        }set{
//            _mp4Path = newValue;
//        }
//        
//    }
//    //当前mp4下载绝对路径
//    static var filePath1 :String!
//    
//    
//    ///任务列表
////    static var taskDic:Dictionary<String, Workflow> = {}
//    
//    //解析m3u8文件
//    static func attach(urlStr:String, completion: AttachCompletion? = nil)->Workflow? {
//        let url = URL(string: urlStr)!
//        do {
//            let workflow = try WLM3U.attach(url: url,
//                                            tsURL: { (path, url) -> URL? in
//                if path.hasSuffix(".ts") {
//                    print("确定切片文件的URL-path:\(path)\n url :\(url)")
//                    return url.appendingPathComponent(path)
//                } else {
//                    return nil
//                }
//            },
//                                            completion:{ (result) in
//                completion?(result)
//                switch result {
//                case .success(let model):
//                    print("[Attach Success] " + model.name! + ",totalSize:\(model.totalSize!)")
//                case .failure(let error):
//                    print("[Attach Failure] " + error.localizedDescription)
//                }
//            })
////            download(workflow: workflow)
//            return workflow
//            
//        } catch  {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
//    
//    //暂停、取消
//    static func pause(urlStr:String) {
//        WLM3U.cancel(url: URL(string: urlStr)!)
//    }
//    
//    //
//    static func resume(urlStr:String, completion: AttachCompletion? = nil) {
//        let url = URL(string: urlStr)!
//        do {
//            let workflow = try WLM3U.attach(url: url,
//                                            completion: { (result) in
//                switch result {
//                case .success(let model):
//                    print("[Attach Success] " + model.name!)
//                case .failure(let error):
//                    print("[Attach Failure] " + error.localizedDescription)
//                }
//            })
//            
//            download(workflow: workflow)
//            
//        } catch  {
//            print(error.localizedDescription)
//        }
//    }
//    
//    //（速度值，进度值， 速度文本， 进度文本）
//    public typealias DownloadCall = (Int, Double, String, String) -> ()
//    //转码回调
//    //（是否成功，保存完整地址，文件名字）
//    public typealias TranscodingCall = (Bool, String, String) -> ()
//    
//    static func download(workflow: Workflow, call: DownloadCall? = nil, progressCall: DownloadProgress? = nil, completion: DownloadCompletion? = nil, eCodeCall: TranscodingCall? = nil) {
//        ///开始下载分片
//        workflow.download(progress: { (progress, completedCount) in
//            var text = ""
//            let mb = Double(completedCount) / 1024 / 1024
//            if mb >= 0.1 {
//                text = String(format: "%.1f", mb) + " M/s"
//            } else {
//                text = String(completedCount / 1024) + " K/s"
//            }
//            
//            let pStr = String(format: "%.2f", progress.fractionCompleted * 100) + " %"
//            print("download speed: \(text)" + ", download progress:" + pStr)
//            call?(completedCount, progress.fractionCompleted, text, pStr)
//            progressCall?(progress, completedCount)
//        }, completion: { (result) in
//            completion?(result)
//            switch result {
//            case .success(let url):
//                print("[Download Success] " + url.path)
//                self.getAllFilePath(dPath)
//                self.perform(workflow: workflow,eCodeCall: eCodeCall)
//            case .failure(let error):
//                print("[Download Failure] " + error.localizedDescription)
//            }
//        })
//    }
//    
//    ///转码Mp4【无需解密版本】
//    static func transcoding(path tsPath:String, name:String, eCodeCall: TranscodingCall? = nil){
//        
//        FileOperation.createFinder(path: mp4Path)
//        getAllFilePath(dPath);
//        filePath1 = mp4Path + "/\(name).mp4"
//        let command = "-i '\(tsPath)' '\(filePath1!)'"
//        print("开始转码mp4  command = \(command)")
////        let result = MobileFFmpeg.execute(command)
////        print("转码完成 状态：\(result)")
////        if result == 0 {
////            // 转码完成
////            getAllFilePath(dPath)
////            //播放
////            //            playOne()
////            eCodeCall?(true, filePath1, name)
////        }else{
////            eCodeCall?(false, "", "")
////        }
//        eCodeCall?(false, "", "")
//    }
//    
//    //【方案2】解析 加密与未加密分别处理
//    // 下载并写入key 修改m3u8文件 ff转码MP4
//    static func perform(workflow: Workflow, eCodeCall: TranscodingCall? = nil){
//        //查询文件
//        //        self.getAllFilePath(NSHomeDirectory() + "/Documents/WLM3U")
//        self.getAllFilePath(dPath)
//        
//        let urlString:String = workflow.url.absoluteString
//        let m3u8FileName = workflow.model.name!
//        
//        //原m3u8
//        let m3u8FilePath = NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/file.m3u8"
//        //解密修改m3u8写入路径
//        let m3u8FilePathNew = NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/fileNew.m3u8"
//        
//        
//        //读取真实m3u8文件
//        //e: URI="/short_video/20210916/enc.key",IV=0x00000000000000000000000000000000
//        let fileContent = readLoactionFile(m3u8FilePath)
//        
//        //提取key url
//        let post1 = fileContent.positionOf(sub: "URI=")
//        let post2 = fileContent.positionOf(sub: "key")
//        if post2 >= 0 {
//            //加密
//            ///截取目标字符串
//            let keyUrl = fileContent[(post1 + 5)...(post2 + 2)]
//            print("提取keyUrl = \(keyUrl)")
//            
//            //获取域名 并 链接keyUrl
//            let domainUrl = URL(string: urlString)!.host!
//            print("提取domainUrl = \(domainUrl)")
//            
//            
//            //读取net 网络文件  https://testc.hzsy66.cn/short_video/20210916/enc.key"
//            let keyStr = readNetUrlKey("https://" + domainUrl + keyUrl)
//            
//            //写入文件key ts/
//            FileOperation.writeStrToFile(writeFilePath: NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/ts/key.key", writeContent: keyStr)
//            ///输出日志
//            _ = readLoactionFile(NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)/ts/key.key")
//            self.getAllFilePath(dPath + "/WLM3U")
//            
//            
//            //修改 m3u8文件 写入文件 m3u8FilePath
//            let newFileContent = fileContent.replacingOccurrences(of: keyUrl, with: "ts/key.key")
//            FileOperation.writeStrToFile(writeFilePath: m3u8FilePathNew, writeContent: newFileContent)
//            _ = readLoactionFile(m3u8FilePathNew)
//            
//            //创建mp4写入目录
//            FileOperation.createFinder(path: mp4Path)
//            
//            //转码
//            filePath1 = mp4Path + "/\(m3u8FileName).mp4"
//            let command = "-allowed_extensions ALL -i \(m3u8FilePathNew) -c copy \(filePath1!)"
//            print("开始转码mp4  command = \(command)")
////            let result = MobileFFmpeg.execute(command)
////            print("转码完成 状态：\(result)")
////            if result == 0 {
////                print("删除ts文件：")
////                FileOperation.removeFolder(folderUrl: NSHomeDirectory() + "/Documents/WLM3U/\(m3u8FileName)",rmFolder: true)
////                eCodeCall?(true, filePath1, m3u8FileName)
////            }else{
////                eCodeCall?(false, "", "")
////            }
//            eCodeCall?(false, "", "")
//            
//            self.getAllFilePath(mp4Path)
//            
//        }else{
//            //未加密
//            workflow.combine(completion: { [self] (result) in
//                switch result {
//                case .success(let url):
//                    print("[Combine Success] " + url.path)
//                    //开始转码mp4
//                    self.transcoding(path: url.path, name: workflow.model.name!, eCodeCall: eCodeCall)
//                case .failure(let error):
//                    print("[Combine Failure] " + error.localizedDescription)
//                }
//            })
//        }
//    }
//    
//    //读取本地文件
//    static func readLoactionFile(_ path:String) -> String{
//        //        path = "/Documents/WLM3U/playlist/file.m3u8"
//        //        let m3u8FilePath = (NSHomeDirectory() + path)
//        do {
//            let fileContent = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
//            print("m3u8文件信息：\n\(fileContent)")
//            return fileContent
//        } catch {
//            print("读取文件信息失败 path = \(path)")
//            return ""
//        }
//    }
//    
//    
//    ///从网络URL读取文本文件
//    static func readNetUrlKey(_ urlStr:String) -> String{
//        //        let urlStr = "https://testc.hzsy66.cn/short_video/20210916/enc.key"
//        if let url = URL(string: urlStr) {
//            do {
//                let contents = try String(contentsOf: url)
//                print(contents)
//                return contents
//            } catch {
//                print("读取网络文本信息失败 urlStr = \(urlStr)")
//                return ""
//            }
//        } else {
//            print("the URL was bad! urlStr = \(urlStr)")
//            return ""
//        }
//    }
//    
//    //查询dirPath目录
//    static func getAllFilePath(_ dirPath: String) {
//        //获得此文档下所有内容，以及子文件夹下的内容，并储存在一个数组对象中
//        let contents = FileManager.default.enumerator(atPath: dirPath)
//        if let allObjects = contents?.allObjects {
//            print("查询目录:\(allObjects)\n")
//        }
//    }
//}
