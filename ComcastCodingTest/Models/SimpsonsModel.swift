//
//  SimpsonsModel.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/17/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import Foundation

///Model class for show's characters with data obtained from API call 
class CharacterModel{
    //obtained from JSON
    var text: String?
    var result: String?
    var icon: String?
    
    //created for use in MainViewController and DetailViewController
    var name: String?
    var description: String?
    
}
