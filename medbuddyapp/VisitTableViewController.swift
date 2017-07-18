//
//  RootTableViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/4/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import MIBadgeButton_Swift
import JVMenuPopover
class VisitTableViewController: UITableViewController,UINavigationControllerDelegate,JVMenuPopoverDelegate {
    /**
     Tells the selected view controller with @a indexPath.
     
     @param indexPath
     The index path of the menu.
     */

    var menuPopover : JVMenuPopoverView? = nil
    var menuItems : JVMenuItems? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.m_fabButton?.show()
        menuItems = JVMenuItems(menuImages: [UIImage(named: "home-48"),
                                             UIImage(named: "about-48") ,
                                             UIImage(named: "settings") ,
                                             UIImage(named: "business_contact-48")],
                                menuTitles: ["Visit List","Open Alerts","Open Messages","See User Detail"], menuCloseButtonImage: UIImage(named:"cancel_filled-50")!)
        menuItems?.menuSlideInAnimation = true;
        menuPopover = JVMenuPopoverView(frame: self.view.frame, menuItems: menuItems)
        menuPopover?.backgroundColor? = UIColor(white: 0, alpha: 0.5)
        menuPopover?.delegate = self;
        self.commonInit();
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.m_fabButton?.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VisitItemCell
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "visitdetail", sender: self)
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func menuPopoverDidSelectViewController(at indexPath: IndexPath!) {
        if(indexPath.row == 0)
        {
            self.navigationController?.viewControllers = [(UIApplication.shared.delegate as! AppDelegate).visitlistController]
        }
        else if(indexPath.row == 1)
        {
            self.navigationController?.viewControllers = [(UIApplication.shared.delegate as! AppDelegate).alertlistController]
        }
        else if (indexPath.row == 2)
        {
            self.navigationController?.viewControllers = [(UIApplication.shared.delegate as! AppDelegate).messagelistController]

        }
        else if (indexPath.row == 3)
        {
            //self.navigationController?.viewControllers = [self.rootController]
        }

    }
    func commonInit(){
        // creating menu
        // setting up menu bar button
        /*navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_black-48", in: bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(self.showMenu))
         showNavigationItem()
         addObservers()*/
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_black-48"), style: .plain, target: self, action: #selector(self.showMenu))
        
        let btn1 : MIBadgeButton = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        btn1.setImage(UIImage(named: "message"), for: .normal)
        
        btn1.badgeString = "0"
        btn1.badgeEdgeInsets = UIEdgeInsetsMake(10, 15, 0, 15)
        btn1.badgeTextColor = UIColor.black
        
        btn1.badgeBackgroundColor = UIColor.white
        let messageNotification = UIBarButtonItem(customView: btn1)
        
        let btn2 = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn2.setImage(UIImage(named: "bell"), for: .normal)
        
        btn2.badgeString = "0"
        btn2.badgeEdgeInsets = UIEdgeInsetsMake(10, 15, 0, 15)
        btn2.badgeTextColor = UIColor.black
        
        btn2.badgeBackgroundColor = UIColor.white
        let bellNotification = UIBarButtonItem(customView: btn2)
        navigationItem.rightBarButtonItems = [bellNotification, messageNotification]
        self.showNavigationItem()
        
        self.addObservers()
        
    }
    func showMenu() {
        menuPopover?.showMenu(with: self)
    }
    func showNavigationItem() {
        // showing the menu bar button
        animateNavigationItem(to: UIColor.black)
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDeviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    func animateNavigationItem(to toColor: UIColor) {
        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {() -> Void in
            self.navigationItem.leftBarButtonItem?.tintColor = toColor
        }, completion: nil)
    }
    func didDeviceOrientationChange(_ notification: Notification) {
        
    }
}
