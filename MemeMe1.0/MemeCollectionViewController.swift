//
//  MemesCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Tanvi Roy on 2/27/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.reloadData()
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}



