//
//  ViewController.swift
//  ChatLog
//
//  Created by George Mihaila on 6/9/18.
//  Copyright © 2018 George Mihaila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var car_progress: UILabel!
    
    @IBOutlet weak var house_progress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func medical_button(_ sender: UIButton) {
        let chatLogController = ChatLogController(collectionViewLayout:
            UICollectionViewFlowLayout())
        chatLogController.show_progress = true
        present(chatLogController, animated: true, completion: nil)
    }
    
    @IBAction func car_claim(_ sender: UIButton) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.show_progress = true
        present(chatLogController, animated: true, completion: nil)
    }
    
    
}

