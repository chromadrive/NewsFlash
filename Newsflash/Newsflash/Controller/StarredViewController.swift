//
//  StarredViewController.swift
//  Newsflash
//
//  Created by Zeyana Ayesha Musthafa on 11/4/17.
//  Copyright © 2017 iOSDecal. All rights reserved.
//

import UIKit

class StarredViewController: UIViewController {
    
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel = UIApplication.shared.delegate
            as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do {
            articles = try context.fetch(Article.fetchRequest())
            
        }
        catch {
            print("Fetch failed")
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
