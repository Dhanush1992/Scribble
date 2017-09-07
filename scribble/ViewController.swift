//
//  ViewController.swift
//  scribble
//
//  Created by Dhanush Thotadur Divakara on 9/5/17.
//  Copyright © 2017 Dhanush Thotadur Divakara. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    // The imageView used as a canvas to draw
    @IBOutlet weak var canvasImageView: UIImageView!
    // A button to toggle between erase/draw functionalty
    @IBOutlet weak var drawToolAction: UIButton!
    
    // Last point on the canvas used to store the location of the touch. Initialized to zero.
    var lastPoint = CGPoint.zero
    var swiped = false
    
    // properties to hold stroke color, size of brush and opacity respectively
    var color:UIColor = UIColor.black
    var brushSize:CGFloat = 5.0
    var opacityValue:CGFloat = 1.0
    
    // Indicates the current drawing tool. Drawing pencil or Eraser
    var drawTool:UIImageView!
    // Boolean to indiacte the state of drawing
    var isDrawing = true
    
    
    
    
    /**
     drawLines takes the start and end positions and draws a line on the canvas.
     Drawing is done using available methods of graphics image context and setting it to the canvas image.
     - parameters:
        - fromPoint: Starting position from where the drawing will begin
        - toPoint: Ending position of the drawing
     */
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        canvasImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        drawTool.center = CGPoint(x: toPoint.x + drawTool.frame.width/2, y: toPoint.y - drawTool.frame.height/2)
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(color.cgColor)
        context?.strokePath()
        
        canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // Overriding the touches Began,moved and ended methods to get the initial touch location point and draw the line from last known point to current point.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first{
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    /**
     resetCanvas is an action method invoked when reset button is pressed.
     The canvas is reset and default settings are restored.
     - parameters:
        - sender: The reset button that invokes the method on press
     */
    @IBAction func resetCanvas(_ sender: Any) {
        self.canvasImageView.image = nil
        drawTool.image = #imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50")
        drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Erase Filled_50"), for: .normal)
        color  = UIColor.black
        isDrawing = !isDrawing
    
        
    }
    /**
     erase is an action method invoked when erase button is pressed.
     The drawTool toggles between erase tool and the pencil based on the state of the drawing.
     - parameters:
        - sender: The erase button that invokes the method on press
     */
    @IBAction func erase(_ sender: Any) {
        if (isDrawing) {
            color = UIColor.white
            drawTool.image = #imageLiteral(resourceName: "icons8-Erase Filled_50")
            //drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Erase Filled_50"), for: .normal)
            drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50"), for: .normal)
        } else {
            color = UIColor.black
            drawTool.image = #imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50")
            //drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50"), for: .normal)
            drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Erase Filled_50"), for: .normal)
        }
        
        isDrawing = !isDrawing
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        drawTool = UIImageView()
        drawTool.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 38, height: 38)
        drawTool.image = #imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50")
        
        self.view.addSubview(drawTool)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        super.prepare(for: segue, sender: sender)
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.color = color
        settingsViewController.brushSize = brushSize
        settingsViewController.opacityValue = opacityValue
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:SettingsViewControllerDelegate {
    
    /**
    Delegate method of settingsViewController that is invoked on finish.
    The canvas settings are set using this delegate.
    - parameters:
        - settingsViewController: The view controller object which has the properties required to set the canvas settings
     */
    func settingsViewControllerDidFinish(_ settingsViewController:SettingsViewController) {
        self.color = settingsViewController.color
        self.brushSize = settingsViewController.brushSize
        self.opacityValue = settingsViewController.opacityValue
        if(settingsViewController.color != UIColor.white){
            drawTool.image = #imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50")
            //drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Pencil Drawing Filled_50"), for: .normal)
            drawToolAction.setImage(#imageLiteral(resourceName: "icons8-Erase Filled_50"), for: .normal)
        }
        print("values changed")
        
    }
    
}

