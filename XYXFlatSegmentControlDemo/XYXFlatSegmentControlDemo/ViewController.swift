//
//  ViewController.swift
//  XYXFlatSegmentControlDemo
//
//  Created by Teresa on 2018/2/28.
//  Copyright © 2018年 Teresa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelThickness: UILabel!
    @IBOutlet weak var labelGap: UILabel!
    @IBOutlet weak var segView: XYXFlatSegmentControl!
    @IBOutlet weak var labelSecB: UILabel!
    @IBOutlet weak var textfield: UITextField!
    let segmentControl = XYXFlatSegmentControl.init(frame: CGRect(x: 0, y: 130, width: UIScreen.main.bounds.width, height: 44))
    var underlineShouldDisplay = true
    var underlineBoundsToText = true
    
    var underlineThickness:CGFloat = 1.5
    var buttonUnderlineGap:CGFloat = 10.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        segView.titles = ["button0","button1","button2"]
        segView.defaultSelectedIndex = 1
        
        segmentControl.frame = CGRect(x: 0, y: labelSecB.frame.maxY + 24, width: segmentControl.frame.width, height: segmentControl.frame.height)
//        segmentControl.titles = ["aa","bbb"]
        segmentControl.configureButtons(titles: ["aa","bbb"], images: ["icon_a","icon_b"])
        segmentControl.delegate = self
        self.view.addSubview(segmentControl)

        segmentControl.underlineShouldDisplay = underlineShouldDisplay
        segmentControl.buttonSelectedColor = UIColor.blue
    }

    /// 手动设置被选择的按钮
    @IBAction func changeSelectedBtn(_ sender: UIButton) {
        textfield.resignFirstResponder()
        if let idx = Int(textfield.text ?? "0") {
            segmentControl.select(at: idx, triggerDelegate: true)
        }
    }
    /// 改变下划线颜色
    @IBAction func ChangeColor(_ sender: Any) {
        textfield.resignFirstResponder()
        segmentControl.buttonSelectedColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
    }
    
    /// 是否显示下划线
    @IBAction func showUnderline(_ sender: UIButton) {
        textfield.resignFirstResponder()
        underlineShouldDisplay = !underlineShouldDisplay
        if underlineShouldDisplay{
            sender.setTitle("Hide underline", for: .normal)
        }else{
            sender.setTitle("Show underline", for: .normal)
        }
        segmentControl.underlineShouldDisplay = underlineShouldDisplay
    }
    
    /// 下划线样式：全按钮或者绑定到文字图标
    @IBAction func underlineBoundsChanged(_ sender: UIButton) {
        textfield.resignFirstResponder()
        underlineBoundsToText = !underlineBoundsToText
        let title = underlineBoundsToText ? "Underline bounds to Button" : "Underline bounds to Text"
        sender.setTitle(title, for: .normal)
        
        segmentControl.underlineWidthBoundToText = underlineBoundsToText
    }
    
    /// 下划线粗细
    @IBAction func underlineThicknessChanged(_ sender: UISlider) {
        textfield.resignFirstResponder()
        underlineThickness = CGFloat(sender.value)
        segmentControl.underlineThickness = underlineThickness
        labelThickness.text = "Change the thickness of the underline:\(String(format: "%.2f", sender.value))"
    }
    
    /// 下划线距离按钮距离
    @IBAction func buttonUnderlineGapChanged(_ sender: UISlider) {
        textfield.resignFirstResponder()
        buttonUnderlineGap = CGFloat(sender.value)
        segmentControl.buttonUnderlineGap = buttonUnderlineGap
        labelGap.text = "Change the gap of button and underline:\(String(format: "%.2f", sender.value))"
    }
    
    /// 显示下划线背景
    @IBAction func showUnderlineBg(_ sender: UISwitch) {
        textfield.resignFirstResponder()
        if sender.isOn {
            segmentControl.underlineBackgroundShow = true
        }else{
            segmentControl.underlineBackgroundShow = false
        }
    }
    
}

extension ViewController: XYXFlatSegmentControlDelegate {
    func segmentControlValueChanged(at index: Int) {
        print("Selected button index = \(index)")
    }
}
