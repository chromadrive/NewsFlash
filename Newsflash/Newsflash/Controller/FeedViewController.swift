//
//  FeedViewController.swift
//  Newsflash
//
//  Created by Zeyana Ayesha Musthafa on 11/4/17.
//  Copyright © 2017 iOSDecal. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    var seluri : String?

    @IBAction func uributton(_ sender: UIButton) {
        articleSel(uri: "eng-3487526")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func articleSel(uri : String) {
        seluri = uri
        performSegue(withIdentifier: "toArticle", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticle" {
            if let destination = segue.destination as? ArticleViewController {
                destination.urievent = seluri
            }
        }
    }

}
