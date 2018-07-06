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
    var volumeTimer:Timer!
    var documentPath: NSString = "" // home地址
    var mediaDirectory: NSString = "" // 媒体文件地址
    var records: [Dictionary<String, String>] = [] // 录音列表
    var recordsPath: String = "" // 录音列表地址
    init() {
        let homePath = NSHomeDirectory() as NSString
        documentPath = homePath.appendingPathComponent("Documents") as NSString
        recordsPath = documentPath.appendingPathComponent("records.plist")
        
        let dataSource = NSArray(contentsOfFile: recordsPath)
        if dataSource != nil {
            records = dataSource as! [Dictionary<String, String>]
        }
        print("records", records)
        mediaDirectory = documentPath.appendingPathComponent("media") as NSString
        try! fileManager.createDirectory(atPath: mediaDirectory as String, withIntermediateDirectories: true, attributes: nil)
    }
    
    //开始录音
    func beginRecord() {
        print("beginRecord::enter")
        let index = records.count + 1
        let fileName = "record\(index)"
        let fileUrl = mediaDirectory.appendingPathComponent("\(fileName).wav")
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
            AVSampleRateKey: NSNumber(value: 44100),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFileMP3Type),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: 2,//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.medium.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: fileUrl)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            
            volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                               selector: #selector(levelTimer),
                                               userInfo: nil, repeats: true)
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
        records.insert(recordObj, at: 0)
        print("beginRecord end", records);
    }
    
    func getDefaultName() -> String {
        return "record\(records.count)"
    }
    
    // 暂停录音
    func pauseRecord() {
        print("pauseRecord::enter")
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上暂停")
            } else {
                print("没有录音，但是依然暂停")
            }
            recorder.pause()
            records[0]["status"] = "pause"
        } else {
            print("record没有初始化")
        }
        print("pauseRecord::end")
    }
    
    // 结束录音
    func stopRecord() {
        print("stopRecord::enter")
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束")
            } else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            records[0]["status"] = "done"
            self.recorder = nil
        } else {
            print("record没有初始化")
        }
        print("stopRecord::end")
    }
    
    func cancelRecord() {
        print("cancelRecord::enter")
        if let recorder = self.recorder {
            recorder.stop()
            try! fileManager.removeItem(atPath: records.first!["url"]!)
            records.removeFirst()
            print("cancelRecord done")
        } else {
            print("record没有初始化")
        }
        print("cancelRecord::end")
    }
    
    func renameAudio(audioName: String, successCall: (_ name: String) -> Void, failCall: (_ msg: String) -> Void) {
        print("renameAudio::enter")
        if audioName != "" {
            let toPath = mediaDirectory.appendingPathComponent("\(audioName).wav")
            let exist = fileManager.fileExists(atPath: toPath)
            if exist {
                failCall("file is exist!")
            } else {
                try! fileManager.moveItem(atPath: records.first!["url"]!, toPath: toPath)
                records[0]["name"] = audioName
                records[0]["url"] = toPath
                successCall(audioName)
            }
        } else {
            successCall(self.getDefaultName())
        }
        print("renameAudio::end")
    }
    
    //定时检测录音音量
    @objc private func levelTimer() {
        recorder!.updateMeters() // 刷新音量数据
        let averageV:Float = recorder!.averagePower(forChannel: 0) //获取音量的平均值
        let maxV:Float = recorder!.peakPower(forChannel: 0) //获取音量最大值
        let lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
//        volumLab.text = "录音音量:\(lowPassResult)"
//        return "录音音量:\(lowPassResult)"
        // TODO 显示音量
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RecordVolumeNotification"), object: ["volumeAverageLevel": averageV, "lowPassResult": lowPassResult])
    }
    
    //播放
    func play(name: String) {
        print("play::enter")
        let targetRecord = records.filter { (dict) -> Bool in
            return dict["name"] == name
        }
        print("play", targetRecord)
        if targetRecord.count > 0 {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: targetRecord[0]["url"]!))
                print("歌曲长度：\(player!.duration)")
                player!.play()
            } catch let err {
                print("播放失败:\(err.localizedDescription)")
            }
        }
        print("play::end")
    }
    
    func getList() -> [Dictionary<String, String>] {
        print("getList::enter")
        return records
    }
    
    func saveList() {
        print("saveList::enter")
        let filePath = documentPath.appendingPathComponent("records.plist")
        let dataSource = NSArray(array: records)
        dataSource.write(toFile: filePath, atomically: true)
        print("saveList::end")
    }
}
