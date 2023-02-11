//
//  Presenter.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import Foundation
import AVFoundation

enum AudioState {
    case playing, stopped, paused, contin, blank
}

protocol PresenterDelegate: AnyObject {
    func playingStarted(_ song: String, _ singer: String)
    func playingStopped()
    func playingPaused()
    func playingContinue()
    func drawSlider(percent: CGFloat)
}

class PlayerPresenter {
    // DELEGATE
    weak var delegate: PresenterDelegate?
    public func setPresenterDelegate(delegate: PresenterDelegate) { self.delegate = delegate }
    
    // methods to use out of presenter
    public func startPlaying(idx: Int)  { self.position = idx }         // use to start playing
    public func stopPlaying()           { self.audioState = .stopped }  // use to stop playing
    public func pausePlaying()  { self.isPaused.toggle() }              // use to pause playing
    public func stateBtn(_ tag: Int) {
        switch tag {
        case 0: audioState = .playing
        case 1: audioState = .stopped
        case 2: self.nextSong()
        case 3: self.previousSong()
        default: print("ERROR!") }
    }

    // PRIVATE VARIABLES
    private var songs = Song.mockSongs              // receiving songs from Model
    private var timer = Timer()                     // initializing Timer class
    private var timerProgress: CGFloat = 0          // progress of song
    private var timerDuration = 0.0                 // duration of song
    private var player: AVAudioPlayer? = nil        // reference to AVAudioPlayer
    private var currentPosition: Int = -1           // current playing song index
    private var position: Int = 0 {                 // new song index to play or pause
        didSet { checkAndPlay(idx: position) }
    }
    private var isPaused: Bool = false {
        didSet { audioState = isPaused ? .paused : .contin }
    }
    
    // STATE of audio to manipulate
    private var audioState: AudioState = .blank {
        didSet {
            if audioState == .playing {
                currentPosition = position          // sets current song index up to new one
                timerProgress = 0.0
                startSong()                          // starting playing the song
                startTimer()
                print("\n\tAudioState => \(songs[position].title) is \(audioState) at position: \(position)\n")
                let song = songs[currentPosition]
                delegate?.playingStarted(song.title, song.author)
            } else if audioState == .stopped {
                currentPosition = -1                // if given index of song is equal to current then we change it
                player?.stop()                      // stop playing the song
                stopTimer()
                print("\n\tStoppped!\n")
                
                delegate?.playingStopped()
            } else if audioState == .paused {
                pauseTimer()
                player?.pause()
                delegate?.playingPaused()
            } else if audioState == .contin {
                playSong()
                startTimer()
                delegate?.playingContinue()
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
    private func startSong() {
        guard let url = Bundle.main.url(forResource: songs[currentPosition].title, withExtension: "mp3")
        else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
            self.timerDuration = player.duration    // setting duration of song
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func playSong() {
        player?.prepareToPlay()
        player?.play()
    }
    
    // SWITCH SONG METHODS
    private func nextSong() {                       // Switch the song to the next
        if position < songs.count - 1 {
            position += 1
            audioState = .playing
        }
    }
    private func previousSong() {                   // Switch the song to the previous
        if position >= songs.count - 1 {
            position -= 1
        }
        audioState = .playing
    }
    
    // Progress Bar methods
    private func configure(with duration: Double, progress: Double) {
        timerDuration = duration
        
        let tempCurrentValue = progress > duration ? duration : progress
        
        let goalValueDevider = duration == 0 ? 1 : duration
        let percent = CGFloat(tempCurrentValue / goalValueDevider)
        
        delegate?.drawSlider(percent: percent)
    }
    private func startTimer() {
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            self.timerProgress += 0.01
            if self.timerProgress > self.timerDuration {
                self.timerProgress = self.timerDuration
                timer.invalidate()
                self.audioState = .stopped
            }
            
            self.configure(with: self.timerDuration, progress: self.timerProgress)
        })
    }
    private func pauseTimer() {
        timer.invalidate()
    }
    private func stopTimer() {
        guard self.timerProgress > 0 else { return }
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            self.timerProgress -= 100
            if self.timerProgress <= 0 {
                self.timerProgress = 0
                timer.invalidate()
            }
            
            self.configure(with: self.timerDuration, progress: self.timerProgress)
        })
    }
}
