//
//  TimelineCell.swift
//  TimeLineNew
//
//  Created by Jameel Khan on 11/19/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewSeparator:UIView!
    
    @IBOutlet weak var lblShopedWith: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewGrouped: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewDateCircle: UIView!
    
    var privateEvent : Event?
    
    var event: Event? {
        get {
            return privateEvent!
        }
        set {
            
            privateEvent = newValue;
            self.lblDate.text = self.dateStr((self.event?.purchase_date)!);
            self.lblId.text = self.event?.number;
            self.lblMessage.text = self.event?.message;
            NSLog((self.event?.objectId)!);
            var query:PFQuery = EventItems.query()!;
            query.whereKey("event_id", equalTo: self.event!);
            query.includeKey("item_id");
            
            query.findObjectsInBackgroundWithBlock({ (arr, err) -> Void in
                
                self.event?.items = NSMutableArray();
                for itm in arr!
                {
                    self.event?.items?.addObject(itm["item_id"] as! Items)
                }
                self.generateScroll();
                
            });
            
            query = EventFriends.query()!;
            query.whereKey("event_id", equalTo: self.event!);
            query.includeKey("friend_id");
            
            query.findObjectsInBackgroundWithBlock({ (arr, err) -> Void in
                
                self.event?.friends = NSMutableArray();
                for itm in arr!
                {
                    self.event?.friends?.addObject(itm["friend_id"] as! Friend)
                }
                self.generateGroupedImages();
                self.generateFriendString();
            });
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContainer.layer.borderWidth = 2;
        self.viewContainer.layer.borderColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.7).CGColor;
        //self.generateScroll();
        //self.generateGroupedImages();
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setIsDateCell(isDateCell: Bool) {
        
        if isDateCell {
            self.viewSeparator.hidden = false;
            self.lblDate.hidden = false;
            self.viewDateCircle.hidden = false;
        }
        else {
            self.viewSeparator.hidden = true;
            self.lblDate.hidden = true;
            self.viewDateCircle.hidden = true;
        }
    }
    

    func generateFriendString()
    {

        if(self.event?.friends?.count == 0)
        {
            self.lblShopedWith.text = "No friends";
            self.viewGrouped.backgroundColor = UIColor.blackColor();
            return;
        }
        self.viewGrouped.backgroundColor = UIColor.clearColor();
        let str:NSMutableString? = "";
        for(var i = 0; i < self.event?.friends?.count; i++ )
        {
            str?.appendString((self.event?.friends?.objectAtIndex(i) as! PFObject)["firstName"] as! String);
            if(i == 2 && self.event?.friends?.count > 4)
            {
                str?.appendFormat("and %i more people", ((self.event?.friends?.count)! - i))
                
            }
            if(i != (self.event?.friends?.count)! - 1)
            {str?.appendString(", ");}
            
        }
        self.lblShopedWith.text = String(str!);
        
        //self.lblId.text = self.event?.number?.stringValue;
    }
    
    
    func generateScroll()
    {
        self.scrollView.subviews.forEach { $0.removeFromSuperview() };
        
        var imageView:UIImageView?;
        var valueX:CGFloat = 0
        
        let dimension:CGFloat = 38;
        let xGap:CGFloat = 6.0;
        
        
        for var index = 0; index < self.event?.items?.count; ++index
        {
            imageView = UIImageView.init(frame: CGRectMake(valueX, 2, dimension, dimension));
            imageView?.contentMode = UIViewContentMode.ScaleAspectFill;
            imageView?.clipsToBounds = true;
            let str:String = (self.event?.items?.objectAtIndex(index) as! PFObject)["photo_url"] as! String;
            imageView!.imageURL = NSURL(string: str);
            self.scrollView.addSubview(imageView!);
            valueX =  dimension + valueX + xGap;
        }
        self.scrollView.contentSize = CGSizeMake(valueX, CGFloat(self.scrollView.bounds.size.height));
        
    }
    
    func generateGroupedImages()
    {
        let count:NSInteger = (self.event?.friends?.count)!;
        var index:NSInteger? = 0;
        
        self.viewGrouped.subviews.forEach { $0.removeFromSuperview() };
        
        let kFactor:CGFloat = CGFloat(4);
        
        let semiHeight:CGFloat = self.viewGrouped.bounds.size.height/2 + kFactor;
        var initialY:CGFloat = CGFloat(0);
        let secondX:CGFloat = CGFloat(semiHeight);
        
        var imageViewRight:UIImageView = UIImageView.init(frame: CGRectZero);
        var imageViewLeft:UIImageView = UIImageView.init(frame: CGRectZero);
        var str:String;
        if(count == 0)
        {
            return;
        }
        else if(count == 1)
        {
            imageViewLeft.frame = self.viewGrouped.bounds;
            self.viewGrouped.addSubview(imageViewLeft);
            imageViewLeft.backgroundColor = UIColor.blackColor();
            imageViewLeft.layer.cornerRadius = imageViewLeft.bounds.size.height/2;
            str = (self.event?.friends?.objectAtIndex(index!) as! PFObject)["photo"] as! String;
            imageViewLeft.imageURL = NSURL(string: str);
            imageViewLeft.contentMode = UIViewContentMode.ScaleAspectFill;
            imageViewRight.contentMode = UIViewContentMode.ScaleAspectFill;
            imageViewRight.clipsToBounds = true;
            imageViewLeft.clipsToBounds = true;
        }
        else
        {
            if(count == 2)
            {
                initialY = self.viewGrouped.bounds.size.height/2 - semiHeight/2 + kFactor;
            }
            else if(count == 3)
            {
                imageViewLeft = UIImageView.init(frame:CGRectMake(self.viewGrouped.bounds.size.width/2 - semiHeight/2, 0, semiHeight,semiHeight));
                imageViewLeft.backgroundColor = UIColor.blackColor();
                imageViewLeft.layer.cornerRadius = semiHeight/2;
                imageViewLeft.contentMode = UIViewContentMode.ScaleAspectFill;
                imageViewRight.contentMode = UIViewContentMode.ScaleAspectFill;
                imageViewRight.clipsToBounds = true;
                imageViewLeft.clipsToBounds = true;
                self.viewGrouped.addSubview(imageViewLeft);
                str = (self.event?.friends?.objectAtIndex(index!) as! PFObject)["photo"] as! String;
                imageViewLeft.imageURL = NSURL(string: str);
                index = index! + 1;
                
                initialY = semiHeight;
            }
                
            else if(count >= 4)
            {
                imageViewLeft = UIImageView.init(frame:CGRectMake(0, initialY, semiHeight,semiHeight));
                imageViewRight = UIImageView.init(frame:CGRectMake(secondX - (kFactor*2), initialY, semiHeight, semiHeight));
                self.viewGrouped.addSubview(imageViewLeft);
                self.viewGrouped.addSubview(imageViewRight);
                imageViewLeft.backgroundColor = UIColor.blackColor();
                imageViewRight.backgroundColor = UIColor.blackColor();
                imageViewRight.layer.cornerRadius = semiHeight/2;
                imageViewLeft.layer.cornerRadius = semiHeight/2;
                imageViewLeft.contentMode = UIViewContentMode.ScaleAspectFill;
                imageViewRight.contentMode = UIViewContentMode.ScaleAspectFill;
                imageViewRight.clipsToBounds = true;
                imageViewLeft.clipsToBounds = true;
                str = (self.event?.friends?.objectAtIndex(index!) as! PFObject)["photo"] as! String;
                imageViewLeft.imageURL = NSURL(string: str);
                index = index! + 1;
                
                str = (self.event?.friends?.objectAtIndex(index!) as! PFObject)["photo"] as! String;
                imageViewRight.imageURL = NSURL(string: str);
                index = index! + 1;
                
                initialY = semiHeight;
            }
            
            
            imageViewLeft = UIImageView.init(frame:CGRectMake(0, initialY - (kFactor*2), semiHeight,semiHeight));
            imageViewRight = UIImageView.init(frame:CGRectMake(secondX - (kFactor*2), initialY - (kFactor*2), semiHeight, semiHeight));
            imageViewLeft.backgroundColor = UIColor.blackColor();
            imageViewRight.backgroundColor = UIColor.blackColor();
            imageViewLeft.contentMode = UIViewContentMode.ScaleAspectFill;
            imageViewRight.contentMode = UIViewContentMode.ScaleAspectFill;
            imageViewRight.clipsToBounds = true;
            imageViewLeft.clipsToBounds = true;
            self.viewGrouped.addSubview(imageViewLeft);
            self.viewGrouped.addSubview(imageViewRight);
            imageViewRight.layer.cornerRadius = semiHeight/2;
            imageViewLeft.layer.cornerRadius = semiHeight/2;
            
            str = (self.event?.friends?.objectAtIndex(index!) as! PFObject)["photo"] as! String;
            imageViewLeft.imageURL = NSURL(string: str);
            index = index! + 1;
            
            str = (self.event?.friends?.objectAtIndex(index!) as! PFObject)["photo"] as! String;
            imageViewLeft.imageURL = NSURL(string: str);
            
            
        }
    }
    
    func dateStr(date:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let str:String = dateFormatter.stringFromDate(date);
        return str;
    }

    
}
