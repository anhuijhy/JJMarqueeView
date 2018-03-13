
//
//  JJMarqueeView.swift
//  LaiZhuanPro
//
//  Created by 123 on 2018/3/13.
//  Copyright © 2018年 Jason. All rights reserved.
//

@objc
protocol JJMarqueeViewDelegate:NSObjectProtocol {

    /// MARK: - 选中某一条
    @objc optional func mqrqueeView(_ marqueeView:JJMarqueeView,didSelectCellAt index:Int) -> Void
}


protocol JJMarqueeViewDataSource:NSObjectProtocol {
    
    /// MARK: - 多少条数据
    func numberOfItems(_ marqueeView:JJMarqueeView) -> Int
    /// MARK: - 每条的attributedString
    func marqueeView(_ marqueeView:JJMarqueeView, cellForItemAt index:Int) -> NSAttributedString
}


import UIKit

class JJMarqueeView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    /// MARK: - 当前idx
    var curtIdx:Int = 0
    
    weak var delegate:JJMarqueeViewDelegate?
    
    weak var dataSource:JJMarqueeViewDataSource?
    
    
    /// MARK: - 第一个Lab
    let marqueeOneLab = UILabel()
    /// MARK: - 第二个Lab
    let marqueeTwoLab = UILabel()
    /// MARK: - 时钟
    var timer: Timer?
    
    var automaticSlidingInterval: CGFloat = 0.0 {
        
        didSet{
            
            print("时钟是\(self.automaticSlidingInterval)")
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpUI() -> Void {
        
        marqueeOneLab.font = UIFont.systemFont(ofSize: 13)
        marqueeTwoLab.font = UIFont.systemFont(ofSize: 13)
        marqueeOneLab.textColor = UIColor.red
        marqueeTwoLab.textColor = UIColor.red

        self.addSubview(marqueeOneLab)
        self.addSubview(marqueeTwoLab)
        marqueeOneLab.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        marqueeTwoLab.frame = CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)

        let tapAction:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.addGestureRecognizer(tapAction)
    }
    
    @objc func tapAction(_ tap:UITapGestureRecognizer){
        
        if let _ = delegate {
            
            delegate!.mqrqueeView!(self, didSelectCellAt: curtIdx)
        }
    }
}

extension JJMarqueeView{
    
    func cancelTimer() -> Void {
        
        guard self.timer != nil else {
            
            return
        }
        
        self.timer!.invalidate()
        self.timer = nil
    }
    
    func startTimer(){
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.automaticSlidingInterval), target: self, selector: #selector(self.flipNext(_:)), userInfo: nil, repeats: true)
    }
    
    func reload() -> Void {
        
        guard let _ = delegate , let _ = dataSource else {
            
            print("代理delegate或则数据源dataSource没有设置")
          
            return
        }
        
        let numOfItems = dataSource!.numberOfItems(self)
        guard numOfItems > 0 else {
            
            print("没有需要显示的marqueeView")
            return
        }
        print("deleate and datasource set ok")
        
        self.cancelTimer()
        self.initStatusMarquee(0)
    }
    
    /// MARK: - 先初始化第一次显示，然后等待时钟fire
    func initStatusMarquee(_ startInx:Int) -> Void {
        
        let counts = dataSource!.numberOfItems(self)
        marqueeOneLab.attributedText = dataSource!.marqueeView(self, cellForItemAt: startInx)
        guard counts > startInx + 1  else {
            return
        }
        //数目大于一个可以循环
        curtIdx = startInx + 1
        marqueeTwoLab.attributedText = dataSource!.marqueeView(self, cellForItemAt: startInx + 1)
        self.startTimer()
    }
    
    
    @objc func flipNext(_ sender:Timer){
        
        UIView.animate(withDuration: 0.75, animations: {
            
            let oneOriY = self.marqueeOneLab.frame.origin.y
            let twoOriY = self.marqueeTwoLab.frame.origin.y
            if oneOriY > twoOriY{

                var rectOne:CGRect = self.marqueeTwoLab.frame
                rectOne.origin.y = -rectOne.size.height
                self.marqueeTwoLab.frame = rectOne
                
                var rectTwo:CGRect = self.marqueeOneLab.frame
                rectTwo.origin.y = 0
                self.marqueeOneLab.frame = rectTwo
            }else{
                var rectOne:CGRect = self.marqueeOneLab.frame
                rectOne.origin.y = -rectOne.size.height
                self.marqueeOneLab.frame = rectOne
                
                var rectTwo:CGRect = self.marqueeTwoLab.frame
                rectTwo.origin.y = 0
                self.marqueeTwoLab.frame = rectTwo
            }
            
        }) { (true) in
            
            let oneOriY = self.marqueeOneLab.frame.origin.y
            let twoOriY = self.marqueeTwoLab.frame.origin.y
            let l :UILabel?
            if oneOriY < twoOriY{
                
                l = self.marqueeOneLab

            }else{
                
                l = self.marqueeTwoLab
            }
            
            var rectOne:CGRect = l!.frame
            rectOne.origin.y = rectOne.size.height
            l!.frame = rectOne
            
            if (self.curtIdx + 1 < self.dataSource!.numberOfItems(self)){
                
                l!.attributedText = self.dataSource?.marqueeView(self, cellForItemAt: self.curtIdx + 1)
                
                self.curtIdx = self.curtIdx + 1
                
            }else if (self.curtIdx + 1 == self.dataSource!.numberOfItems(self)){
                
                l!.attributedText = self.dataSource?.marqueeView(self, cellForItemAt: 0)
                self.curtIdx = 0
                
            }else{}

          //==end==
        }
        
    }
    
}



