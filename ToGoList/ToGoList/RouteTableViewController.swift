//
//  RouteTableViewController.swift
//  ToGoList
//
//  Created by mac on 2016/6/16.
//  Copyright © 2016年 group7. All rights reserved.
//

import UIKit

class RouteTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var routes:[Route]?
    
    
    @IBOutlet weak var tableView: UITableView!
            
    //var routes = [Route(_name: "home", _locationList: "NCCU, home"), Route(_name: "NCCU", _locationList: "Bobochacha, 711, FamilyMart")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routes = RouteSource.sharedInstance.getRouteList()
        
        //routes = [Route(_name: "home", _locationList: "NCCU, home"), Route(_name: "NCCU", _locationList: "Bobochacha, 711, FamilyMart")]
        

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        self.tableView.reloadData()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        routes = RouteSource.sharedInstance.getRouteList()
        //routes = [Route(_name: "home", _locationList: "NCCU, home"), Route(_name: "NCCU", _locationList: "Bobochacha, 711, FamilyMart")]
        
        let count = routes!.count
        return count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as! RouteTableViewCell
        
        // Configure the cell...
      
        cell.routeNameLabel.text = routes![indexPath.row].name
        //cell.routeLocationListLabel.text = routes![indexPath.row].locationListToStr()
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let deleteTarget = self.routes![indexPath.row]
            RouteSource.sharedInstance.removeRouteFromList(deleteTarget)
            routes!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        tableView.reloadData()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RouteShowDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)!
            //let route = self.routes![indexPath.row]
            
            let detailViewController = segue.destinationViewController as! RouteDetailTableViewController
            //detailViewController.route = searchController.active ? searchResults[indexPath.row] : locations![indexPath.row]
            detailViewController.routes = self.routes
           // detailViewController.routes?[indexPath.row] = route
            detailViewController.index! = indexPath.row
            
            
        }
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
