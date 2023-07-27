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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Create a player
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "inshield", ofType: "mp4")!))

        // Create a layer
        let layer = AVPlayerLayer(player: player)
        layer.frame = playerView.bounds
        layer.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(layer)

        // Add a play button in the middle of the playerView
        let playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .white
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
        player?.play()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

