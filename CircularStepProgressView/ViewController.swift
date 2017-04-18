//
//  ViewController.swift
//  CircularStepProgressView
//
//  Created by Arpad Larrinaga on 4/17/17.
//  Copyright © 2017 muub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var circleView: CircularStepProgressView!
    var timer:Timer!
    var index:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSteps()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circleView.animate(toStep: 8)
    }

    func loadSteps() {
        circleView = CircularStepProgressView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.width)
        )
        circleView.delegate = self
        circleView.steps = 10
        circleView.backColor = UIColor.green
        circleView.fillColor = UIColor.yellow
        
        view.addSubview(circleView)
        
        //startTimer()
    }
    
    func addPoint(_ timer: Timer) {
        circleView.addPoint()
        index = index + 1
        if index == 11 {
            index = 0
            timer.invalidate()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2,
                                     target: self,
                                     selector: #selector(self.addPoint(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
}

extension ViewController: CircularStepProgressDelegate {
    func didFinishCompleteAnimation(sender: CircularStepProgressView) {
        let alertController = UIAlertController(title: "Animation finished",
                                                message: nil,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
