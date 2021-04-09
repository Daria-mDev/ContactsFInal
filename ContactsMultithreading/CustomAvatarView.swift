//
//  CustomAvatarView.swift
//  ContactsMultithreading
//
//  Created by user on 05.04.2021.
//

import UIKit

@IBDesignable
class CustomAvatarView: UIView {
    var text: String = " "
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = rect.width / 2;
        let path = UIBezierPath(ovalIn: rect)
        UIColor.random.setFill()
        path.fill()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 36)]
        let attributedText = NSMutableAttributedString(string: self.text, attributes: attributes)
        let textSize: CGSize = attributedText.size()
        let AvatarViewCenter = CGPoint(x:(rect.width - textSize.width)/2, y: (rect.height - textSize.height)/2)
        attributedText.draw(at:AvatarViewCenter)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat(drand48()),
                       green: CGFloat(drand48()),
                       blue: CGFloat(drand48()),
                       alpha: 1.0)
    }
}
