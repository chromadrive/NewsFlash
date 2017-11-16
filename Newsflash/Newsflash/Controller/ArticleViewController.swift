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

class ArticleViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var header: UILabel!
    
    @IBOutlet var details: UILabel!
    
    @IBOutlet var summary: UILabel!
    
    var urievent : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url : String
        if let urievent = urievent {
            url = "http://news-server-198.herokuapp.com/uri&event=" + urievent
        } else {
            url = "http://news-server-198.herokuapp.com/uri&event=eng-"
        }
        
        let urlString = URL(string: url)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error in url session")
                } else {
                    if let usableData = data {
                        let json = JSON(data: usableData)
                        
                    }
                    
                    
                         //JSONSerialization
//                        if let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! [String: AnyObject] {
//                            let dict = json[self.urievent!]
//                            print(dict!["date"] as! String!)
                        
                    
                        
                }
            }
            
            task.resume()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
