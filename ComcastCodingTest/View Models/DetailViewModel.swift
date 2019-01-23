//
//  DetailViewModel.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/18/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import Foundation

class DetailViewModel{
    var characterDescription: String
    var name: String
    var iconImageURLString: String
    
    init(characterDescription: String, name: String, iconImageURLString: String) {
        
        self.characterDescription = characterDescription
        self.name = name
        self.iconImageURLString = iconImageURLString
    }
    
    ///function name: convertImageStringToURL -> Converts a string to URL, used primarily for image with SDWebImage's sd_set function
    func convertImageStringToURL() -> URL{
        
        return URL(string: iconImageURLString) ?? URL(string: placeHolderImageURLString)!
    }
}
