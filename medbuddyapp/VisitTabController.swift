//
//  VisitTabController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/17/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import Eureka
import ASJOverflowButton
import PopupDialog
class VisitTabController: UITabBarController {

    var is_CreateMode : Bool!
    var current_VisitID : String!
    var menuButton : ASJOverflowButton!
    var menuItems : [ASJOverflowItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        (childViewControllers[0] as! VisitBeforeController).is_CreateMode = self.is_CreateMode
        (childViewControllers[1] as! VisitProcessController).is_CreateMode = self.is_CreateMode
        //(childViewControllers[2] as! VisitSummaryViewController).is_CreateMode = self.is_CreateMode
        if is_CreateMode == false{
            (childViewControllers[0] as! VisitBeforeController).currentVisitID = self.current_VisitID
            (childViewControllers[1] as! VisitProcessController).currentVisitID = self.current_VisitID
            (childViewControllers[2] as! VisitSummaryController).currentVisitID = self.current_VisitID
            
            menuItems.append(ASJOverflowItem(name: "Ask Your DR" ))
            menuItems.append(ASJOverflowItem(name: "Ask a Friend" ))
            menuItems.append(ASJOverflowItem(name: "Ask Patients Like Me" ))
            menuItems.append(ASJOverflowItem(name: "Show Alerts" ))
            menuItems.append(ASJOverflowItem(name: "Update Visit" ))
            menuItems.append(ASJOverflowItem(name: "Delete Visit" ))
            menuButton = ASJOverflowButton(image: UIImage(named : "menu_black-48")!, items: menuItems)
            
            menuButton.dimsBackground = true
            menuButton.hidesSeparator = false
            menuButton.hidesShadow = false
            menuButton.dimmingLevel = 0.3
            menuButton.menuItemHeight = 50.0
            menuButton.widthMultiplier = 0.5
            menuButton.itemTextColor = UIColor.black
            menuButton.menuBackgroundColor = UIColor.white
            menuButton.itemHighlightedColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.1))
            menuButton.menuMargins = MenuMarginsMake(7.0, 7.0, 7.0)
            menuButton.separatorInsets = SeparatorInsetsMake(10.0, 5.0)
            menuButton.menuAnimationType = .zoomIn
            menuButton.itemFont = UIFont(name: "Verdana", size: CGFloat(13.0))

            
            menuButton.itemTapBlock = {(item, idx) in
                switch idx {
                case 0:
                    self.showAskyourdocotrDlg(animated: true)
                case 1:
                    self.showAskyourfriendDlg(animated: true)
                default:
                    break
                }
            }
            self.navigationItem.rightBarButtonItem = menuButton
        }
        else{
            ((self.tabBar.items?[1])! as UITabBarItem).isEnabled = false
            ((self.tabBar.items?[2])! as UITabBarItem).isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAskyourfriendDlg(animated : Bool = true){
        // Create a custom view controller
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"AskYourFriend") as! AskYourFriend
        
        // Create the dialog
        let popup = PopupDialog(viewController: controller, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let OKBtn = DefaultButton(title: "Send", height: 60) {
        }
        
        // Create second button
        let CancelBtn = CancelButton(title: "Cancel", height: 60) {
        }
        
        // Add buttons to dialog
        popup.addButtons([OKBtn, CancelBtn])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    func showAskyourdocotrDlg(animated: Bool = true) {
        
        // Create a custom view controller
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"AskYourDoctor") as! AskYourDoctor
        
        // Create the dialog
        let popup = PopupDialog(viewController: controller, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let OKBtn = DefaultButton(title: "Send", height: 60) {
                   }
        
        // Create second button
        let CancelBtn = CancelButton(title: "Cancel", height: 60) {
                    }
        
        // Add buttons to dialog
        popup.addButtons([OKBtn, CancelBtn])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func presentRightMenu(){
        
    }
    
}
