//
//  SettingsViewController.swift
//  scribble
//
//  Created by Dhanush Thotadur Divakara on 9/6/17.
//  Copyright © 2017 Dhanush Thotadur Divakara. All rights reserved.
//

import UIKit
import ChromaColorPicker


protocol SettingsViewControllerDelegate:class {
    func settingsViewControllerDidFinish(_ settingsViewController:SettingsViewController)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var neatColorPicker: ChromaColorPicker!
    
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var brushView: UIImageView!
    
    var color:UIColor = UIColor.black
    var brushSize:CGFloat = 5.0
    var opacityValue:CGFloat = 1.0
    
    var delegate:SettingsViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ColorPicker object used to set the color. Has methods to read and set the color
        neatColorPicker.delegate = self as? ChromaColorPickerDelegate //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.black
        neatColorPicker.adjustToColor(color)
        
        drawPreview(color: color)
        
        
        // Do any additional setup after loading the view.
    }
    
    /**
     colorChanged is an action method invoked when the value of colorPicker is changed
     - parameters:
        - sender: The colorPicker object that invokes this method on change
     */
    @IBAction func colorChanged(_ sender: Any) {
        
        color = neatColorPicker.currentColor
        drawPreview(color: neatColorPicker.currentColor)
    }
    
    /**
     brushSizeChanged is an action method invoked when the value of brushSizeSlider is changed
     - parameters:
        - sender: The brushSizeSlider object that invokes this method on change
     */
    @IBAction func brushSizeChanged(_ sender: Any) {
        
        brushSize = CGFloat(brushSizeSlider.value * 50)
        drawPreview(color: neatColorPicker.currentColor)
    }
    
    /**
     opacityChanged is an action method invoked when the value of opacitySlider is changed
     - parameters:
        - sender: The opacityslider object that invokes this method on change
     */
    @IBAction func opacityChanged(_ sender: Any) {
        
        opacityValue = CGFloat(opacitySlider.value)
        drawPreview(color: neatColorPicker.currentColor)
    
    }
    
    /**
     settingsSelected is an action method invoked when Done button is pressed.
     This method invokes the delegate method of settingsVewController if set
     - parameters:
        - sender: The UIButton object that invokes this method on press
     */
    @IBAction func settingsSelected(_ sender: Any) {
        if delegate != nil {
            delegate?.settingsViewControllerDidFinish(self)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    /**
     drawPreview is a method to draw the preview of the brush settings.
     brushSize and opacity values are used to render a circle which indicates brushSize and opacity.
     - parameters:
        - color: The current color of the colorPicker
     */
    func drawPreview (color:UIColor) {
        UIGraphicsBeginImageContext(brushView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.withAlphaComponent(opacityValue).cgColor)
        context!.fillEllipse(in: CGRect(x: 0, y: 0, width: brushSize, height: brushSize))
        
        brushView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
