//
//  AlarmSoundLocalView.swift
//  smartAlarm
//
//  Created by linkage on 2018/6/16.
//  Copyright © 2018年 hzt. All rights reserved.
//

import UIKit
import MediaPlayer

class AlarmSoundLocalView: UIViewController {
    @IBOutlet weak var selectAudioBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //从ipod库中读出音乐文件
        let everything = MPMediaQuery()
        let itemsFromGenericQuery = everything.items
        for song in itemsFromGenericQuery! {
            //获取音乐名称
//            let songTitle = song.value(forProperty: MPMediaItemPropertyTitle)
//            print("songTitle==\(songTitle!)")
//            //获取作者名称
//            let songArt = song.value(forProperty: MPMediaItemPropertyArtist)
//            print("songArt=\(songArt!)")
            //获取音乐路径
            let songUrl = song.value(forProperty: MPMediaItemPropertyAssetURL)
            print("songUrl==\(songUrl!)")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
