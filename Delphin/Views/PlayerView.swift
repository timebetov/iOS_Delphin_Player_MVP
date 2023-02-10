//
//  PlayerView.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import UIKit

class PlayerView: UIViewController {
    // REFERENCES to use
    fileprivate let presenter = Presenter()
    fileprivate let circleProgressView = CircleProgressView()
    
    // Audio State
    fileprivate var state: AudioState? = nil {
        didSet {
            print("\nPLAYER VIEW state has changed to \(state ?? .blank)\n")
            
            if state == .playing {
                self.isPlay()
                
            } else if state == .stopped {
                self.isPause()
                presenter.stopPlaying()
            } else {
                print("\n\n\nSTOP MAN\n\n\n")
            }
        }
    }
    fileprivate var position: Int = 0
    
    
    public func setState(_ this: AudioState) { self.state = this }
    public func setPosition(_ this: Int) { self.position = this }
    
    private func isPlay() {
        playButton.tag = 1
        let img = UIImage(systemName: K.Player.pause, withConfiguration: K.Player.centerConfig)
        playButton.setImage(img, for: .normal)
        centralImgView.rotate(true)
    }
    private func isPause() {
        playButton.tag = 0
        let img = UIImage(systemName: K.Player.play, withConfiguration: K.Player.centerConfig)
        playButton.setImage(img, for: .normal)
        centralImgView.rotate(false)
    }
    
        //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // just line
        presenter.setPresenterDelegate(delegate: self)      // signing delegate
        circleProgressView.drawProgress(percent: 0.0)       // draw circle progress with 0.0 percentage done
        
        // Adding all layers and views with constraints to this one
        // and I know that we can call this methods without self keyword just its more clear and understandable for me
        self.presentAllViewsAndLayers()
        self.setAllConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        centralImgView.roundedImage()                       // method turns square image into circle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // adding all subviews and layers etc...
    fileprivate func presentAllViewsAndLayers() {
        prevBtn.addTarget(self, action: #selector(controlTapped(sender: )), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(controlTapped(sender: )), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(controlTapped(sender: )), for: .touchUpInside)
        
        infoStack.addArrangedSubview(songTitle)
        infoStack.addArrangedSubview(authorName)
        
        controlStack.addArrangedSubview(prevBtn)
        controlStack.addArrangedSubview(playButton)
        controlStack.addArrangedSubview(nextBtn)

        view.addSubview(circleProgressView)
        view.addSubview(infoStack)
        view.addSubview(controlStack)
        view.insertSubview(centralImgView, aboveSubview: circleProgressView)
    }
    
    //MARK: - UIElements
    fileprivate var songTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.systemPink
        label.text = "Song title"
        return label
    }()
    fileprivate var authorName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.systemPink.withAlphaComponent(20)
        label.text = "Author"
        return label
    }()
    // Info stack contains UI Labels and image stack
    fileprivate var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    // Circul image in the view center
    fileprivate var centralImgView: UIImageView = {
        let circleImageView = UIImageView()
        circleImageView.image = UIImage(named: "musImg")
        circleImageView.contentMode = .scaleAspectFill
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
        circleImageView.roundedImage()
        return circleImageView
    }()
    // Button to play or pause
    fileprivate var playButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .systemPink
        btn.setImage(UIImage(systemName: K.Player.play, withConfiguration: K.Player.centerConfig)!, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 0
        return btn
    }()
    fileprivate var prevBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .systemPink
        btn.setImage(UIImage(systemName: K.Player.prev, withConfiguration: K.Player.sideConfig)!, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 3
        return btn
    }()
    fileprivate var nextBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .systemPink
        btn.setImage(UIImage(systemName: K.Player.next, withConfiguration: K.Player.sideConfig)!, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 2
        return btn
    }()
    // Control stack contains three control buttons
    fileprivate var controlStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Tracks button taps
    @objc private func controlTapped(sender: UIButton) {
        let tag = sender.tag
        print(tag)
        
        if tag == 1 {
            self.state = .stopped
        } else if tag == 0 {
            self.state = .playing
        }
    }
}

            //MARK: - PresenterDelegate
extension PlayerView: PresenterDelegate {
    func startedPlaying(idx: Int) {
        self.state = .playing
        self.position = idx
        
        print("\nCalled from Delegate: \tstartedPlaying\n\nPlayerView\n")
    }
    
    func stoppedPlaying() {
        self.state = .stopped
        
        print("\nCalled from Delegate: \tstoppedPlaying\n\nPlayerView\n")
    }
    
    func pausedPlaying() {
        print("\nCalled from Delegate: \tpausedPlaying\n\nPlayerView\n")
    }
}

            //MARK: - Constraints
extension PlayerView {
    // method for setting and calling all constraints
    fileprivate func setAllConstraints() {
        setInfoStackConstraints()
        setCentralImageViewConstraints()
        setCircleProgressViewConstraints()
        setControlStackConstraints()
    }
    
    // Circle Progress View constraints
    fileprivate func setCircleProgressViewConstraints() {
        NSLayoutConstraint.activate([
            circleProgressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            circleProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            circleProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
    }
    
    fileprivate func setCentralImageViewConstraints() {
        NSLayoutConstraint.activate([
            centralImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 225),
            centralImgView.heightAnchor.constraint(equalToConstant: 225),
            centralImgView.widthAnchor.constraint(equalToConstant: 225),
            centralImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    fileprivate func setInfoStackConstraints() {
        NSLayoutConstraint.activate([
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    fileprivate func setControlStackConstraints() {
        NSLayoutConstraint.activate([
            controlStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            controlStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            controlStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
    }
}
