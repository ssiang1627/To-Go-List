//
//  RouteDetailTableViewController.swift
//  ToGoList
//
//  Created by mac on 2016/6/16.
//  Copyright © 2016年 group7. All rights reserved.
//

import UIKit

class RouteDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var routes: [Route]?
    var index: Int?  = 0
    var locations: [Location]?
    var location: Location?
    var oldRoute: Route?
    var newRoute: Route?
    
    
    
    
    
    
    
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet var routeNameNavigationItem: UINavigationItem!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        routes = RouteSource.sharedInstance.getRouteList()
        locations = LocationsSource.sharedInstance.getLocationList()
        self.routeNameNavigationItem.title = routes?[index!].name
        
        
        
        //routes = [Route(_name: "home", _locationList: "NCCU, home"), Route(_name: "NCCU", _locationList: "Bobochacha, 711, FamilyMart")]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        routes = RouteSource.sharedInstance.getRouteList()
        print(routes![index!].locationList)
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
        
        
        //routes = [Route(_name: "home", _locationList: "NCCU, home"), Route(_name: "NCCU", _locationList: "Bobochacha, 711, FamilyMart")]
       
        let count = routes?[index!].locationList.count
        return count!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteDetailCell", forIndexPath: indexPath) as! RouteDetailTableViewCell
        
        // Configure the cell...
        for searchIndex in 0..<locations!.count{
            if locations![searchIndex].name == routes![index!].locationList[indexPath.row] {
                
                cell.routeLocationListLabel.text = locations![searchIndex].name
                cell.routeLocationListPhoneLabel.text = locations![searchIndex].phoneNumber
                cell.routeLocationListAddressLabel.text = locations![searchIndex].address
                //cell.routeLocationTypeImage = locations![searchIndex].imagePath
                switch locations![searchIndex].tags[0] {
                case "bar":
                    cell.routeLocationTypeImage.image = UIImage(named:"barmarker")
                case "restaurant":
                    cell.routeLocationTypeImage.image = UIImage(named:"restaurantmarker")
                case "hotel":
                    cell.routeLocationTypeImage.image = UIImage(named:"hotelmarker")
                case "shopping":
                    cell.routeLocationTypeImage.image = UIImage(named:"shoppingmarker")
                case "recreation":
                    cell.routeLocationTypeImage.image = UIImage(named:"recreationmarker")
                default:
                    cell.routeLocationTypeImage.image = UIImage(named:"placemarker")
                }

            }
            /*else{
                cell.routeLocationListAddressLabel.text = ""
                cell.routeLocationListPhoneLabel.text = ""
                cell.routeLocationTypeImage.image = nil
                tableView.allowsSelection = false
            }
        */
        }
        
        cell.routeLocationListLabel.text = routes![index!].locationList[indexPath.row]
        if cell.routeLocationListLabel.text == "" {
            cell.routeLocationListAddressLabel.text = ""
            cell.routeLocationListPhoneLabel.text = ""
            cell.routeLocationTypeImage.image = nil
            tableView.allowsSelection = false
            
            
            let addAlert = UIAlertController(title: "", message: "Click the Add Button to add pins to the route \"" + routes![index!].name! + "\"" , preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {
                (action:UIAlertAction) -> () in self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            addAlert.addAction(okAction)
            self.presentViewController(addAlert, animated: true, completion: nil)

        }
        
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            RouteSource.sharedInstance.removePinFromLocationList(index!, LocationIndex: indexPath.row)
            routes![index!].locationList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        tableView.reloadData()
    }

    @IBAction func startEditing(sender: UIBarButtonItem) {
        if self.tableView.editing{
            //listTableView.editing = false;
            self.tableView.setEditing(false, animated: false);
            editButton.style = UIBarButtonItemStyle.Plain;
            editButton.title = "Edit";
            newRoute = routes![index!]
            if (newRoute?.locationList)! != (oldRoute?.locationList)! {
                RouteSource.sharedInstance.removeRouteFromList(oldRoute!)
                RouteSource.sharedInstance.insertRouteToList(newRoute!)
            }
            
            print("a")
            
            
            //listTableView.reloadData();
        }
        else{
            //listTableView.editing = true;
            
            self.tableView.setEditing(true, animated: true);
            editButton.title = "Done";
            editButton.style =  UIBarButtonItemStyle.Done;
            oldRoute = routes![index!]
                        //self.tableView.reloadData()
        }

    }
 
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = routes![index!].locationList[sourceIndexPath.row]
        routes![index!].locationList.removeAtIndex(sourceIndexPath.row)
        routes![index!].locationList.insert(itemToMove, atIndex: destinationIndexPath.row)
        print(routes![index!].locationList)
        
        
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddPinToRoute" {

            
            let AddPinViewController = segue.destinationViewController as! AddPinToRouteTabelViewController
            //detailViewController.route = searchController.active ? searchResults[indexPath.row] : locations![indexPath.row]
            //AddPinViewController.routes! = self.routes!
            AddPinViewController.index! = self.index!
            //AddPinViewController.routes?[index!] = routes![index!]
            
            
        }else if segue.identifier == "routesLocationShowDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)!
            
            
            for searchIndex in 0..<locations!.count{
                if locations![searchIndex].name == routes![index!].locationList[indexPath.row] {
                    location = locations![searchIndex]
                }
            }

            let routesLocationShowDetailVC = segue.destinationViewController as! LocationDetailTableViewController
            routesLocationShowDetailVC.location = location
            
            
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
