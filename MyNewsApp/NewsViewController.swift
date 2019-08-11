//
//  NewsViewController.swift
//  MyNewsApp
//
//  Created by VERTEX24 on 2019/08/11.
//  Copyright © 2019 VERTEX24. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class NewsViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, XMLParserDelegate {
    
    
    // テーブルビューのインスタンスを取得
    var tableView: UITableView = UITableView()                // コードで書くときのみやる
    // XMLParserDelegateとのインスタンスを取得
    var parser = XMLParser()
    
    // 記事情報の配列の入れ物
    var articles: [Any] = []
    
    // webView
    @IBOutlet weak var webView: WKWebView!
    // toolBar(4つのボタン)
    @IBOutlet weak var toolBar: UIToolbar!
    
    // URLを受け取る
    var url: String = ""
    // itemInfoを受け取る
    var itemInfo: IndicatorInfo = ""
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegateと接続
        tableView.delegate = self                // これはviewにtableViewを貼ったときは必要
        // dataSourceと接続
        tableView.dataSource = self              // これはviewにtableViewを貼ったときは必要
        // navigationDelegateとの接続
        webView.navigationDelegate = self
        // ParserDelegateと接続
        parser.delegate = self
        
        
        
        // tableViewの位置を固定する
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50)
        // tableViewをviewに入れ込む(忘れがちだけど重要)
        self.view.addSubview(tableView)            // これはviewにtableViewを貼ったときは必要
        
        
        
        
        // 最初は隠す(tableViewが表示されるのを邪魔してしまうから)
        webView.isHidden = true
        toolBar.isHidden = true
        
    }
    
    
    
    
    
    // URLを解析する
    func parseUrl() {
        // URLをString型からURL型に変更する
        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        // 前の記事が残る可能性がある
        articles = []
        // 解析の実行
        parser.parse()
        // tableViewのデータをリロード
        tableView.reloadData()
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 記事の数だけセルの設定
        return articles.count
    }
    
    // セルの設定
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier:  "Cell")
        // セルの色
        cell.backgroundColor = #colorLiteral(red: 0.7605839944, green: 1, blue: 0.7711436476, alpha: 1)
        // テキストのサイズちとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = UIColor.black
        
        // 記事URLのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // ページの読み込み完了時に呼ばれる
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // tableViewを隠す
        tableView.isHidden = true
        
        // toolBarとwebViewを表示
        toolBar.isHidden = false
        webView.isHidden = false
    }
    
    
    // キャンセルボタンが押されたときの処理
    @IBAction func cancel(_ sender: Any) {
        // tableViewを表示
        tableView.isHidden = false
        
        // toolBarとwebViewを隠す
        toolBar.isHidden = true
        webView.isHidden = true
    }
    
     // backボタンが押されたときの処理
    @IBAction func backPage(_ sender: Any) {
        webView.goBack()
    }
    
     // nextボタンが押されたときの処理
    @IBAction func nextPage(_ sender: Any) {
        webView.goForward()
    }
    
     // refreshボタンが押されたときの処理
    @IBAction func refresh(_ sender: Any) {
        webView.reload()
    }
    
    
    
    // プロトコルの要求を満たすやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
}
