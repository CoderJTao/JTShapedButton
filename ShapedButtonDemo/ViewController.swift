//
//  ViewController.swift
//  ShapedButtonDemo
//
//  Created by 江涛 on 2019/4/8.
//  Copyright © 2019 江涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func normalBtnClick(_ sender: Any) {
        print("current click event is \(#function)")
    }
    
    @IBAction func shapedBtnClick(_ sender: Any) {
        print("current click event is \(#function)")
    }
    
    @IBAction func leftUpClick(_ sender: Any) {
        print("current click event is \(#function)")
    }
    
    @IBAction func rightUpClick(_ sender: Any) {
        print("current click event is \(#function)")
    }
    
    @IBAction func centerClick(_ sender: Any) {
        print("current click event is \(#function)")
    }
    
    @IBAction func leftDownClick(_ sender: Any) {
        print("current click event is \(#function)")
    }
    
    @IBAction func rightDownClick(_ sender: Any) {
        print("current click event is \(#function)")
    }

}

