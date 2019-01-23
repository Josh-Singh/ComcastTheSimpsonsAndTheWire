//
//  SimpsonsDetailViewModel.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/18/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import Foundation
import SDWebImage


class DetailViewModel{
     var characterDescription: String
     var iconImageURLString: String
     var name: String
    
    init(characterDescription: String, iconImageURLString: String, name: String) {
        self.characterDescription = characterDescription
        self.iconImageURLString = iconImageURLString
        self.name = name
    }
    
    func convertIconImageStringToURL() -> URL{
        return URL(string: iconImageURLString ?? "https://via.placeholder.com/100") ?? URL(string: "https://via.placeholder.com/100")!
    }
}
