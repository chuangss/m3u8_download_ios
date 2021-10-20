//
//  EventChancel.swift
//  m3u8_downloader
//
//  Created by one on 2021/10/18.
//

import Foundation
import Flutter
import UIKit

public class SwiftM3u8DownloadIosEvent:NSObject, FlutterStreamHandler{
    
    static var _instace:SwiftM3u8DownloadIosEvent!
    static func instace() -> SwiftM3u8DownloadIosEvent{
        if _instace == nil {
            _instace = SwiftM3u8DownloadIosEvent()
        }
        return _instace
    }
    
    var channel:FlutterEventChannel?
    var count =  0
    var events:FlutterEventSink?
    
    public override init() {
        super.init()
    }
    
    convenience init(name:String,messenger: FlutterBinaryMessenger) {
        self.init()
        channel = FlutterEventChannel(name: name, binaryMessenger: messenger)
        channel?.setStreamHandler(self)
//        startTimer()
    }
    
    func startTimer() {
        let timer = Timer.scheduledTimer(timeInterval:1, target: self, selector:#selector(self.tickDown),userInfo:nil,repeats: true)
    }
    @objc func tickDown(){
        count += 1
        let args = ["count":count]
        if(events != nil){
            events!(args)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.events = nil
        return nil;
    }
}
