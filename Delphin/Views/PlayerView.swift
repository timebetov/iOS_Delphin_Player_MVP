//
//  PlayerView.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import UIKit

class PlayerView: UIViewController {
    // REFERENCES to use
    fileprivate let presenter = PlayerPresenter()
    fileprivate let circleProgressView = CircleProgressView()
    // POSITION of audio
    fileprivate var position: Int = 0 {
        didSet { presenter.startPlaying(idx: position) }
    }
    
    public func setPosition(_ this: Int) { self.position = this }       // setting position
    
        //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // just line
        presenter.setPresenterDelegate(delegate: self)                  // signing delegate
        circleProgressView.drawProgress(percent: 0.0)                   // draw circle progress with 0.0 percentage done
        
        let imageTap = UITapGestureRecognizer(
            target: self,
            action: #selector(pauseSong(tapGestureRecognizer:)))
        centralImgView.addGestureRecognizer(imageTap)
        
        // Adding all layers and views with constraints to this one
        // and I know that we can call this methods without self keyword just its more clear and understandable for me
        self.presentAllViewsAndLayers()
        self.setAllConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        centralImgView.roundedImage()                       // method turns square image into circle
    }
    
    // adding all subviews and layers etc...
    fileprivate func presentAllViewsAndLayers() {
        // adding handlers to all buttons
        prevBtn.addTarget(self, action: #selector(controlButtonsTapped(sender: )), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(controlButtonsTapped(sender: )), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(controlButtonsTapped(sender: )), for: .touchUpInside)
        // adding elements into stack located in TOP of view
        infoStack.addArrangedSubview(songTitle)
        infoStack.addArrangedSubview(authorName)
        // adding elements into stack located in BOTTOM of view
        controlStack.addArrangedSubview(prevBtn)
        controlStack.addArrangedSubview(playButton)
        controlStack.addArrangedSubview(nextBtn)

        view.addSubview(circleProgressView)
        view.addSubview(infoStack)
        view.addSubview(controlStack)
        view.insertSubview(centralImgView, aboveSubview: circleProgressView)
    }
    
    //MARK: - UIElements
    fileprivate var songTitle: UILabel = {              // Label which contains name of song
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.systemPink
        label.text = "Song title"
        return label
    }()
    fileprivate var authorName: UILabel = {             // Label which contains name of singer or author
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.systemPink.withAlphaComponent(20)
        label.text = "Author"
        return label
    }()
    
    fileprivate var infoStack: UIStackView = {          // Info stack contains UI Labels and image stack
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
    
    fileprivate var centralImgView: UIImageView = {     // Circul image in the view center
        let circleImageView = UIImageView()
        circleImageView.image = UIImage(named: "musImg")
        circleImageView.contentMode = .scaleAspectFill
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
        circleImageView.isUserInteractionEnabled = false
        circleImageView.roundedImage()
        return circleImageView
    }()
    
    fileprivate var playButton: UIButton = {            // Button to play or pause
        let btn = UIButton()
        btn.tintColor = .systemPink
        btn.setImage(UIImage(systemName: K.Player.play, withConfiguration: K.Player.centerConfig)!, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 0
        return btn
    }()
    fileprivate var prevBtn: UIButton = {               // Button switches to previous item
        let btn = UIButton()
        btn.tintColor = .systemPink
        btn.setImage(UIImage(systemName: K.Player.prev, withConfiguration: K.Player.sideConfig)!, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 3
        return btn
    }()
    fileprivate var nextBtn: UIButton = {               // Button switches to next item
        let btn = UIButton()
        btn.tintColor = .systemPink
        btn.setImage(UIImage(systemName: K.Player.next, withConfiguration: K.Player.sideConfig)!, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 2
        return btn
    }()
    
    fileprivate var controlStack: UIStackView = {       // Control stack contains three control buttons
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // Tracks button taps -----------------------------------------
    @objc private func controlButtonsTapped(sender: UIButton) {
        let tag = sender.tag
        print("\nSent => \(tag)\n")
        presenter.stateBtn(tag)
    }
    
    @objc private func pauseSong(tapGestureRecognizer: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        presenter.pausePlaying()
        print("\n\n\n\t\t\tPAUSE!")
    }
    private func isPlay(img: String, singer: String) {  // Method uses for update VIEW when song starts
        centralImgView.image = UIImage(named: img)
        self.songTitle.text = img
        self.authorName.text = singer
        playButton.tag = 1
        let img = UIImage(systemName: K.Player.stop, withConfiguration: K.Player.centerConfig)
        playButton.setImage(img, for: .normal)
        centralImgView.rotate(.start)
    }
    private func isStop() {                            // Method uses for update VIEW when song stops
        playButton.tag = 0
        let img = UIImage(systemName: K.Player.play, withConfiguration: K.Player.centerConfig)
        playButton.setImage(img, for: .normal)
        centralImgView.rotate(.stop)
    }
}

            //MARK: - PresenterDelegate
extension PlayerView: PresenterDelegate {
    func playingStarted(_ song: String, _ singer: String) {
        self.isPlay(img: song, singer: singer)
        centralImgView.isUserInteractionEnabled = true
        print("\nCalled from Delegate: \tstartedPlaying\n\nPlayerView\n")
    }
    
    func playingStopped() {
        self.isStop()
        centralImgView.isUserInteractionEnabled = false
        print("\nCalled from Delegate: \tstoppedPlaying\n\nPlayerView\n")
    }
    
    func playingPaused() {
        centralImgView.rotate(.pause)
        print("\nCalled from Delegate: \tpausedPlaying\n\nPlayerView\n")
    }
    
    func playingContinue() {
        centralImgView.rotate(.go)
    }
    
    func drawSlider(percent: CGFloat) {
        circleProgressView.drawProgress(percent: percent)
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
