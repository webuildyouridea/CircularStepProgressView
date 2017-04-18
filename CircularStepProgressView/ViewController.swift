//
//  ViewController.swift
//  CircularStepProgressView
//
//  Created by Arpad Larrinaga on 4/17/17.
//  Copyright © 2017 muub. All rights reserved.
//

import UIKit
import PureLayout

class ViewController: UIViewController {
    
    var circleView: CircularStepProgressView!
    var timer:Timer!
    var index:Int = 1

    @IBOutlet weak var progressView: CircularStepProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.animate(toStep: 8)
        index = 8
    }
    
    @IBAction func addPoint(sender: UIButton) {
        progressView.addPoint()
        index = index + 1
        if index == 10 {
            index = 0
        }
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
