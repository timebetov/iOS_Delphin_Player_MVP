//
//  Constants.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import Foundation
import UIKit

struct K {
    static let UIViewInitMsg = "Initialization init(frame: CGRect) does not impleneted."
    
    struct Welcome {
    }
    struct Songs {
        static let title = "Songs"
        static let cell = "songCell"
    }
    struct Favourites {
    }
    struct Player {
        static let songName = "Jocelyn Flores"
        static let songAuthor = "XXXTentacion"
        // configurations for SF Symbols
        static let centerConfig = UIImage.SymbolConfiguration(pointSize: 80)
        static let sideConfig = UIImage.SymbolConfiguration(pointSize: 50)
        static let play = "play.circle.fill"
        static let pause = "pause.circle.fill"
        static let next = "forward.end.circle.fill"
        static let prev = "backward.end.circle.fill"
        static let mainSliderColour = UIColor.systemPink
        static let backSliderColour = UIColor.gray.withAlphaComponent(0.4)
    }
}
