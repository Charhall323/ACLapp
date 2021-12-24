//
//  GradeTwoViewController.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/5/21.
//

import UIKit
import AVKit

class GradeTwoViewController: UIViewController {
    var timeObserver: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createButton() {
        let button = UIButton(frame: CGRect(x:0, y:0, width:200, height:50))
        button.center = view.center
        view.addSubview(button)
    }
    
    @IBAction func videoOnePlayed(_ sender: UIButton) {
        guard let url = Bundle.main.url(forResource: "Grade2_1", withExtension: "mp4") else { return }

            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
        addTimeObserver(player: player, videoName: "Sideline Hip Abduction")
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
    }
    
    @IBAction func videoTwoPlayed(_ sender: UIButton) {
        guard let url = Bundle.main.url(forResource: "Grade2_2", withExtension: "mp4") else { return }

            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
        addTimeObserver(player: player, videoName: "Standing AROM Single Leg Calf Raises")
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
    }
    
    
    
    @IBAction func VideoThreePlayed(_ sender: UIButton) {
        guard let url = Bundle.main.url(forResource: "Grade2_3", withExtension: "mp4") else { return }

            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            let player = AVPlayer(url: url)

            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
        addTimeObserver(player: player, videoName: "Standing Anterior Reachance")
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
                    PlayerHelper.uploadLogToFB(grade: "Grade 2", videoName: videoName, completionDate: Date())
                    if let observer = self.timeObserver {
                        player.removeTimeObserver(observer)
                        self.timeObserver = nil
                    }
                }
            }
        }
    }
}
    
            
