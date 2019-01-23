//
//  DetailViewController.swift
//  ComcastCodingTest
//
//  Created by Yash Singh on 1/17/19.
//  Copyright © 2019 Yash Singh. All rights reserved.
//

import UIKit
import SDWebImage


class DetailViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var vm: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        view.layoutIfNeeded()

        iconImageView.sd_setImage(with: vm?.convertImageStringToURL(), placeholderImage: UIImage(named: placeholderImage) , options: .refreshCached, completed: nil)
        
        descriptionLabel.text = vm?.characterDescription
        self.title = vm?.name
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
