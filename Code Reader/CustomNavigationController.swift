//
//  CustomNavigationController.swift
//  Code Reader
//
//  Created by Parth on 17/5/17.
//  Copyright © 2017 Parth. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.isHidden = true
        setupNavigationBar(titleText: "History")
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
    
    //MARK: - Custom Navigation Bar
    func setupNavigationBar(titleText: String) {
        let customNavigationBar = UIView(frame: CGRect(x: 0, y: 0, width: self.navigationBar.frame.width, height: 80))
        customNavigationBar.backgroundColor = BACKGROUND_COLOR
        
        // add a border
        let bottomBorder = UIView(frame: CGRect(x: 0, y: 79, width: customNavigationBar.frame.width, height: 1))
        bottomBorder.backgroundColor = TINT_COLOR
        customNavigationBar.addSubview(bottomBorder)
        
        // add title
        let title = UILabel(frame: CGRect(x: 16, y: 35, width: customNavigationBar.frame.width, height: 29))
        title.text = titleText
        title.textColor = TINT_COLOR
        title.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightBold)
        
        customNavigationBar.addSubview(title)
        
        self.view.addSubview(customNavigationBar)
    }
}
