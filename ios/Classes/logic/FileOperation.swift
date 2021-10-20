//
//  FileOperation.swift
//  WLM3U_Example
//
//  Created by one on 2021/10/15.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

//文件操作类
class FileOperation {
    //把字符串写入指定文件中
    static func writeStrToFile(writeFilePath:String, writeContent:String){
        
        FileManager.default.createFile(atPath: writeFilePath, contents: nil, attributes: nil)
        let str = writeContent as String
        let wr = NSMutableData()
        wr.append(str.data(using:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        do {
            let writeHandler = try? FileHandle(forWritingAtPath:writeFilePath)
            if writeHandler != nil {
                writeHandler!.seekToEndOfFile()
                writeHandler?.write(wr as Data)
            }
        } catch {
            printDebug("写入文件中断 writeFilePath = \(writeFilePath)")
        }
        printDebug("文件写入完成：\(writeFilePath)")
    }
    
    
    //创建文件夹 无则创建 有则跳过
    static func createFinder(path:String){
        let isExist = FileManager.default.fileExists(atPath: path)
        if !isExist {
            do {
                try  FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                printDebug("createDirectory error:\(error)")
            }
        }
    }
    
    // 复制一个文件，到目标位置
    static func copyFile(sourceUrl:String, targetUrl:String) {
        let fileManager = FileManager.default
        do{
            try fileManager.copyItem(atPath: sourceUrl, toPath: targetUrl)
            printDebug("Success to copy file.")
        }catch{
            printDebug("Failed to copy file.")
        }
    }
    
    // 移动文件到目标位置
    static func movingFile(sourceUrl:String, targetUrl:String){
        let fileManager = FileManager.default
        let targetUrl = targetUrl
        printDebug("targetUrl = \(targetUrl)")
        do{
            try fileManager.moveItem(atPath: sourceUrl, toPath: targetUrl)
            printDebug("Succsee to move file.")
        }catch{
            printDebug("Failed to move file.")
        }
    }
    
    // 删除目标文件
    static func removeFile(sourceUrl:String){
        let fileManger = FileManager.default
        do{
            try fileManger.removeItem(atPath: sourceUrl)
            printDebug("Success to remove file.")
        }catch{
            printDebug("Failed to remove file.")
        }
    }
    
    // 删除目标文件夹下所有的内容
    // rmFolder 是否下载文件夹
    static func removeFolder(folderUrl:String, rmFolder:Bool){
        let fileManger = FileManager.default
        //然后获得所有该目录下的子文件夹
        let files:[AnyObject]? = fileManger.subpaths(atPath: folderUrl)! as [AnyObject]
        //创建一个循环语句，用来遍历所有子目录
        for file in files!
        {
            do{
                //删除指定位置的内容
                try fileManger.removeItem(atPath: folderUrl + "/\(file)")
                printDebug("Success to remove folder: \(folderUrl + "/\(file)")")
            }catch{
                printDebug("Failder to remove folder")
            }
        }
        if rmFolder {
            do{
                //删除文件夹
                try fileManger.removeItem(atPath: folderUrl)
                printDebug("Success to remove folder: \(folderUrl)")
            }catch{
                printDebug("Failder to remove folder")
            }
        }
        
    }
    
    // 遍历目标文件夹
    static func listFolder(folderUrl:String){
        let manger = FileManager.default
        //        获得文档目录下所有的内容，以及子文件夹下的内容，在控制台打印所有的数组内容
        let contents = manger.enumerator(atPath: folderUrl)
        printDebug("contents:\(String(describing: contents?.allObjects))")
        
    }
}
