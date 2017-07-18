//
//  DEMOLeftMenuViewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/29/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

class DEMOLeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView = UITableView(frame: CGRect(x: CGFloat(0), y: CGFloat((view.frame.size.height - 54 * 5) / 2.0), width: CGFloat(view.frame.size.width), height: CGFloat(54 * 5)), style: .plain)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let delegate = UIApplication.shared.delegate as! AppDelegate
        switch indexPath.row {
        case 0:
            delegate.navigationController.setViewControllers([delegate.visitlistController], animated: true)
            self.sideMenuViewController.setContentViewController(delegate.navigationController, animated: true)
            
            self.sideMenuViewController.hideViewController()
        case 1:
            delegate.navigationController.setViewControllers([delegate.alertlistController], animated: true)
            self.sideMenuViewController.setContentViewController(delegate.navigationController, animated: true)

            self.sideMenuViewController.hideViewController()
        case 2:
            delegate.navigationController.setViewControllers([delegate.messagelistController], animated: true)
            self.sideMenuViewController.setContentViewController(delegate.navigationController, animated: true)

            self.sideMenuViewController.hideViewController()
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
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
        let titles = ["VisitList", "AlertList", "MessageList"]
        let images = ["IconHome", "IconCalendar", "IconProfile"]
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.imageView?.image = UIImage(named: images[indexPath.row] )
        
        return cell!
    }
}
