//
//  CustomAvatarViewController.swift
//  ContactsMultithreading
//
//  Created by user on 06.04.2021.
//

import UIKit
import SwiftyGif

enum AvatarView {
    case customView
    case imageView
}

class CustomAvatarViewController: UIViewController {
    
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var customAvatarView: CustomAvatarView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    private var firstName: String = " "
    private var lastName: String = " "
    private var gifUrl: URL?
    private var avatarView: AvatarView = .customView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch avatarView {
        case .customView:
            hide(customView: false)
            customAvatarView.text = " \(firstName.first?.uppercased() ?? " ")\(lastName.first?.uppercased() ?? " ")"
        case .imageView:
            hide(customView: true)
            if let giUrl = gifUrl {
                avatarImageView.setGifFromURL(giUrl)
            }
        }
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        customAvatarView.text = " \(firstName.first?.uppercased() ?? " ")\(lastName.first?.uppercased() ?? " ")"
    }
    
    func setContactInfo(firstName: String, lastName:String, avatarView: AvatarView, gifUrl: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.avatarView = avatarView
        
        if let gifUrl = gifUrl {
            self.gifUrl = URL(string:gifUrl)
        }
    }
    
    private func hide(customView isCustomView: Bool) {
        avatarImageView.isHidden = !isCustomView
        customAvatarView.isHidden = isCustomView
    }
    
    @IBAction func tapAvatarView(_ sender: Any) {
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       options: [],
                       animations: {
                        let parentFrame = self.view.frame
                        let avatarViewFrame = self.customAvatarView.frame
                        let scaleValue = (0.7 * parentFrame.height) / avatarViewFrame.width
                        self.customAvatarView.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
                       })
    }
}
