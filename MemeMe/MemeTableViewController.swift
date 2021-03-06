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
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Computed Properties
    
    var memes: [Meme] {
        get {
            return appDelegate.memes
        }
        set {
            appDelegate.memes = newValue
        }
    }
    
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        
        // Show the editor right away if there are no memes yet.
        if memes.isEmpty {
            let editor = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
            present(editor, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: UITableView Implementation
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.topText?.text = meme.topText
        cell.bottomText?.text = meme.bottomText
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.indexPath = indexPath
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        memes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
