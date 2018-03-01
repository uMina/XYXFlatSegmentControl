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
    let segmentControl = XYXFlatSegmentControl.init(frame: CGRect(x: 0, y: 130, width: UIScreen.main.bounds.width, height: 44))
    var underlineShouldDisplay = true
    var underlineBoundsToText = true
    
    var underlineThickness:CGFloat = 1.5
    var buttonUnderlineGap:CGFloat = 10.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segView.titles = ["button0","button1","button2"]
        segView.defaultSelectedIndex = 1
        
        segmentControl.titles = ["aa","bbb"]
        segmentControl.delegate = self
        self.view.addSubview(segmentControl)

        segmentControl.underlineShouldDisplay = underlineShouldDisplay
        segmentControl.buttonSelectedColor = UIColor.blue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeColor(_ sender: Any) {
        segmentControl.buttonSelectedColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
    }
    
    @IBAction func showUnderline(_ sender: UIButton) {
        underlineShouldDisplay = !underlineShouldDisplay
        if underlineShouldDisplay{
            sender.setTitle("Hide underline", for: .normal)
        }else{
            sender.setTitle("Show underline", for: .normal)
        }
        segmentControl.underlineShouldDisplay = underlineShouldDisplay
    }
    
    @IBAction func underlineBoundsChanged(_ sender: UIButton) {
        underlineBoundsToText = !underlineBoundsToText
        let title = underlineBoundsToText ? "Underline bounds to Button" : "Underline bounds to Text"
        sender.setTitle(title, for: .normal)
        segmentControl.underlineWidthBoundToText = underlineBoundsToText
    }
    
    @IBAction func underlineThicknessChanged(_ sender: UISlider) {
        underlineThickness = CGFloat(sender.value)
        segmentControl.underlineThickness = underlineThickness
        labelThickness.text = "Change the thickness of the underline:\(String(format: "%.2f", sender.value))"
    }
    
    @IBAction func buttonUnderlineGapChanged(_ sender: UISlider) {
        buttonUnderlineGap = CGFloat(sender.value)
        segmentControl.buttonUnderlineGap = buttonUnderlineGap
        labelGap.text = "Change the gap of button and underline:\(String(format: "%.2f", sender.value))"
    }
    
    @IBAction func showUnderlineBg(_ sender: UISwitch) {
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
