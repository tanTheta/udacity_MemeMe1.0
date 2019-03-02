//
//  MemesDetailViewController.swift
//  MemeMe1.0
//
//  Created by Tanvi Roy on 2/27/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme! = nil
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = meme.memedImage
    }
    
}

