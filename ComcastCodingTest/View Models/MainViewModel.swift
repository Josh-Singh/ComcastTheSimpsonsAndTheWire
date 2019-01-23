//
//  SimpsonsViewModel.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/17/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import Foundation
import UIKit

class MainViewModel: NSObject{
    var castCharactersArray: Array<CharacterModel> = []
    
    ///function: getArray -> calls API handler and returns array of characters obtained inside the completion handler
    
    func getCharacterModelArray(completion: @escaping (Array<CharacterModel>, String) -> ()){
        NetworkHandler.getSimpsonsCharactersAPIHandler { (resultArray, error) in
    
            if error == nil{
            self.castCharactersArray = resultArray
            for castMember in self.castCharactersArray{
                let nameAndDescriptionArray = self.getNameAndDescription(castMember: castMember)
                
                if nameAndDescriptionArray.count == 2{
                    castMember.name = nameAndDescriptionArray[0]
                    castMember.description = nameAndDescriptionArray[1]
                }else{
                    castMember.name = nameAndDescriptionArray[0]
                    castMember.description = nameAndDescriptionArray[0]
                }
            
            }
            completion(self.castCharactersArray, emptyString)
            }else{
                completion([], error?.localizedDescription ?? genericErrorString)
            }
            
        }
            
        
    }
    
    ///function: getNameAndDescription -> Breaks down text field in Character model and returns name and description inside an array which should ideally hold 2 elements corresponding to the same
    
    func getNameAndDescription(castMember: CharacterModel) -> Array<String>{
        let text = castMember.text
        if let nameAndDescription = text?.components(separatedBy: " - "){
            return nameAndDescription
        }else{
            return []
        }
    }
    
}
