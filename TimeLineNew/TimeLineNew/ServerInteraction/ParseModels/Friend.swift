//
//  Friend.swift
//  TimeLineNew
//
//  Created by Jameel Khan on 11/19/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class Friend: PFObject, PFSubclassing {

    @NSManaged var photo : String? ;
    @NSManaged var firstName : String?;
    @NSManaged var lastName : String?;
    class func parseClassName() -> String {
        return "Friend"
    }
}
