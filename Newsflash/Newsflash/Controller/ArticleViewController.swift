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
import CoreData

class ArticleViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var header: UILabel!
    
    @IBOutlet var details: UILabel!
    
    @IBOutlet var location: UILabel!
    @IBOutlet var summary: UILabel!
    
    @IBOutlet var categoryButton: UIButton!

    var urievent : String?
    
    var date: String?
    var loc: String?
    var socialScore: String?
    var image: String?
    var articles: [String]?
    var keywords: [String]?
    
    @IBAction func sourceButtonPressed(sender: UIButton) {
        let title: String = (sender.titleLabel?.text)!
        let start = title.index(title.startIndex, offsetBy: 1)
        let end = title.index(title.endIndex, offsetBy: -1)
        let range = start..<end
        let mySubstring = title[range]  // play
        let index = String(mySubstring)
        let url = articles![Int(index)!]
        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
    }
    
    @IBOutlet var favButton: UIButton!
    
    @IBAction func favButton(_ sender: Any) {
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "uri == %@", urievent!)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest) as! [Article]
            if let entityToDelete = fetchedEntities.first {
                context.delete(entityToDelete)
                self.favButton.setImage(UIImage(named: "fav"), for: .normal)
            }
            else {

                let article = Article(context: context)
                article.uri = urievent
                article.title = header.text
                article.summary = summary.text
                article.location = loc
                article.date = date
                article.socialScore = socialScore
                article.image = image
                article.articles = articles as NSObject?
                article.keywords = keywords as NSObject?
                appDel.saveContext()
                self.favButton.setImage(UIImage(named: "fav_sel"), for: .normal)
            }
        } catch {
            print("deleteFav error: couldn't delete")
            // Do something in response to error condition
        }
        
        do {
            try context.save()
        } catch {
            print("deleteFav error: couldn't save")
            // Do something in response to error condition
        }
        
       
    }
    
    func saveFav(uri: String) {
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let article = Article(context: context)
        article.uri = urievent
        article.title = header.text
        article.summary = summary.text
        article.location = loc
        article.date = date
        article.socialScore = socialScore
        article.image = image
        article.articles = articles as NSObject?
        article.keywords = keywords as NSObject?
        appDel.saveContext()

    }
    
    func deleteFav(uri : String) {
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let managedContext = appDel.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "uri == %@", uri)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try managedContext.fetch(fetchRequest) as! [Article]
            if let entityToDelete = fetchedEntities.first {
                managedContext.delete(entityToDelete)
            }
        } catch {
            print("deleteFav error: couldn't delete")
            // Do something in response to error condition
        }
        
        do {
            try managedContext.save()
        } catch {
            print("deleteFav error: couldn't save")
            // Do something in response to error condition
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.loc = json["event"]["location"].stringValue
                
                summarytext = json["event"]["summary"].stringValue
                self.image = json["event"]["image"].stringValue
                let imageurl = URL(string: self.image!)
                DispatchQueue.main.async() {
                    if self.loc == "N/A" {
                        self.loc = ""
                        
                    
                        let verticalSpace = NSLayoutConstraint(item: self.details, attribute: .bottom, relatedBy: .equal, toItem: self.header, attribute: .bottom, multiplier: 1, constant: 50)
                        
                        // activate the constraints
                        NSLayoutConstraint.activate([verticalSpace])
                    }
                    self.header.text = headertext
                    self.details.text = detailstext
                    self.location.text = self.loc
                    self.summary.text = summarytext
                    self.summary.sizeToFit()
                    let screenHeight = self.view.frame.size.height + self.summary.bounds.size.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: screenHeight)
                    
                    
                    let appDel = UIApplication.shared.delegate
                        as! AppDelegate
                    let context = appDel.persistentContainer.viewContext
                    
                    let predicate = NSPredicate(format: "uri == %@", self.urievent!)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchedEntities = try context.fetch(fetchRequest) as! [Article]
                        if fetchedEntities.first != nil {
                            self.favButton.setImage(UIImage(named: "fav_sel"), for: .normal)
                        }

                    } catch {
                        print("couldn't find article")
                        // Do something in response to error condition
                    }
                    
                    
                    
                    
                    
                    
//                    var src_count : Int = 1
//                    var buttonX: CGFloat = 20  // our Starting Offset, could be 0
//                    let buttonY : Int = Int(self.summary.bounds.size.height) + 30
//                    for _ in self.articles! {
//                        let sourceButton = UIButton(frame: CGRect(x: Int(buttonX), y: buttonY, width: 30, height: 30))
//                        buttonX = buttonX + 30
//
//                        sourceButton.setTitle("[\(src_count)]", for: .normal)
//                        sourceButton.setTitleColor(.blue, for: .normal)
//                        sourceButton.addTarget(self, action: sourceButtonPressed(_:)), for: UIControlEvents.touchUpInside)
//
//                        self.view.addSubview(sourceButton)
//                        src_count += 1
//                    }
                    
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
    


//    func sourceButtonPressed(sender:UIButton!) {
//        //UIApplication.shared.openURL(NSURL(string: "http://www.google.com")! as URL)
//        let title: String = (sender.titleLabel?.text)!
//        print(title)
//        let start = title.index(title.startIndex, offsetBy: 1)
//        let end = title.index(title.endIndex, offsetBy: -1)
//        let range = start...end
//        let mySubstring = title[range]  // play
//        let index = String(mySubstring)
//        let url = articles![Int(index)!]
//        UIApplication.shared.open(NSURL(string: url)! as URL, options: [:], completionHandler: nil)
//    }

}
