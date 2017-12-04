//
//  ArticleViewController.swift
//  Newsflash
//
//  Created by Zeyana Ayesha Musthafa on 11/4/17.
//  Copyright © 2017 iOSDecal. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import ParallaxHeader

class ArticleViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var header: UILabel!
    
    @IBOutlet var details: UILabel!
    
    @IBOutlet var summary: UILabel!
    
    @IBOutlet var sourcesView: UIView!
    var urievent : String?
    
    var date: String?
    var location: String?
    var socialScore: String?
    var image: String?
    var articles: [String]?
    var keywords: [String]?
    
    
    @IBAction func favButton(_ sender: Any) {
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let article = Article(context: context)
        article.uri = urievent
        article.title = header.text
        article.summary = summary.text
        article.location = location
        article.date = date
        article.socialScore = socialScore
        article.image = image
        article.articles = articles as NSObject?
        article.keywords = keywords as NSObject?
        appDel.saveContext()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.delegate = self
        //tableView.dataSource = self
        imageView.contentMode = .scaleAspectFill
        scrollView.parallaxHeader.view = imageView
        scrollView.parallaxHeader.height = 400
        scrollView.parallaxHeader.minimumHeight = 0
        scrollView.parallaxHeader.mode = .topFill
        
        var link : String
        var headertext : String?
        var summarytext : String?
        if let urievent = urievent {
            link = "http://news-server-198.herokuapp.com/V2/event&uri=" + urievent
        } else {
            link = "http://news-server-198.herokuapp.com/V2/event&uri=eng-"
        }
        link = "http://news-server-198.herokuapp.com/V2/event&uri=eng-3493252"
        let url = URL(string: link)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let usableData = data else { return }
            do {
                var detailstext: String = ""
                
                let json = JSON(data: usableData)
                headertext = json["event"]["title"].stringValue
                self.date = json["event"]["date"].stringValue
                self.socialScore = json["event"]["socialScore"].stringValue
                self.articles =  json["event"]["articles"].arrayValue.map({$0.stringValue})
                self.keywords =  json["event"]["keywords"].arrayValue.map({$0.stringValue})
                
                if let datetext = self.date {
                    let format :String = "EEEE, MMM d yyyy"
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = format
                    
                    let Date: NSDate? = dateFormatterGet.date(from: datetext) as NSDate?
                    detailstext = dateFormatterPrint.string(from: Date! as Date)
                }
                self.location = json["event"]["location"].stringValue
                if self.location != "N/A" {
                    detailstext += ", " + self.location!
                }
                summarytext = json["event"]["summary"].stringValue
                self.image = json["event"]["image"].stringValue
                let imageurl = URL(string: self.image!)
                DispatchQueue.main.async() {
                    self.header.text = headertext
                    self.details.text = detailstext
                    self.summary.text = summarytext
                    self.summary.sizeToFit()
                    let screenHeight = self.view.frame.size.height + self.summary.bounds.size.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: screenHeight)
                    
                    var src_count : Int = 1
                    var buttonX: CGFloat = 20  // our Starting Offset, could be 0
                    let buttonY : Int = Int(self.summary.bounds.size.height) + 30
                    for _ in self.articles! {
                        let sourceButton = UIButton(frame: CGRect(x: Int(buttonX), y: buttonY, width: 30, height: 30))
                        buttonX = buttonX + 30
                        
                        sourceButton.setTitle("[\(src_count)]", for: .normal)
                        sourceButton.setTitleColor(.blue, for: .normal)
                        sourceButton.addTarget(self, action: Selector(("sourceButtonPressed:")), for: UIControlEvents.touchUpInside)
                        
                        self.view.addSubview(sourceButton)
                        src_count += 1
                    }
                    
                }
                
                DispatchQueue.global().async {
                    let imagedata = try? Data(contentsOf: imageurl!)
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imagedata!)
                    }
                }
            } 
        }

        task.resume()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func sourceButtonPressed(sender:UIButton!) {
        //UIApplication.shared.openURL(NSURL(string: "http://www.google.com")! as URL)
        let title: String = (sender.titleLabel?.text)!
        print(title)
        let start = title.index(title.startIndex, offsetBy: 1)
        let end = title.index(title.endIndex, offsetBy: -1)
        let range = start...end
        let mySubstring = title[range]  // play
        let index = String(mySubstring)
        let url = articles![Int(index)!]
        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
    }

}
