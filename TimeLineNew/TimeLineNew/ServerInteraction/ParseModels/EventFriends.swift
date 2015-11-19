//
//  EventFriends.swift
//  TimeLineNew
//
//  Created by Jameel Khan on 11/19/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class EventFriends: PFObject, PFSubclassing {
    
    @NSManaged var event_id : String?;
    @NSManaged var friend_id : String?;

    class func parseClassName() -> String {
        return "EventFriends";
    }
}
