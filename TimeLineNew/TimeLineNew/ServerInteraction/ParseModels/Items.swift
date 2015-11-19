//
//  Items.swift
//  TimeLineNew
//
//  Created by Jameel Khan on 11/19/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class Items: PFObject , PFSubclassing{
    
    @NSManaged var name : String?;
    @NSManaged var photo_url : String?;
    

    class func parseClassName() -> String {
        return "Items";
    }
}
