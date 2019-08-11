//
//  NewsViewController.swift
//  MyNewsApp
//
//  Created by VERTEX24 on 2019/08/11.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsViewController: UIViewController, IndicatorInfoProvider {
    
    // URLを受け取る
    var url: String = ""
    // itemInfoを受け取る
    var itemInfo: IndicatorInfo = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // idicatorInfoの定義
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
       
        return itemInfo
    }
    
    
    
}
