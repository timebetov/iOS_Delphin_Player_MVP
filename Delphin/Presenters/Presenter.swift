//
//  Presenter.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import Foundation
import AVFoundation

enum AudioState {
    case playing, stopped, paused, blank
}

protocol PresenterDelegate: AnyObject {
    func startedPlaying(idx: Int)
    func stoppedPlaying()
    func pausedPlaying()
}

class Presenter {
    // DELEGATE
    weak var delegate: PresenterDelegate?
    public func setPresenterDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    // methods to use out of presenter
    public func startPlaying(idx: Int)  { self.position = idx }         // use to start playing
    public func stopPlaying()           { self.audioState = .stopped }  // use to stop playing
    public func pausePlaying(idx: Int)  { self.position = idx }         // use to pause playing
    public func getCurrentState() -> AudioState { return self.stateToSend }

    // PRIVATE
    private var songs = Song.mockSongs              // importing songs from Model
    private var timer = Timer()                     // initializing Timer class
    private var timerProgress: CGFloat = 0          // progress of song
    private var timerDuration = 0.0                 // duration of song
    private var player: AVAudioPlayer? = nil        // reference to AVAudioPlayer
    private var stateToSend: AudioState = .paused   // passing current state
    private var currentPosition: Int = -1           // current playing song index
    private var position: Int = 0 { didSet          // new song index to play or pause
        { checkAndPlay(idx: position) }
    }
    
    // STATE of audio to manipulate
    private var audioState: AudioState = .blank {
        didSet {
            if audioState == .playing {
                stateToSend = audioState            // setting state to passing to PlayerView
                currentPosition = position          // sets current song index up to new one
                playSong()                          // starting playing the song
                print("\n\tAudioState => \(songs[position].title) is \(audioState) at position: \(position)\n")
                
                delegate?.startedPlaying(idx: currentPosition)
            } else if audioState == .stopped {
                stateToSend = audioState
                currentPosition = -1                // if given index of song is equal to current then we change it
                player?.stop()                      // stop playing the song
                print("\n\tStoppped!\n")
                
                delegate?.stoppedPlaying()
            }
        }
    }
    
    // Method checks: song with given index is playing or not yet
    private func checkAndPlay(idx: Int) {
        if currentPosition == idx {
            print("\n\tTHIS MUSIC IS STILL PLAYING!\n")
            audioState = .stopped
        } else {
            audioState = .playing
        }
    }
    
    // main method to start playing the song
    public func playSong() {
        guard let url = Bundle.main.url(forResource: songs[currentPosition].title, withExtension: "mp3")
        else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
            self.timerDuration = player.duration    // setting duration of song
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
