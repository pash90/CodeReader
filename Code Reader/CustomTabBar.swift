//
//  CustomTabBar.swift
//  Code Reader
//
//  Created by Parth on 17/5/17.
//  Copyright © 2017 Parth. All rights reserved.
//

import UIKit

protocol CustomTabBarDelegate {
    func customTabBar(customTabBar: CustomTabBar, didSelectItemAt index: Int)
    func startScanningForNewCode()
}

class CustomTabBar: UIView {
    
    //MARK: - Properties
    var tabWidth: CGFloat = 0
    var currentTabIndex = 0
    var tabButtons = [UIButton]()
    var delegate: CustomTabBarDelegate!
    
    //MARK: - Required initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Appearance
    func setupTabBar() {
        // additional setup
        tabWidth = (self.frame.width - 64) / 2
        tabButtons = []
        
        // Background color
        self.backgroundColor = BACKGROUND_COLOR
        
        // Top Border
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1))
        topBorder.backgroundColor = TINT_COLOR
        self.addSubview(topBorder)
        
        // Camera Action Button
        addCameraButton()
        
        // Add the tabs
        addTabs()
    }
    
    func addCameraButton() {
        // Get the X & Y co-ordinates
        let X = (self.frame.width - 64)/2
        let Y = -1 * abs((ACTION_BUTTON_RADIUS * 2) - self.frame.height)
        
        // Define the camera button
        let cameraButton = UIButton(frame: CGRect(x: X, y: Y, width: ACTION_BUTTON_RADIUS * 2, height: ACTION_BUTTON_RADIUS * 2))
        cameraButton.backgroundColor = TINT_COLOR
        cameraButton.layer.cornerRadius = ACTION_BUTTON_RADIUS
        
        // Define the image
        let cameraImage = UIImage(named: "camera")
        cameraButton.setImage(cameraImage!, for: .normal)
        cameraButton.setImage(cameraImage!, for: .focused)
        
        // Add Target
        cameraButton.addTarget(self, action: #selector(performNewScan), for: .touchUpInside)
        
        // Add the camera button to tab bar
        self.addSubview(cameraButton)
    }
    
    func addTabs() {
        
        // History Tab
        let historyTab = UIView(frame: CGRect(x: 0, y: 0, width: tabWidth, height: self.frame.height))
        
        let historyButton = getTabButton()
        historyButton.setImage(getImage(name: "history"), for: .normal)
        historyButton.tintColor = currentTabIndex == 0 ? TINT_COLOR : DEFAULT_COLOR
        tabButtons.append(historyButton)
        
        historyTab.addSubview(historyButton)
        
        // Pass Tab
        let passTab = UIView(frame: CGRect(x: tabWidth + 64, y: 0, width: tabWidth, height: self.frame.height))
        
        let passButton = getTabButton()
        passButton.setImage(getImage(name: "add pass"), for: .normal)
        passButton.tintColor = currentTabIndex == 1 ? TINT_COLOR : DEFAULT_COLOR
        tabButtons.append(passButton)
        
        passTab.addSubview(passButton)
        
        self.addSubview(historyTab)
        self.addSubview(passTab)
    }
    
    internal func getImage(name: String) -> UIImage {
        let image = UIImage(named: name)!
        return image.withRenderingMode(.alwaysTemplate)
    }
    
    internal func getTabButton() -> UIButton {
        let tabButton = UIButton(frame: CGRect(x: 0, y: 0, width: tabWidth, height: self.frame.height))
        tabButton.addTarget(self, action: #selector(tabSelected), for: .touchUpInside)
        
        return tabButton
    }
    
    func tabSelected(sender: UIButton) {
        currentTabIndex = tabButtons.index(of: sender)!
        delegate.customTabBar(customTabBar: self, didSelectItemAt: currentTabIndex)
        
        if currentTabIndex == 0 {
            tabButtons[0].tintColor = TINT_COLOR
            tabButtons[1].tintColor = DEFAULT_COLOR
        } else {
            tabButtons[0].tintColor = DEFAULT_COLOR
            tabButtons[1].tintColor = TINT_COLOR
        }
    }
    
    func performNewScan() {
        delegate.startScanningForNewCode()
    }
}
