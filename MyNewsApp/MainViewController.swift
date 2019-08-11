//
//  MainViewController.swift
//  MyNewsApp
//
//  Created by VERTEX24 on 2019/08/11.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import XLPagerTabStrip   // ダウンロードしたやつ
                          // 変更する
class MainViewController: ButtonBarPagerTabStripViewController {
    
    // URLの配列(yahoo,NHK,週刊文春)
    let urlList: [String] = ["https://news.yahoo.co.jp/pickup/domestic/rss.xml",
                             "https://www.nhk.or.jp/rss/news/cat0.xml",
                             "http://shukan.bunshun.jp/list/feed/rss"]

    // タブの名前の配列
    var itemInfo: [IndicatorInfo] = ["Yahoo!", "NHK", "週間文春"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // 管理されるViewContorollerを返す処理
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // 返すviewcontorollerの配列を作成
        var childViewControllers: [UIViewController] = []
        
        // それぞれのVCに異なるURLとitemInfoを入れる
        for i in 0..<urlList.count {
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News") as! NewsViewController
            
            // urlListにあるURLを一つづつVCのurlに入れていく
            VC.url = urlList[i]
            VC.itemInfo = itemInfo[i]
            childViewControllers.append(VC)
        }
        // VCおを返す
        return childViewControllers
    }
    
    
    
    

}

