//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Felipe Ribeiro on 29/11/18.
//  Copyright © 2018 Felipe Ribeiro. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    // MARK: Properties
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: UITableView Implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.topText?.text = meme.topText
        cell.bottomText?.text = meme.bottomText
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
}
