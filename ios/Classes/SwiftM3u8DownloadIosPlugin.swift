import Flutter
import UIKit

public class SwiftM3u8DownloadIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "m3u8_download_ios", binaryMessenger: registrar.messenger())
        let instance = SwiftM3u8DownloadIosPlugin()
        SwiftM3u8DownloadIosEvent._instace = SwiftM3u8DownloadIosEvent(name: "m3u8_download_ios_event",messenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
//        print("call method: \(call.method)")
        
        var arguments:Dictionary<String, Any>?
        if call.arguments != nil {
//            print("call.arguments: \(call.arguments!)")
            arguments = call.arguments as? Dictionary<String, Any>
        }
        
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "documentsPath" {
            result(M3u8Helper.dPath)
        }else if call.method == "initializeIos" {
            ///[debugMode] 调试模式
            ///[url] 调试模式
            if let debugModel = arguments?["debugModel"] as? Bool {
                M3u8Helper.debugMode = debugModel
            }
            //            EventChannel.instace().events!(["initOk":true])
            result(true)
        }else if call.method == "downloadIos" {
            if let url = arguments?["url"] as? String {
                _ = M3u8Helper.attach(urlStr: url, completion: nil)
                result(true)
            }
            result(false)
        }else if call.method == "removeFolder" {
            if let folderUrl = arguments?["folderUrl"] as? String, let rmFolder = arguments?["rmFolder"] as? Bool {
                FileOperation.removeFolder(folderUrl: folderUrl,rmFolder: rmFolder)
            }
        }
        else if call.method == "createFinder" {
            if let path = arguments?["path"] as? String {
                FileOperation.createFinder(path: path)
            }
        }
        else if call.method == "listFolder" {
            if let folderUrl = arguments?["folderUrl"] as? String {
                //                FileOperation.listFolder(folderUrl: folderUrl)
                M3u8Helper.getAllFilePath(folderUrl, true)
            }
        }
        
    }
}
