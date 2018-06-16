//
//  MenuItemView.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit



protocol ImageViewController {
    
}

extension ImageViewController {
    func normalImage() -> UIImage? {
        return nil
    }
    func selectedImage() -> UIImage? {
        return nil
    }
}

class MenuItemView: UIView {
    // MARK: - Menu item view
    
    var titleLabel : UILabel?
    var menuItemSeparator : UIView?
    var imageView: UIImageView?
    var normalImage: UIImage?
    var selectedImage: UIImage?
    
    func setUpMenuItemView(_ menuItemWidth: CGFloat, menuScrollViewHeight: CGFloat, indicatorHeight: CGFloat, separatorPercentageHeight: CGFloat, separatorWidth: CGFloat, separatorRoundEdges: Bool, menuItemSeparatorColor: UIColor, menuImageWidth: CGFloat, menuImageHeight: CGFloat) {
        
        
        
        var result: (y: CGFloat, height: CGFloat) = (0.0, 0.0)
      
            result.y = 0.0
            result.height = menuScrollViewHeight
       
        
        titleLabel = UILabel(frame: CGRect(x: 0.0, y: result.y, width: menuItemWidth, height: result.height - indicatorHeight))

        
        menuItemSeparator = UIView(frame: CGRect(x: menuItemWidth - (separatorWidth / 2), y: floor(menuScrollViewHeight * ((1.0 - separatorPercentageHeight) / 2.0)), width: separatorWidth, height: floor(menuScrollViewHeight * separatorPercentageHeight)))
        menuItemSeparator!.backgroundColor = menuItemSeparatorColor
        
        if separatorRoundEdges {
            menuItemSeparator!.layer.cornerRadius = menuItemSeparator!.frame.width / 2
        }
        
        menuItemSeparator!.isHidden = true
        self.addSubview(menuItemSeparator!)
        
        if let normalImage = self.normalImage {
            self.imageView = UIImageView(image: normalImage)
            self.imageView!.contentMode = .scaleAspectFill
            self.imageView!.frame = CGRect(x: floor((menuItemWidth - menuImageWidth) / 2),y: 0,width: menuImageWidth, height: menuImageHeight)
            self.addSubview(self.imageView!)
        }
        
        self.addSubview(titleLabel!)
        
        
    }
    
    func setSelected(isSelected: Bool, animated: Bool = true) {
        guard let imageView = self.imageView else { return }
        
        if animated {
            let transition = CATransition()
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            imageView.layer.add(transition, forKey: nil)
        }
        
        if isSelected && selectedImage != nil {
            imageView.image = selectedImage!
        } else if normalImage != nil {
            imageView.image = normalImage!
        }
    }
    
    func setTitleText(_ text: NSString) {
        if titleLabel != nil {
            titleLabel!.text = text as String
            titleLabel!.numberOfLines = 0
            titleLabel!.sizeToFit()
        }
    }
    
    func configure(for pageMenu: CAPSPageMenu, controller: UIViewController, index: CGFloat) {
        if pageMenu.configuration.useMenuLikeSegmentedControl {
            //**************************拡張*************************************
            if pageMenu.menuItemMargin > 0 {
                let marginSum = pageMenu.menuItemMargin * CGFloat(pageMenu.controllerArray.count + 1)
                let menuItemWidth = (pageMenu.view.frame.width - marginSum) / CGFloat(pageMenu.controllerArray.count)
                self.setUpMenuItemView(menuItemWidth, menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor, menuImageWidth: pageMenu.configuration.menuImageWidth, menuImageHeight: pageMenu.configuration.menuImageHeight)
            } else {
                self.setUpMenuItemView(CGFloat(pageMenu.view.frame.width) / CGFloat(pageMenu.controllerArray.count), menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor, menuImageWidth: pageMenu.configuration.menuImageWidth, menuImageHeight: pageMenu.configuration.menuImageHeight)
            }
            //**************************拡張ここまで*************************************
        } else {
            self.setUpMenuItemView(pageMenu.configuration.menuItemWidth, menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor, menuImageWidth: pageMenu.configuration.menuImageWidth, menuImageHeight: pageMenu.configuration.menuImageHeight)
        }
        
        // Configure menu item label font if font is set by user
        self.titleLabel!.font = pageMenu.configuration.menuItemFont
        
        self.titleLabel!.textAlignment = NSTextAlignment.center
        self.titleLabel!.textColor = pageMenu.configuration.unselectedMenuItemLabelColor
        
        self.setSelected(isSelected: false)
        
        //**************************拡張*************************************
        self.titleLabel!.adjustsFontSizeToFitWidth = pageMenu.configuration.titleTextSizeBasedOnMenuItemWidth
        //**************************拡張ここまで*************************************
        
        // Set title depending on if controller has a title set
        if controller.title != nil {
            self.titleLabel!.text = controller.title!
        } else {
            self.titleLabel!.text = "Menu \(Int(index) + 1)"
        }
        
        // Add separator between menu items when using as segmented control
        if pageMenu.configuration.useMenuLikeSegmentedControl {
            if Int(index) < pageMenu.controllerArray.count - 1 {
                self.menuItemSeparator!.isHidden = false
            }
        }
    }
}

extension UILabel {
    func countLines() -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        guard let myText = self.text else {
            return 0
        }
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
