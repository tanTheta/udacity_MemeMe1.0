//
//  MemesTableViewController.swift
//  MemeMe1.0
//
//  Created by Tanvi Roy on 2/27/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        cell.cellLabel.text = "\(meme.topText!) ... \(meme.bottomText!)"
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

