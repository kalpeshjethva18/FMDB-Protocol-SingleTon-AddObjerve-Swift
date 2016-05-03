//
//  TheOneAndOnlyKraken.swift
//  Sponj
//
//  Created by macpc on 28/04/16.
//  Copyright (c) 2016 macpc. All rights reserved.
//

import UIKit


class MySingleTon{
    var GlobleDict = NSMutableDictionary()
    var fmdb = DBManagerClass()
    let SingleToneDateFormate = NSDateFormatter()
    static let sharedManager = MySingleTon()
}