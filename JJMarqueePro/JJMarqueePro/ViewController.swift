//
//  ViewController.swift
//  JJMarqueePro
//
//  Created by 123 on 2018/3/13.
//  Copyright © 2018年 Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JJMarqueeViewDelegate,JJMarqueeViewDataSource {

    let marqueeView = JJMarqueeView.init(frame: CGRect.init(x: 0, y: 100, width: 375, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        marqueeView.automaticSlidingInterval = 3
        marqueeView.delegate = self
        marqueeView.dataSource = self
        self.view.addSubview(marqueeView)
        self.readyDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readyDataSource(){
        
        marqueeView.reload()
        
    }

    /// MARK: - 跑马灯View 代理 ==========
    func numberOfItems(_ marqueeView: JJMarqueeView) -> Int {
        return 3
    }
    func marqueeView(_ marqueeView: JJMarqueeView, cellForItemAt index: Int) -> NSAttributedString {
        
        if index == 0 {
            
            let str = "【我只是说说而已】"
            let fullStr = "\(str) 提现了100.00元到支付宝" as NSString
            let r = fullStr.range(of: str)
            let att = NSMutableAttributedString.init(string: fullStr as String)
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: r)
            return att
            
        }else if index == 1{
            
            let str = "【梦想只是说说而已】"
            let fullStr = "\(str) 提现了200.00元到支付宝" as NSString
            let r = fullStr.range(of: str)
            let att = NSMutableAttributedString.init(string: fullStr as String)
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: r)
            return att
        }else{
            
            let str = "【梦想就是梦】"
            let fullStr = "\(str) 提现了900.00元到支付宝" as NSString
            let r = fullStr.range(of: str)
            let att = NSMutableAttributedString.init(string: fullStr as String)
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.purple, range: r)
            return att
        }
    }
}

