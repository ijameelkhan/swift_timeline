//
//  Events.swift
//  TimeLineNew
//
//  Created by Jameel Khan on 11/19/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class Event: PFObject, PFSubclassing {
    
    @NSManaged var message : String?;
    @NSManaged var number  : String?;
    @NSManaged var purchase_date : NSDate?;
    
    var items: NSMutableArray?;
    var friends: NSMutableArray?;
    
    

    class func parseClassName() -> String {
        return "Event";
    }

}
