//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Noemi Cuin on 10/13/16.
//  Copyright © 2016 Noemi Cuin. All rights reserved.
//


import UIKit

class HappinessViewController: UIViewController {

    //level of happiness
    var happiness: Int = 50{ //0=very sad, 100=very ecstatic}
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private struct Constants {
        static let happinessGestureScale: CGFloat = 4
    }
    
    private func updateUI()
    {
        faceView.setNeedsDisplay()
    }
    
    // Outlet to faceView
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            //makes faceView dataSource for viewcontroller class when outlet is set
            faceView.dataSource = self
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.scale(_:))))
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.happinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:
            break
        }
    }
    
}
