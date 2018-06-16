//
//  ChatLogController.swift
//  ChatLog
//
//  Created by George Mihaila on 6/9/18.
//  Copyright © 2018 George Mihaila. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var messages = [Message]()
    var show_progress: Bool?
    
    func newMessage(user:String, text:String, image:UIImage?)->Message{
        let new_message = Message()
        new_message.user = user
        new_message.text = text
        new_message.image = image
        return new_message
    }
    
    // TEXT FIELD
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupKeyboardObeservers()
        
        // if there are no messages
        if messages.count == 0  {
//            messages.append(newMessage(user: "customer", text: "", image: UIImage(named: "state-farm-logo")))
            messages.append(newMessage(user: "agent", text: "Hey there!\nI am your State Farm Agent.", image: nil))
            messages.append(newMessage(user: "agent", text: "I am here to assist you with your claim.", image: nil))
            messages.append(newMessage(user: "agent", text: "You can describe your claim here, and you can also send pictures here of any documents that might help wiht the claim.", image: nil))
        }
        
        
        collectionView?.contentInset = UIEdgeInsetsMake(58, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 50, 0)
        
       collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        setupComponents()
    }
    
    func setupKeyboardObeservers(){
        // to bring it u[
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // to bring it back down
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // avoids memory leak
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // bring keyboard down
    @objc func handleKeyboardWillHide() {
        containerViewBottomAnchor?.constant = 0
    }
    // get keyboard size and bring it up
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        // move input area up
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
    }
    
    
    // numb of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    // deal with cells MOST IMPORTANT
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        
        
        if message.image == nil {
            // only text
            cell.textView.text = message.text
            cell.messageImageView.isHidden = true
            //modify width of buble
            cell.bubbleWidthAnchor?.constant = estimateFrameText(text: message.text!).width + 32
        } else {
            // only image
            cell.textView.text! = ""
            cell.messageImageView.image = message.image
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
            //modify width of buble
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        
        
        // check where the message is comming form
        if message.user! == "customer" {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.bubbleViewRightAncor?.isActive = true
            cell.bubbleViewLefttAncor?.isActive = false
            cell.profileImageView.isHidden = true
        } else if message.user! == "agent" {
            //incomming gray
            cell.bubbleView.backgroundColor = ChatMessageCell.redColor
            cell.bubbleViewRightAncor?.isActive = false
            cell.bubbleViewLefttAncor?.isActive = true
            cell.profileImageView.isHidden = false
        }
        
        return cell
    }
    
    
    // expand cells to entire HEIGHT - GET HEIGHT OF TEXT OR IMAGE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 200
        
        let message: Message = messages[indexPath.item]
        
        if message.image == nil {
            // deal only with text
            height = estimateFrameText(text: message.text!).height + 20
        } else {
            // deal with image
            // do some ratio math
            let original_height = (message.image?.size.height)!
            let original_widht = (message.image?.size.width)!
            let ratio = original_height / original_widht
            height = 200 * ratio
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupComponents() {
        
        // add container on top for progress bar
        let top_container = UIView()
        top_container.backgroundColor = UIColor.white
        top_container.translatesAutoresizingMaskIntoConstraints = false
        // add to view
        view.addSubview(top_container)
        // xyz coordinates
        top_container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        top_container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        top_container.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        top_container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //home button
        let home_button = UIButton(type: .system)
        home_button.setTitle("<Back", for: .normal)
        home_button.translatesAutoresizingMaskIntoConstraints = false
        home_button.addTarget(self, action: #selector(handleHome), for: .touchUpInside)
        top_container.addSubview(home_button)
        //x y z
        home_button.topAnchor.constraint(equalTo: top_container.topAnchor, constant: 17).isActive = true
        home_button.leftAnchor.constraint(equalTo: top_container.leftAnchor).isActive = true
        home_button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        home_button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // show proggress
        let progress_bar = UIImageView()
        progress_bar.image = UIImage(named: "progress_bar")
        progress_bar.isHidden = self.show_progress!
        progress_bar.translatesAutoresizingMaskIntoConstraints = false
        progress_bar.layer.cornerRadius = 16
        progress_bar.layer.masksToBounds = true
        progress_bar.contentMode = .scaleAspectFit
        // progress bar add
        top_container.addSubview(progress_bar)
        // location
        progress_bar.centerXAnchor.constraint(equalTo: top_container.centerXAnchor).isActive = true
        progress_bar.topAnchor.constraint(equalTo: top_container.topAnchor, constant: 5).isActive = true
        progress_bar.widthAnchor.constraint(equalToConstant: 250).isActive = true
        progress_bar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // nottom window for button and text fiels
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add upload image button
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_logo")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        //x y z
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 2).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        // BUTTON SEND
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x y z
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // TEXT FIELD
        containerView.addSubview(inputTextField)
        //x y z
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // LINE SEPARATOR
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        //x y z
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    private func estimateFrameText(text: String)->CGRect {
        let size = CGSize(width: 200, height: 1000)
        let font: UIFont = UIFont.systemFont(ofSize: 16)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
    }
    
    // rotate invariant
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // button for send
    @objc func handleSend(){
        // append only if it's text
        if inputTextField.text! != "" {
            // append message
            self.messages.append(newMessage(user: "customer", text: inputTextField.text!, image: nil))
            // reload chat
            collectionView?.reloadData()
            
            self.inputTextField.text = nil
        }
       
    }
    
    // upload button is pressed
    @objc func handleUploadTap(){
        let cameraViewController:CameraViewController = CameraViewController()
        cameraViewController.messages = self.messages
        cameraViewController.show_progress = self.show_progress
        print(messages.count)
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @objc func handleHome(){
        self.dismiss(animated: false, completion: nil)
        
//        let viewController:ViewController = ViewController()
//        // send any variables back
//        present(viewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("We selected an image")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
