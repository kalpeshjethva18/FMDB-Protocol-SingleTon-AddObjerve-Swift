//
//  thirdViewController.swift
//  fmdb
//
//  Created by macpc on 03/05/16.
//  Copyright (c) 2016 macpc. All rights reserved.
//

import UIKit

class thirdViewController: UIViewController {

    var delegate : popAddBudgetVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func popbtn(sender: UIButton) {
        
        self.delegate.getbudgetView("from thirdview")
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
