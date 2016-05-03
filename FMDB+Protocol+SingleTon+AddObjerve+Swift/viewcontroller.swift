//
//  viewcontroller.swift
//  fmdb
//
//  Created by macpc on 23/02/15.
//  Copyright (c) 2015 macpc. All rights reserved.
//

import UIKit

public protocol popAddBudgetVCDelegate    //Create delegate for passing data on popViewController -Sohan Vanani 27-Oct-2015
{
    func getbudgetView(ViewName: String)  //delegate method to retrive data  -Sohan Vanani 27-Oct-2015
}


class viewcontroller: UIViewController, popAddBudgetVCDelegate {

    var fileName = "PizzaSystemDB.sqlite"
    var dictionary=NSMutableDictionary()
    var fmdb = DBManagerClass()
    
    @IBOutlet var txtname: UITextField!
    @IBOutlet var txtemailid: UITextField!
    var delegate:popAddBudgetVCDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if you do not want to create protocaol then you can use add observe notifications
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reload", object: nil)

        
        
    }
    func reloadTableData(notification: NSNotification) {
        
        println("add observe call")
    }
    

    override func viewWillAppear(animated: Bool) {
        
    var dict = MySingleTon.sharedManager.GlobleDict
        
      println("dictionary \(dict)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnsubmit(sender: UIButton)
    {
        dictionary = ["first_name": txtname.text, "email": txtemailid.text, "facebook_id": txtemailid.text]
        fmdb.InsertDynamictData("user", dictionary)
        
        txtname.text=""
        txtemailid.text=""
        txtname .becomeFirstResponder()
    }
    @IBAction func btndelete(sender: UIButton)
    {
        if sender.tag == 1
        {
            var sec = secview(nibName:"secview", bundle:nil)
            sec.delegate = self
            self.navigationController?.pushViewController(sec, animated: true)
        }
        else
        {
            fmdb.DeleteAllData("user")
        }
    }
    func getbudgetView(ViewName: String)
    {
        println("delegate call \(ViewName)")
    }

    /*
    func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName)
        println("copyFile fileName=\(fileName) to path=\(dbPath)")
        var fileManager = NSFileManager.defaultManager()
        var fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName)
        if !fileManager.fileExistsAtPath(dbPath) {
            println("dB not found in document directory filemanager will copy this file from this path=\(fromPath) :::TO::: path=\(dbPath)")
            fileManager.copyItemAtPath(fromPath!, toPath: dbPath, error: nil)
        } else {
            println("DID-NOT copy dB file, file allready exists at path:\(dbPath)")
        }
    }
    func getPath(fileName: String) -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingPathComponent("PizzaSystemDB.sqlite")
    }
*/
}
