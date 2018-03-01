//
//  XYXFlatSegmentControl.swift
//  XYXFlatSegmentControlDemo
//
//  Created by Teresa on 2018/2/28.
//  Copyright © 2018年 Teresa. All rights reserved.
//

import UIKit

@objc protocol XYXFlatSegmentControlDelegate {
    @objc func segmentControlValueChanged(at index:Int)
}

class XYXFlatSegmentControl: UIView {
    
    //  Buttons and underline
    var buttonFontSize:CGFloat = 16.0
    var buttonSelectedColor = UIColor.orange{
        didSet{
            underline.backgroundColor = buttonSelectedColor
            for button in buttons {
                button.setTitleColor(buttonSelectedColor, for: .selected)
            }
        }
    }
    var buttonNormalColor = UIColor.gray
    var underlineThickness:CGFloat = 1.5{
        didSet{
            underline.frame = CGRect(x: underline.frame.minX, y: underline.frame.minY, width: underline.frame.width, height: underlineThickness)
        }
    }
    var underlineShouldDisplay = true{
        didSet{
            configureunderline(animationDuration: 0)
        }
    }
    var defaultSelectedIndex = 0 {
        didSet{
            selectedButtonTag = defaultSelectedIndex + buttonTagFlag
            
            for item in buttons {
                if item.tag == selectedButtonTag{
                    item.isSelected = true
                }else{
                    item.isSelected = false
                }
            }
            configureunderline(animationDuration: 0)
        }
    }
    
    //  Gap
    @IBInspectable var horizontalGap:CGFloat = 8.0 //左右两侧
    @IBInspectable var verticalGap:CGFloat = 4.0   //垂直上下
    @IBInspectable var buttonGap:CGFloat = 4.0     //按钮之间
    
    //  Delegate
    @IBOutlet var delegate:XYXFlatSegmentControlDelegate? = nil
    
    //  Titles
    var titles:[String] = []
    
    //  Constant
    fileprivate let buttonTagFlag = 1000
    
    fileprivate let underline = UIView()
    fileprivate var buttons:[UIButton] = []
    fileprivate var selectedButtonTag:Int = 0
    
    //  Volatile
    fileprivate var buttonWidth:CGFloat = 44.0
    fileprivate var buttonHeight:CGFloat = 44.0
    
    
    //MARK: - Life Cycle
    
    convenience init() {
        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedButtonTag = buttonTagFlag
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedButtonTag = buttonTagFlag
        buttonHeight = frame.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        guard titles.count > 0 else {
            return
        }
        
        buttonWidth = (frame.width - 2*horizontalGap - CGFloat(titles.count-1)*buttonGap) / CGFloat(titles.count)
        buttonHeight = frame.height - 2*verticalGap
        
        var idx = 0
        
        for title in titles {
            let button = createButton()
            button.frame = CGRect(x: horizontalGap + (buttonWidth+buttonGap)*CGFloat(idx), y: verticalGap, width: buttonWidth, height: buttonHeight)
            button.tag = idx + buttonTagFlag
            button.setTitle(title, for: UIControlState.normal)
            addSubview(button)
            buttons.append(button)
            if button.tag == selectedButtonTag{
                button.isSelected = true
            }
            idx += 1
        }
        
        configureunderline(animationDuration: 0)
    }
    
    //MARK: -
    
    fileprivate func createButton() -> UIButton {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(buttonSelectedColor, for: UIControlState.selected)
        button.setTitleColor(buttonNormalColor, for: UIControlState.normal)
        button.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }
    
    @objc fileprivate func buttonClick(sender:UIButton) {
        
        for item in buttons {
            if item.tag == sender.tag{
                item.isSelected = true
            }else{
                item.isSelected = false
            }
        }
        
        guard selectedButtonTag != sender.tag else{
            return
        }
        
        let idx = sender.tag - buttonTagFlag
        if let theDelegate = self.delegate {
            theDelegate.segmentControlValueChanged(at: idx)
        }
        selectedButtonTag = sender.tag

        let animationDuration = 0.1 + fabs(Double(sender.tag - selectedButtonTag)) * 0.05
        configureunderline(animationDuration: animationDuration)
        
    }
    
    @objc fileprivate func configureunderline(animationDuration:TimeInterval) {
        guard buttons.count > 0 else {
            return
        }
        guard underlineShouldDisplay == true else {
            underline.removeFromSuperview()
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(configureunderline(animationDuration:)), object: nil)
        
        if underline.superview == nil {
            underline.backgroundColor = buttonSelectedColor
            addSubview(underline)
        }
        
        let selectedButton = buttons[selectedButtonTag - buttonTagFlag]
        selectedButton.layoutSubviews()
        let titleLabelFrame = selectedButton.titleLabel?.frame ?? CGRect.zero
        let idx = selectedButtonTag - buttonTagFlag

        if animationDuration > 0 {
            UIView.animate(withDuration: animationDuration) {[unowned self] in
                self.underline.frame = CGRect(x: titleLabelFrame.minX + self.horizontalGap + (CGFloat(self.buttonGap)+self.buttonWidth)*CGFloat(idx), y: titleLabelFrame.maxY+4, width: titleLabelFrame.width, height: self.underlineThickness)
            }
        } else {
            self.underline.frame = CGRect(x: titleLabelFrame.minX + self.horizontalGap + (CGFloat(self.buttonGap)+self.buttonWidth)*CGFloat(idx), y: titleLabelFrame.maxY+4, width: titleLabelFrame.width, height: self.underlineThickness)
        }
        
    }
}
