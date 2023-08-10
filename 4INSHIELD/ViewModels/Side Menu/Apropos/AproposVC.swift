//
//  AproposVC.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/7/2023.
//

import UIKit
import AVKit
import AVFoundation

class AproposVC: UIViewController {

    @IBOutlet weak var playerView: UIView!
    var player: AVPlayer?
    var isPlaying = true // Keep track of the video player's playing status

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Create a player
        if let videoURL = Bundle.main.url(forResource: "inshield", withExtension: "mp4") {
            player = AVPlayer(url: videoURL)
        } else {
            // Handle the case where the video file is not found
            print("Video file 'inshield.mp4' not found.")
        }

        // Create a layer
        let layer = AVPlayerLayer(player: player)
        layer.frame = playerView.bounds
        layer.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(layer)

        // Add a play/pause button in the middle of the playerView
        let playButton = UIButton(type: .system)
        setPlayButtonImage(isPlaying: isPlaying) // Set the initial play button image
        playButton.tintColor = .white // Change the play button color to white
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playerView.addSubview(playButton)

        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ])

        // Start playing the video when the view appears
        player?.play()
    }

    @objc func playButtonTapped() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle() // Toggle the playing status
        setPlayButtonImage(isPlaying: isPlaying) // Update the play button image
    }
    
    //Update the play button image based on the current playing status
    func setPlayButtonImage(isPlaying: Bool) {
        let playButton = UIButton(type: .system)
        if isPlaying {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
