//
//  ViewController.swift
//  Timeline
//
//  Created by Jameel Khan on 11/18/15.
//  Copyright © 2015 Jameel Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let kCellIDTimeLine = "CellIDTimeLine"
  
    var dataSource : NSMutableDictionary!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.dataSource = [["10/20": ["Zen"]], ["09/3": ["Zen", "Ching Pong, Tafel and two more"]]]
        let nib = UINib(nibName: "TimelineCell", bundle: nil)
        self.dataSource = NSMutableDictionary();
        self.tableView.registerNib(nib, forCellReuseIdentifier: kCellIDTimeLine)
        self.loadEvents();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadEvents()
    {
        //eve
        
        let query:PFQuery? = Event.query();
        
        query?.findObjectsInBackgroundWithBlock({ (arr, err) -> Void in
            self.generateDataSource(arr);
        });
        
        
    }
    
    
    func generateDataSource(events:NSArray!)
    {
        self.dataSource.removeAllObjects();
        var event:Event!;
        var arr:NSMutableArray!;
        if(events == nil){ return;}
        for(var i = 0; i < events.count; i++)
        {
            event = events.objectAtIndex(i) as! Event;
            let date:NSDate! = event.purchase_date;
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = cal.components([.Day , .Month, .Year ], fromDate: date)
            let newDate = cal.dateFromComponents(components)
            
            let index:NSInteger? = self.dataSource.allKeys.indexOf({$0 as? NSObject == newDate});
            let key:NSDate = newDate!;
            if index == NSNotFound || index == nil
            {
                arr = NSMutableArray();
               
            }
            else
            {
                arr = self.dataSource.objectForKey(key) as? NSMutableArray;
                
            }
            arr.addObject(event);
            self.dataSource.setObject(arr, forKey: key);
        }
        self.tableView.reloadData();
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell:TimelineCell = tableView.dequeueReusableCellWithIdentifier(kCellIDTimeLine) as! TimelineCell;
//        return cell;
        let cell:TimelineCell = tableView.dequeueReusableCellWithIdentifier(kCellIDTimeLine) as! TimelineCell;
        let sortedKeys : NSArray = self.dataSource.allKeys.sort { ($0 as! NSDate) .compare($1 as! NSDate) == .OrderedAscending }
        let key:NSDate = sortedKeys.objectAtIndex(indexPath.section) as! NSDate;
        
        
        let arr : NSMutableArray = self.dataSource.objectForKey(key) as! NSMutableArray;
        
        let event:Event = arr.objectAtIndex(indexPath.row) as! Event;
        
        cell.event = event;
        cell.setIsDateCell(false);
        if (indexPath.row == 0)
        {
          //  cell.lblDate.text = ((dict.allKeys as NSArray).objectAtIndex(0) as! String);
            cell.setIsDateCell(true);
        }
        //cell.lblShopedWith.text = (arr.objectAtIndex(indexPath.row) as! String);
        if indexPath.row == 0 && indexPath.section == 0
        {
            cell.viewSeparator.hidden = true;
        }
        return cell;
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedKeys : NSArray = self.dataSource.allKeys.sort { ($0 as! NSDate) .compare($1 as! NSDate) == .OrderedAscending }
        let key:NSDate = sortedKeys.objectAtIndex(section) as! NSDate;
        let arr : NSMutableArray = self.dataSource.objectForKey(key) as! NSMutableArray;
        
        return arr.count;
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return 4;
        return dataSource.count
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 202
    }
    
}


