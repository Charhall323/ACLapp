//
//  GradeOneViewController.swift
//  ACLApp
//
//  
//

import UIKit
import AVKit

class GradeOneViewController: UIViewController {
    //any = represents an instance of any time at all (any Swift type), can represent any class type
    var timeObserver: Any? //necessary for the function addTimeObserver
    

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
            controller.player = player //actually tracks the video playing

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
            controller.player = player //actually tracks the video playing

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
            controller.player = player //actually tracks the video playing 

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
    }
    
    func addTimeObserver(player: AVPlayer, videoName: String) { //have to observe the time to every 1.5 seconds to find out where you are in video to see if you have reached 80%
        let timeScale = CMTimeScale(NSEC_PER_SEC) //time scale is telling the system to use seconds
        let time = CMTime(seconds: 1.5, preferredTimescale: timeScale) //setting the system to check every 1.5 seconds to see if the current time is over 80%
        timeObserver = player.addPeriodicTimeObserver(forInterval:time, queue: .main) { //creating the time observer itself and adding it to the class local variable so that it can be removed once reaches 80% (avoids having repeats)
            [weak self] time in
            if let totalVideoDuration = player.currentItem?.duration.seconds, let self = self { //looking at the specific video duration
                if time.seconds >= totalVideoDuration * 0.8 { //if the video passes 80%
                    //helperfunction Player Helper below used because need to call the function multiple times so create it in a second class and put the function there and then call it each time
                    PlayerHelper.uploadLogToFB(grade: "Grade 3", videoName: videoName, completionDate: Date()) //upload to firebase and pass the video name to completion date (so that it will show up in progress view controller)
                    if let observer = self.timeObserver { //if the observer has reached 80% and the video has been added to the progress log, remove the time observer (so that it does not send to firebase again)
                        player.removeTimeObserver(observer) //removes time observer
                        self.timeObserver = nil //removes time observer
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
