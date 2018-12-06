//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Felipe Ribeiro on 06/12/18.
//  Copyright © 2018 Felipe Ribeiro. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Properties
    
    var indexPath: IndexPath?
    
    // MARK: Computed Properties
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let indexPath = indexPath else { return }
        imageView.image = memes[indexPath.row].memedImage!
    }
}
