//
//  ImagePreviewController.swift
//  medbuddyapp
//
//  Created by Admin User on 4/27/17.
//  Copyright © 2017 Admin User. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    
    var image : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageview.image = image
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
