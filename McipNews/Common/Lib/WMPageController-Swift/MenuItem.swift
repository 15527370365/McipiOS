//
//  MenuItem.swift
//  PageController
//
//  Created by Mark on 15/10/20.
//  Copyright © 2015年 Wecan Studio. All rights reserved.
//

import UIKit

protocol MenuItemDelegate: NSObjectProtocol {
    func didSelectedMenuItem(menuItem: MenuItem)
}

class MenuItem: UILabel {
    
    // MARK: - Public vars
    var normalSize: CGFloat = 15.0
    var selectedSize: CGFloat = 18.0
    weak var delegate: MenuItemDelegate?
    
    var selected = false {
        didSet { rate = (selected == false) ? 0.0 : 1.0 }
    }
    
    var rate: CGFloat = 0.0 {
        didSet {
            let red = normalComponents.red + (selectedComponets.red - normalComponents.red) * rate
            let green = normalComponents.green + (selectedComponets.green - normalComponents.green) * rate
            let blue = normalComponents.blue + (selectedComponets.blue - normalComponents.blue) * rate
            let alpha = normalComponents.alpha + (selectedComponets.alpha - normalComponents.alpha) * rate
            let minScale = normalSize / selectedSize
            let trueScale = minScale + (1 - minScale) * rate
            textColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            transform = CGAffineTransformMakeScale(trueScale, trueScale)
        }
    }
    
    var normalColor: UIColor? {
        didSet {
            normalColor?.getRed(&normalComponents.red, green: &normalComponents.green, blue: &normalComponents.blue, alpha: &normalComponents.alpha)
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            selectedColor?.getRed(&selectedComponets.red, green: &selectedComponets.green, blue: &selectedComponets.blue, alpha: &selectedComponets.alpha)
        }
    }
    
    // MARK: - Private vars
    private var normalComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0.0, 0.0, 0.0, 0.0)
    private var selectedComponets: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0.0, 0.0, 0.0, 0.0)
    
    // MARK: - Public funcs
    func selectWithAnimation(select: Bool) -> Void {
        if selected == select { return }
        UIView.animateWithDuration(0.3) { () -> Void in
            if self.selected == true {
                self.rate = 0.0
            } else {
                self.rate = 1.0
            }
            self.selected = select
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Private funcs
    private func setup() {
        textAlignment = NSTextAlignment.Center
        userInteractionEnabled = true
        backgroundColor = .clearColor()
        numberOfLines = 0
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.didSelectedMenuItem(self)
    }
}
