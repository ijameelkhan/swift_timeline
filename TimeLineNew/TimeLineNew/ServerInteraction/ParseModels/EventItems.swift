//
//  EventItem.swift
//  TimeLineNew
//
//  Created by Jameel Khan on 11/19/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class EventItems: PFObject, PFSubclassing {

    @NSManaged var eventId : String?;
    @NSManaged var item_id : String?;
    @NSManaged var item_id_clone : String?;
    
    class func parseClassName() -> String {
        return "EventItems"
    }
}
