//
//  AddPinToRouteTabelViewController.swift
//  ToGoList
//
//  Created by mac on 2016/6/16.
//  Copyright © 2016年 group7. All rights reserved.
//

import UIKit

class AddPinToRouteTabelViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    var locations: [Location]?
    var searchResults:[Location] = []
    var searchController:UISearchController!
    var routes: [Route]? = []
    var index: Int? = 0
    var pin: [String] = []
    //    var locations = [Location(_name: "home", _tags: "", _url: "", _address: "台北市內湖區成功路五段450巷21弄33號7樓", _lati: 12, _long: 21, _visited: 0, _phoneNumber: "0987654321", _imagePath: ""), Location(_name: "taipei 101", _tags: "", _url: "", _address: "臺北市信義區西村里8鄰信義路五段7號", _lati: 0, _long: 0, _visited: 0, _phoneNumber: "", _imagePath: ""), Location(_name: "覺旅", _tags: "", _url: "", _address: "114台北市內湖區瑞光路583巷24號", _lati: 0, _long: 0, _visited: 0, _phoneNumber: "1234567890", _imagePath: "")]
   
    @IBOutlet var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        
        
        routes = RouteSource.sharedInstance.getRouteList()
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
                
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
        locations = LocationsSource.sharedInstance.getLocationList()
        //        print("LocationList numberOfRows")
        //        let count = locations!.count
        if searchController.active {
            return searchResults.count
        } else {
            return (locations?.count)!
        }
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let indexPath = tableView.indexPathForSelectedRow!
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! AddPinToRouteTableViewCell
        
        //tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        pin.append(currentCell.locationNameLabel.text!)
            
        print(pin)
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! AddPinToRouteTableViewCell
        
        //tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        
        
        pin = pin.filter{$0 != currentCell.locationNameLabel.text!}
        
        print(pin)
    }

    @IBAction func clickAddButton(sender: AnyObject) {
        //print(pin)
        
        if pin != []{
            RouteSource.sharedInstance.insertPinToLocationList(pin, index: index!)
            
            let successAlert = UIAlertController(title: "Sucess", message: "Add the pins to " + routes![index!].name! + "'s location list successfully!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {
                (action:UIAlertAction) -> () in self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            successAlert.addAction(okAction)
            self.presentViewController(successAlert, animated: true, completion: nil)
            
            print(pin)
            for _ in 0..<pin.count {
                self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: false)
            }
            
            pin = []
            
            print(pin)
            
            
        }else{
            let selectAlert = UIAlertController(title: "Oops!", message: "Please select pins you want to add!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {
                (action:UIAlertAction) -> () in self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            selectAlert.addAction(okAction)
            self.presentViewController(selectAlert, animated: true, completion: nil)
            
        }
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AddPinToRouteTableViewCell
        let location = searchController.active ? searchResults[indexPath.row] : locations![indexPath.row]
        // Configure the cell...
        
        cell.locationNameLabel.text = location.name
        cell.locationAddressLabel.text = location.address
        switch location.tags[0] {
        case "bar":
            cell.locationTypeImage.image = UIImage(named:"barmarker")
        case "restaurant":
            cell.locationTypeImage.image = UIImage(named:"restaurantmarker")
        case "hotel":
            cell.locationTypeImage.image = UIImage(named:"hotelmarker")
        case "shopping":
            cell.locationTypeImage.image = UIImage(named:"shoppingmarker")
        case "recreation":
            cell.locationTypeImage.image = UIImage(named:"recreationmarker")
        default:
            cell.locationTypeImage.image = UIImage(named:"placemarker")
        }

        
        if let isVisited = location.visited {
            cell.accessoryType = isVisited ? .Checkmark : .None
        }
        
        return cell
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListShowDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)!
            let location = self.locations![indexPath.row]
            
            let detailViewController = segue.destinationViewController as! LocationDetailTableViewController
            detailViewController.location = searchController.active ? searchResults[indexPath.row] : locations![indexPath.row]
            detailViewController.location = location
            
        }
    }
 */
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active {
            return false
        } else {
            return true
        }
    }
    
    
    
    // Override to support editing the table view.
         
    //for searchcontroller
    func filterContentForSearchText(searchText: String) {
        searchResults = (locations?.filter({ (location:Location) -> Bool in
            let nameMatch = location.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let typeMatch = location.tags[0].rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return (nameMatch != nil || typeMatch != nil)
        }))!
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //do whatever with searchController here.
        if let searText = searchController.searchBar.text {
            filterContentForSearchText(searText)
            tableView.reloadData()
        }
    }
    
    
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
