//
//  XYXFlatSegmentControl.swift
//  XYXFlatSegmentControlDemo
//
//  Created by Teresa on 2018/2/28.
//  Copyright © 2018年 Teresa. All rights reserved.
//

import UIKit

@objc public protocol XYXFlatSegmentControlDelegate {
    @objc func segmentControlValueChanged(at index:Int)
}

open class XYXFlatSegmentControl: UIView {
    
    //MARK: - Public Member
    
    /// 这样设置则按钮没有图标. 若需要设置图标请使用configureButtons(titles,images)来设定
    open var titles:[String] = []{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.05) { [weak self] in
                self?.layoutSubviews()
            }
        }
    }
    
    /// 按钮图标。需要通过configureButtons(titles,images)来设定
    private var buttonImageNames:[String] = []
    
    //  Buttons and underline
    open var buttonFontSize:CGFloat = 16.0{
        didSet{
            for button in buttons {
                button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            }
        }
    }
    open var buttonSelectedColor = UIColor.orange{
        didSet{
            underline.backgroundColor = buttonSelectedColor
            for button in buttons {
                button.tintColor = buttonSelectedColor
                button.setTitleColor(buttonSelectedColor, for: .selected)
            }
        }
    }
    open var buttonNormalColor = UIColor.gray{
        didSet{
            underlineBackgroundView.backgroundColor = buttonNormalColor.withAlphaComponent(0.2)
            for button in buttons {
                if button.tag == selectedButtonTag{
                    button.setTitleColor(buttonSelectedColor, for: .selected)
                }else{
                    button.setTitleColor(buttonNormalColor, for: .normal)
                }
            }
        }
    }
    open var underlineThickness:CGFloat = 1.5{
        didSet{
            underline.frame = CGRect(x: underline.frame.minX, y: underline.frame.minY, width: underline.frame.width, height: underlineThickness)
        }
    }
    open var underlineShouldDisplay = true{
        didSet{
            configureunderline(animationDuration: 0)
        }
    }
    open var underlineWidthBoundToText = true{
        didSet{
            configureunderline(animationDuration: 0)
        }
    }
    
    open var defaultSelectedIndex = 0 {
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
    
    open var underlineBackgroundShow = false{
        didSet{
            layoutSubviews()
        }
    }
    
    //  Gap
    @IBInspectable open var horizontalGap:CGFloat = 8.0 //左右两侧
    @IBInspectable open var verticalGap:CGFloat = 4.0   //垂直上下
    @IBInspectable open var buttonGap:CGFloat = 4.0     //按钮之间
    @IBInspectable open var buttonUnderlineGap:CGFloat = 2.0 {//按钮与下划线之间
        didSet{
            configureunderline(animationDuration: 0)
        }
    }
    
    //  Delegate
    @IBOutlet open var delegate:XYXFlatSegmentControlDelegate? = nil
    
    //MARK: - Fileprivate Member
    //  Fileprivate Member
    fileprivate let underline = UIView()
    fileprivate let underlineBackgroundView = UIView()
    fileprivate let buttonTagFlag = 1000
    fileprivate var selectedButtonTag:Int = 0
    fileprivate var buttons:[UIButton] = []
    fileprivate var buttonWidth:CGFloat = 44.0
    fileprivate var buttonHeight:CGFloat = 44.0
    
    //MARK: - Life Cycle
    
    convenience init() {
        self.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        selectedButtonTag = buttonTagFlag
        underlineBackgroundView.backgroundColor = buttonNormalColor.withAlphaComponent(0.2)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedButtonTag = buttonTagFlag
        underlineBackgroundView.backgroundColor = buttonNormalColor.withAlphaComponent(0.2)
        buttonHeight = frame.height
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        guard titles.count > 0 else {
            return
        }
        
        buttonWidth = (frame.width - 2*horizontalGap - CGFloat(titles.count-1)*buttonGap) / CGFloat(titles.count)
        buttonHeight = frame.height - 2*verticalGap
        
        buttons.removeAll()
        
        var idx = 0
        for title in titles {
            let button = createButton()
            button.frame = CGRect(x: horizontalGap + (buttonWidth+buttonGap)*CGFloat(idx), y: verticalGap, width: buttonWidth, height: buttonHeight)
            button.tag = idx + buttonTagFlag
            button.setTitle(title, for: UIControl.State.normal)
            if idx < buttonImageNames.count, let btnImg = UIImage(named: buttonImageNames[idx]){
                let imageN = btnImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                button.setImage(imageN, for: UIControl.State.normal)
                let imageS = btnImg.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                button.setImage(imageS, for: UIControl.State.selected)
            }
            addSubview(button)
            buttons.append(button)
            if button.tag == selectedButtonTag{
                button.isSelected = true
            }
            idx += 1
        }
        
        if underlineBackgroundShow && underlineShouldDisplay{ //&& underlineWidthBoundToText == false{
            let theButton = buttons[0]
            let theFrame = underlineWidthBoundToText ? (theButton.titleLabel?.frame ?? CGRect.zero) : theButton.frame
            underlineBackgroundView.frame = CGRect(x: horizontalGap, y: theFrame.maxY+self.buttonUnderlineGap, width: frame.width-2*horizontalGap, height: underlineThickness)
            addSubview(underlineBackgroundView)
        }else{
            underlineBackgroundView.removeFromSuperview()
        }
        
        configureunderline(animationDuration: 0)
    }
    
    //MARK: - Public
    public func select(at index:Int, triggerDelegate:Bool = false) {
        guard index < titles.count else {
            return
        }
        let newSelectedIdx = index + buttonTagFlag
        guard newSelectedIdx != selectedButtonTag else {
            return
        }
        selectedButtonTag = newSelectedIdx
        
        for item in buttons {
            if item.tag == newSelectedIdx{
                item.isSelected = true
            }else{
                item.isSelected = false
            }
        }
        
        let animationDuration = 0.1 + fabs(Double(index)) * 0.05
        configureunderline(animationDuration: animationDuration)
        
        if let theDelegate = self.delegate, triggerDelegate == true {
            theDelegate.segmentControlValueChanged(at: index)
        }
    }
    
    public func configureButtons(titles:[String],images:[String] = []) {
        buttonImageNames = images
        self.titles = titles
    }
    
    
    //MARK: - Fileprivate Action
    
    fileprivate func createButton() -> UIButton {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(buttonSelectedColor, for: UIControl.State.selected)
        button.setTitleColor(buttonNormalColor, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)
        button.imageView?.tintColor = buttonSelectedColor
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
        
        let idx = selectedButtonTag - buttonTagFlag
        
        var newFrame = CGRect.zero
        if underlineWidthBoundToText {
            let theTitleFrame = selectedButton.titleLabel?.frame ?? CGRect.zero
            var btnMinX = theTitleFrame.minX
            var btnMaxY = theTitleFrame.maxY
            var lineWidth = theTitleFrame.width
            
            if let _ = selectedButton.imageView?.image, let imgViewFrame = selectedButton.imageView?.frame {
                btnMinX = min(btnMinX, imgViewFrame.minX)
                btnMaxY = max(btnMaxY, imgViewFrame.maxY)
                lineWidth = theTitleFrame.width + imgViewFrame.width
            }
            var newX = btnMinX + self.horizontalGap + (CGFloat(self.buttonGap)+self.buttonWidth)*CGFloat(idx)
            if self.flat_parentController() is UINavigationController{
                newX -= 4
            }
            newFrame = CGRect(x: newX, y: btnMaxY+self.buttonUnderlineGap, width: lineWidth, height: self.underlineThickness)
            
        }else{
            let theFrame = selectedButton.frame
            newFrame = CGRect(x: theFrame.minX, y: theFrame.maxY+self.buttonUnderlineGap, width: theFrame.width, height: self.underlineThickness)
        }
        
        guard newFrame.minY > self.buttonUnderlineGap else{
            //确保underline在按钮以下位置
            self.perform(#selector(configureunderline(animationDuration:)), with: TimeInterval(0), afterDelay: 0.05)
            return
        }
        
        if animationDuration > 0 {
            UIView.animate(withDuration: animationDuration) {[weak self] in
                self?.underline.frame = newFrame
            }
        } else {
            self.underline.frame = newFrame
        }
        
        // 调整下划线的背景线位置
        if underlineBackgroundShow == true && self.underline.center.y != self.underlineBackgroundView.center.y {
            self.underlineBackgroundView.center.y = self.underline.center.y
        }
    }
    
    fileprivate func flat_parentController() -> UIViewController? {
        var nextResponder:UIResponder? = self.next
        while nextResponder != nil {
            if nextResponder is UIViewController{
                return nextResponder as? UIViewController
            }
            nextResponder = nextResponder?.next
        }
        
        return nil
    }
}
