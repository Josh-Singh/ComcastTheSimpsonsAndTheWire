//
//  MainViewController.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/17/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import UIKit
import SDWebImage
import NotificationCenter
import UserNotifications
import UserNotificationsUI


class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var elementsLoadedCounter: Int = 0
    
    var isDisplayingGridView = false
    var isSearching: Bool = false
    
    var castArray: Array<CharacterModel> = []
    let castVM = MainViewModel()
    
    var searchCastMember: Array<CharacterModel> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = AppConfig.mainVCName
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self

        getDataFromVM()
        
        //will make sure to reload the data from the API when app re-enters foreground
        NotificationCenter.default.addObserver(self, selector: #selector(getCharacterData), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //notification for obtaining data for progress bar
        NotificationCenter.default.addObserver(self, selector: #selector(setProgress), name: .didReceiveData, object: nil)
        progressBar.setProgress(0, animated: true)
        
        // Do any additional setup after loading the view.
        
    }
    
    ///function name: toggleButtonAction -> Toggles the collection view between list and grid view
    
    @IBAction func toggleButtonAction(_ sender: UIButton) {
        
        isDisplayingGridView = !isDisplayingGridView

        UIView.animate(withDuration: 0.2) {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
      
    }
    
    func getDataFromVM(){
        
        castVM.getCharacterModelArray { (resultArray, errorString) in
            if errorString == emptyString{
                self.castArray = resultArray
                
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                    
                }
            }else{
                self.showAlert(errorMessage: errorString)   //called if data is not loaded due to some error
            }
        }
    }
    
}

// MARK: - Extension CollectionView delegate and data source as well as UISearchBar delegate

/*extension that conforms to collection view data source and delegate protocols to implement said collection view.
 Also conforms to search bar delegate protocol for implementing searching functionality
 */

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSearching{
            return searchCastMember.count
        }else{
            return castArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as? SimpsonsCollectionViewCell
        
        if isSearching{
            cell?.castMemberNameLabel.text = searchCastMember[indexPath.row].name
            if isDisplayingGridView{
                //grid view - hide label and show image; and searching
                
                cell?.castMemberNameLabel.isHidden = true
                cell?.thumbnailImageView.isHidden = false
                
                if let iconString = searchCastMember[indexPath.row].icon {
                    cell?.thumbnailImageView.sd_setImage(with: URL(string: iconString), placeholderImage: UIImage(named: placeholderImage), options: [.progressiveDownload, .highPriority, .refreshCached], completed: nil)
                }
                
            }else{
                //list view - hide image view and show label
                
                cell?.thumbnailImageView.isHidden = true
                cell?.castMemberNameLabel.isHidden = false
                
            }
        }else{
            
            if isDisplayingGridView{
                //grid view - hide label and show image; not searching
                
                cell?.castMemberNameLabel.isHidden = true
                cell?.thumbnailImageView.isHidden = false
                
                if let iconString = castArray[indexPath.row].icon{
                    cell?.thumbnailImageView.sd_setImage(with: URL(string: iconString), placeholderImage: UIImage(named: placeholderImage), options: [.progressiveDownload, .highPriority, .refreshCached], completed: nil)
                    
                }

            }else{
                //list view - hide image view and show label
                
                cell?.thumbnailImageView.isHidden = true
                cell?.castMemberNameLabel.isHidden = false
                
            }
            cell?.castMemberNameLabel.text = castArray[indexPath.row].name
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: detailViewControllerIdentifier) as? DetailViewController
        
        if !isSearching{
            
        if let iconImageURL = castArray[indexPath.row].icon, let description = castArray[indexPath.row].description, let name = castArray[indexPath.row].name{
            let detailVM = DetailViewModel(characterDescription: description, name: name, iconImageURLString: iconImageURL)
            controller?.vm = detailVM
            }
            splitViewController?.showDetailViewController(controller!, sender: self)
        }else{
            if let description = searchCastMember[indexPath.row].description, let name = searchCastMember[indexPath.row].name, let iconImageURL = searchCastMember[indexPath.row].icon{
                
                let detailVM = DetailViewModel(characterDescription: description, name: name, iconImageURLString: iconImageURL)
                
                controller?.vm = detailVM
            }
            splitViewController?.showDetailViewController(controller!, sender: self)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCastMember = castArray.filter({$0.name!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        searchBar.text = emptyString
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let primaryWidth = splitViewController?.primaryColumnWidth
        
        if isDisplayingGridView{
            
            return CGSize(width: getGridCellWidthAndHeight(), height: getGridCellWidthAndHeight())
            
        }else{
           let widthReturn = primaryWidth ?? collectionView.frame.width
            
            return CGSize(width: widthReturn, height: CGFloat(tableViewCellImitationHeight))    //entire screen width x 50 cell size looking like a table view cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(minimumCellSpacing)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(minimumCellSpacing)
    }

    func getGridCellWidthAndHeight() -> CGFloat{
        
        let primaryWidth = splitViewController?.primaryColumnWidth
        let squareCellSide = CGFloat((primaryWidth! - CGFloat(minimumCellSpacing)/2))
        return squareCellSide
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    
}



extension MainViewController {
    @objc func getCharacterData(){
        
        getDataFromVM()
    }
    
    ///function increases the counter to get number of elements and updates the progress bar
    @objc func updateProgress(){

        DispatchQueue.main.async {
           self.elementsLoadedCounter = self.elementsLoadedCounter + 1
            self.progressBar.progress = Float(self.elementsLoadedCounter/AppConfig.totalCharacters)
                }
    }

    ///function allows for a slight delay before initializing the progress bar
    @objc func setProgress(){
        
        perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
    }
    

   
    }

