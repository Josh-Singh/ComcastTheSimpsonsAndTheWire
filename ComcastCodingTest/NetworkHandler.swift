//
//  NetworkHandler.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/17/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import Foundation
import UIKit
import NotificationCenter

fileprivate var castCharactersArray: Array<CharacterModel> = []

class NetworkHandler: NSObject{
    var expectedContentLength = 0
    var buffer = NSMutableData()
    
    ///function: get___APIHandler -> Uses URLSession shared dataTask to obtain data from JSON; Returns [Character] inside the completion handler along with an error, if any.
    
    static func getSimpsonsCharactersAPIHandler(completion: @escaping (Array<CharacterModel>, Error?) -> ()){
        
        let task = URLSession.shared.dataTask(with: URL(string: AppConfig.urlString)!){ (data, response, error) in
            
            if error != nil{
                print("An error occurred")
                completion([], error)
            }else{
                do{
                    let dataObtained = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                    
                    guard let relevantData = dataObtained["RelatedTopics"] as? Array<Dictionary<String, Any>> else{
                        print("Couldn't get the related topics dictionary")
                        return
                    }
                    
                    for character in relevantData{
                        let newCharacter = CharacterModel()
                        newCharacter.text = character["Text"] as? String
                        newCharacter.result = character["Result"] as? String
                        
                        if let icon = character["Icon"] as? Dictionary<String, Any>{
                            if let iconURLString = icon["URL"] as? String{
                                newCharacter.icon = iconURLString
                            }
                        }
                        
                        castCharactersArray.append(newCharacter)
                        
                        //send notification here to inform Main view controller that an element has been appended to the array
                        DispatchQueue.main.async {
                            
                            NotificationCenter.default.post(name: .didReceiveData, object: nil)
                        }
                        
                    }
                    
                    
                    completion(castCharactersArray, nil)
                    
                }catch{
                    print("An error occurred during serialising data")
                    completion([], error)
                }
                
            }
            
        }
        task.resume()
    }
    
}
