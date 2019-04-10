//
//  ViewControllerTwo.swift
//  ShapedButtonDemo
//
//  Created by 江涛 on 2019/4/10.
//  Copyright © 2019 江涛. All rights reserved.
//

import UIKit

class ViewControllerTwo: UIViewController {

    private let BTN_TAG = 1001
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorArr = [UIColor(red: 231/255, green: 15/255, blue: 0, alpha: 1),
                        UIColor(red: 237/255, green: 218/255, blue: 0, alpha: 1),
                        UIColor(red: 248/255, green: 160/255, blue: 0, alpha: 1),
                        UIColor(red: 103/255, green: 226/255, blue: 103/255, alpha: 1),
                        UIColor(red: 67/255, green: 196/255, blue: 242/255, alpha: 1)]
        
        let typeArr: [BtnType] = [.leftUp, .rightUp, .leftDown, .rightDown, .center]
        
        for index in 0..<colorArr.count {
            let color = colorArr[index]
            let type = typeArr[index]
            
            let btn = IrregularButton(frame: CGRect(x: 80, y: 100, width: 200, height: 200))
            
            btn.path(type: type)
                .backgroundColor(color: color)
                .text(text: "功能\(index+1)")
                .addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            btn.tag = BTN_TAG + index
            
            self.view.addSubview(btn)
        }
    }
    
    @objc func btnClick(_ sender: UIButton) {
        var str: String
        switch sender.tag {
        case 1001:
            str = "LeftUp Button"
        case 1002:
            str = "RightUp Button"
        case 1003:
            str = "LeftDown Button"
        case 1004:
            str = "RightDown Button"
        default:
            str = "Center Button"
        }
        
        print("current click event is \(str)")
    }
    

}
