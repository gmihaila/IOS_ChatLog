//
//  PreviewViewController.swift
//  PhotoCamera
//
//  Created by George Mihaila on 5/27/18.
//  Copyright © 2018 George Mihaila. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var messages = [Message]()
    var image:UIImage!
    
    var show_progress: Bool?

    
    func newMessage(user:String, text:String, image:UIImage?)->Message{
        let new_message = Message()
        new_message.user = user
        new_message.text = text
        new_message.image = image
        return new_message
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setup image view
        let imageView = UIImageView()
        imageView.image = image      // get form Assets
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        // add it to subview
        view.addSubview(imageView)
        // anchor it
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        // setup top bar
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // add it to view
        view.addSubview(containerView)
        // anchor it
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // setup back button
        let back_button = UIButton(type: .system)
        back_button.setTitle("<Back", for: .normal)
        back_button.translatesAutoresizingMaskIntoConstraints = false
        back_button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        // container
        containerView.addSubview(back_button)
        // anchor it
        back_button.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        back_button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        back_button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        back_button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // setup save button to go back to message app
        let save_button = UIButton(type: .system)
        save_button.setTitle("Save", for: .normal)
        save_button.translatesAutoresizingMaskIntoConstraints = false
        save_button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        // container
        containerView.addSubview(save_button)
        // anchor it
        save_button.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        save_button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        save_button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        save_button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    // when push back button
    @objc func handleBack(){
        let cameraViewController:CameraViewController = CameraViewController()
        present(cameraViewController, animated: true, completion: nil)
    }
    
    // when push save button
    @objc func handleSave(){
        
        messages.append(newMessage(user: "customer", text: "", image:self.image))
       
        messages.append(newMessage(user: "agent", text: "We received your medical bill!", image:nil))
        
        messages.append(newMessage(user: "agent", text: "", image:UIImage(named: "progress_image")))
        
        // send message back
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        // append message
        chatLogController.messages = self.messages
        
        self.show_progress = true
        chatLogController.show_progress = self.show_progress
        print(messages.count)
        present(chatLogController, animated: true, completion: nil)
        
    }
    
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
