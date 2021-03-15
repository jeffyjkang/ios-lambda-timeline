//
//  AudioTableViewCell.swift
//  LambdaTimeline
//
//  Created by Jeff Kang on 3/14/21.
//  Copyright © 2021 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTableViewCell: UITableViewCell {
    
    var audioPlayer = AVAudioPlayer()
    
    var mediaData: Data?
    
    private let cache = Cache<String, Data>()
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard let mediaData = mediaData else { return }
        do {
            audioPlayer =  try AVAudioPlayer(data: mediaData)
            audioPlayer.play()
        } catch {
            print("error playing audio")
        }
    }
    
    var audioComment: Comment? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let audioComment = audioComment else { return }
        author.text = audioComment.author.displayName
        
        guard let audioURL = URL(string: audioComment.audioURL!) else { return }
        
        URLSession.shared.dataTask(with: audioURL) { (data, response, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                return
            }
            guard let data = data else {
                NSLog("No data returned")
                return
            }
            self.mediaData = data
        }.resume()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
