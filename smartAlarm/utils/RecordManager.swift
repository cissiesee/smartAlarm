//
//  RecordManager.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/16.
//  Copyright © 2018年 hzt. All rights reserved.
//

import Foundation
import AVFoundation

class RecordManager {
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let fileManager = FileManager.default
    var documentPath = ""
    var mediaDirectory: String = ""
    var recordUrls: [Dictionary<String, String>] = []
    
    init() {
        documentPath = NSHomeDirectory() + "/Documents"
        mediaDirectory = documentPath + "/media"
        try! fileManager.createDirectory(atPath: mediaDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    //开始录音
    func beginRecord() {
        let index = recordUrls.count - 1
        let fileName = "/record\(index).wav"
        let fileUrl = mediaDirectory + fileName
        let recordObj = [
            "name": fileName,
            "url": fileUrl,
            "status": "recording"
        ]
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err {
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [
            AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: fileUrl)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
        recordUrls.insert(recordObj, at: 0)
    }
    
    
    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束")
            } else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            recordUrls[0]["status"] = "done"
            self.recorder = nil
        } else {
            print("没有初始化")
        }
    }
    
    func cancelRecord() {
        if let recorder = self.recorder {
            print("取消录音")
            recorder.stop()
            try! fileManager.removeItem(atPath: recordUrls.first!["url"]!)
            recordUrls.removeFirst()
            self.recorder = nil
        } else {
            print("没有初始化")
        }
    }
    
    func renameAudio(audioName: String, successCall: (_ name: String) -> Void, failCall: (_ msg: String) -> Void) {
        let toPath = mediaDirectory + "/\(audioName).wav"
        let exist = fileManager.fileExists(atPath: toPath)
        if exist {
            failCall("file is exist!");
        } else {
            try! fileManager.moveItem(atPath: recordUrls.first!["url"]!, toPath: toPath)
            recordUrls.append(["name": audioName, "url": toPath])
            successCall(audioName)
        }
    }
    
    //播放
    func play(name: String) {
        let targetRecord = recordUrls.filter { (dict) -> Bool in
            return dict["name"] == name
        }
        print(targetRecord)
        if targetRecord.count > 0 {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: targetRecord[0]["url"]!))
                print("歌曲长度：\(player!.duration)")
                player!.play()
            } catch let err {
                print("播放失败:\(err.localizedDescription)")
            }
        }
    }
    
}
