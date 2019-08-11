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
import SDWebImage

class NewsViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, XMLParserDelegate {
    
    // 引っ張って更新
    var refreshControl: UIRefreshControl!
    
    // テーブルビューのインスタンスを取得
    var tableView: UITableView = UITableView()                // コードで書くときのみやる
    // XMLParserDelegateとのインスタンスを取得
    var parser = XMLParser()
    
    // 記事情報の配列の入れ物
    var articles: [Any] = []
    
    var urlArray = [String]()
    
    // XMLファイルに解析をかけた情報
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element: String = ""
    // XMLファイルのタイトル情報
    var titleString: String = ""
    // XMLファイルのリンク情報
    var linkString: String = ""
    
    var urlString: String = ""
    
    let imageView = UIImage()
    
    
    
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
        // refreshControlのインスタンス
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
        // tableViewの位置を固定する
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // tableViewをviewに入れ込む(忘れがちだけど重要)
        self.view.addSubview(tableView)            // これはviewにtableViewを貼ったときは必要
        
        
        // refreshを行う
        tableView.addSubview(refreshControl)
        
        // 最初は隠す(tableViewが表示されるのを邪魔してしまうから)
        webView.isHidden = true
        toolBar.isHidden = true
        
        parseUrl()
    }
    
    // refreshs処理
    @objc func refresh() {
        // 2秒後にdelayを呼ぶ
        perform(#selector(delay), with: nil, afterDelay: 2.0)
    }
    
    // parseUrlをrefreshする
    @objc func delay() {
        parseUrl()
        refreshControl.endRefreshing()
    }
    
    
    // URLを解析する
    func parseUrl() {
        // URLをString型からURL型に変更する
        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        // 前の記事が残る可能性がある
        articles = []
        // ParserDelegateと接続
        parser.delegate = self
        // 解析の実行
        parser.parse()
        // tableViewのデータをリロード
        tableView.reloadData()
    }
    
    // タグを見つけたときの処理
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // elementNameにタグの名前が入ってくるのでelementに代入
        element = elementName
        // elementにitemが入ったとき
        if element == "item" {
            // 初期化
            elements = [:]
            titleString = ""
            linkString = ""
            
        }
        if element == "enclosure" {
            urlString = attributeDict["url"]!
            urlArray.append(urlString)
    
        }
    }
    
    // 開始タグと終了タグでくくられたデータがあったときの処理
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title" {
            titleString.append(string)
        }else if element == "link" {
            linkString.append(string)
        }
        
    }
    
    // 終了タグを見つけたとき
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
         // アイテムという要素の中にあるなら
        if elementName == "item" {
            
           // titleString,linkStringの中身が空でないなら
            if titleString != "" {
                // elementsに"title"、"Link"というキー値を付与しながらtitleString,linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            if urlString != "" {
                elements.setObject(urlString, forKey: "url" as NSCopying)
            }
            // articlesの中にelementsを入れる
            articles.append(elements)
        }
       
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
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.textColor = UIColor.black
        
        // 記事URLのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.textColor = UIColor.gray
        
        
        // セルに画像をセット
        if let stringURL = (articles[indexPath.row] as AnyObject).value(forKey: "url") as? String  {
            cell.imageView?.image = getImageByURL(url: stringURL)
        }
         /*
            if let url: URL = URL(string: stringURL) {
                cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeImage.png"))
            }
          let url:URL = URL(string: stringURL)!
 */
        
        return cell
    }
    
    // セルをタップした場合の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linkUrl = ((articles[indexPath.row] as AnyObject).value(forKey: "link") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let urlStr = (linkUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        webView.load(urlRequest as URLRequest)
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
    @IBAction func refreshPage(_ sender: Any) {
        webView.reload()
    }
    
    
    func getImageByURL(url: String) -> UIImage? {
        // リサイズされた画像
        var resizedImage: UIImage!
        // URL型でurlを取得
        guard let url: URL = URL(string: url) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            // urlから画像を取得
            if let image = UIImage(data: data) {
                // 画像をリサイズ
                resizedImage = resize(image: image, width: 75)
            }
            return resizedImage
        } catch let err {
            print("Error: \(err.localizedDescription)")
        }
        return nil
    }
    
    // 画像のサイズを変更する関数
    func resize(image: UIImage, width: Double) -> UIImage {
        // オリジナル画像のサイズからアスペクト比を計算
        let aspectScale = image.size.height / image.size.width
        // widthからアスペクト比を元にリサイズ後のサイズを取得
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // プロトコルの要求を満たすやつ
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    
}
