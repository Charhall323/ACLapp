//
//  GradeOneViewController.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/5/21.
//

import UIKit
import AVKit

class GradeOneViewController: UIViewController {
    var timeObserver: Any?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func videoOnePlayed(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "Grade1_1", withExtension: "mp4") else { return }

            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
        addTimeObserver(player: player, videoName: "Seated Passive Assisted Knee Extensions")
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
    }
    
    @IBAction func videoTwoPlayed(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "Grade1_2", withExtension: "mp4") else { return }

            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
        addTimeObserver(player: player, videoName: "Standing Single Leg Hip Extension With Resist")
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
    }
    
    
    @IBAction func videoThreePlayed(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "Grade1_3", withExtension: "mp4") else { return }

            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
        addTimeObserver(player: player, videoName: "Standing Hip Abduction with Resistance")
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
    }
    
    func addTimeObserver(player: AVPlayer, videoName: String) {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1.5, preferredTimescale: timeScale)
        timeObserver = player.addPeriodicTimeObserver(forInterval:time, queue: .main) {
            [weak self] time in
            if let totalVideoDuration = player.currentItem?.duration.seconds, let self = self {
                if time.seconds >= totalVideoDuration * 0.8 {
                    PlayerHelper.uploadLogToFB(grade: "Grade 3", videoName: videoName, completionDate: Date())
                    if let observer = self.timeObserver {
                        player.removeTimeObserver(observer)
                        self.timeObserver = nil
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
