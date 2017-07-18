//
//  DEMORightMenuViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/29/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

class DEMORightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView!
    var width : CGFloat!
    var height : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        width = UIScreen.main.bounds.size.width
        height = UIScreen.main.bounds.size.height
        tableView = UITableView(frame: CGRect(x : self.view.frame.size.width/3 , y : (self.view.frame.size.height - 54 * 6) / 2.0, width : self.view.frame.size.width*2/3, height : 54 * 6), style: .plain)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        self.view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    override func viewDidLayoutSubviews() {
        
    }
    func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {


        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait\(self.view.frame.size.width)")

        }
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.sideMenuViewController.hideViewController()
        case 1:
            self.sideMenuViewController.hideViewController()
        case 2:
            self.sideMenuViewController.hideViewController()
        case 3:
            self.sideMenuViewController.hideViewController()
        case 4:
            self.sideMenuViewController.hideViewController()
        case 5:
            self.sideMenuViewController.hideViewController()
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(21))
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.highlightedTextColor = UIColor.lightGray
            cell?.selectedBackgroundView = UIView()
        }
        let titles = ["Ask Your DR", "Ask a Friend", "Ask Patients Like Me","Show Alerts","Update Visit","Delete Visit"]
        let images = ["IconHome", "IconCalendar", "IconProfile","IconHome", "IconCalendar", "IconProfile"]
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.textLabel?.textAlignment = .left
        cell?.imageView?.image = UIImage(named: images[indexPath.row] )
        
        return cell!
    }
}
