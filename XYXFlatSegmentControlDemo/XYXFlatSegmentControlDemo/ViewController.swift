//
//  ViewController.swift
//  XYXFlatSegmentControlDemo
//
//  Created by Teresa on 2018/2/28.
//  Copyright © 2018年 Teresa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segView: XYXFlatSegmentControl!
    let segmentControl = XYXFlatSegmentControl.init(frame: CGRect(x: 0, y: 130, width: UIScreen.main.bounds.width, height: 44))
    var underlineShouldDisplay = false
    var underlineThickness:CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segView.titles = ["button0","button1","button2"]
        segView.defaultSelectedIndex = 1
        
        segmentControl.titles = ["aa","bbb"]
        segmentControl.delegate = self
        self.view.addSubview(segmentControl)

        segmentControl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
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
    
    @IBAction func underlineThicknessChanged(_ sender: UISlider) {
        underlineThickness = CGFloat(sender.value)
        segmentControl.underlineThickness = underlineThickness
        label.text = "Change the thickness of the underline:\(String(format: "%.2f", sender.value))"
    }
}

extension ViewController: XYXFlatSegmentControlDelegate {
    func segmentControlValueChanged(at index: Int) {
        print("Selected button index = \(index)")
    }
}
