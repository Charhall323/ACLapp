//
//  GradeTwoViewController.swift
//  ACLApp
//
//  Created by  Charlotte Hallisey on 12/5/21.
//

import UIKit
import AVKit

class GradeTwoViewController: UIViewController {
    

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
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
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
