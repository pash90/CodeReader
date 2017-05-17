//
//  CustomTabBarController.swift
//  Code Reader
//
//  Created by Parth on 17/5/17.
//  Copyright © 2017 Parth. All rights reserved.
//

import UIKit
import AVFoundation

class CustomTabBarController: UITabBarController, CustomTabBarDelegate {

    //MARK: - Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
        customTabBar.delegate = self
        customTabBar.setupTabBar()
        self.view.addSubview(customTabBar)
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
    
    //MARK: - CustomTabBarDelegate
    func customTabBar(customTabBar: CustomTabBar, didSelectItemAt index: Int) {
        if index != self.selectedIndex {
            self.selectedIndex = index
        }
    }
    
    func startScanningForNewCode() {
        let codeScannerViewController = CodeScannerViewController()
        self.present(codeScannerViewController, animated: true, completion: nil)
    }

}
