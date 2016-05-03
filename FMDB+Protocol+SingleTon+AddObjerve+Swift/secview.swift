//
//  secview.swift
//  fmdb
//
//  Created by macpc on 03/05/16.
//  Copyright (c) 2016 macpc. All rights reserved.
//

import UIKit

class secview: UIViewController, popAddBudgetVCDelegate {


    var delegate : popAddBudgetVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true

        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnsecview(sender: UIButton)
    {
        
     /*  //SingleTon object this way you can use
        var dict = NSMutableDictionary()
        dict.setObject("kalpesh", forKey: "1")
        dict.setObject("kalpesh2", forKey: "2")
        dict.setObject("kalpesh3", forKey: "3")
        dict.setObject("kalpesh4", forKey: "4")
        dict.setObject("kalpesh5", forKey: "5")
        MySingleTon.sharedManager.GlobleDict = dict
        self.delegate.getbudgetView("kalpesh jethva")
        self.navigationController?.popViewControllerAnimated(true)
        */
        
        
        if sender.tag == 1
        {
            self.delegate.getbudgetView("from sec view")
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            var third = thirdViewController(nibName: "thirdViewController", bundle:nil)
            third.delegate = self
            self.navigationController?.pushViewController(third, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getbudgetView(ViewName: String)
    {
        println("sec delegate call \(ViewName)")
    }
    @IBAction func popview(sender: UIButton) {
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
