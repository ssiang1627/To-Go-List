//
//  RoutesData.swift
//  ToGoList
//
//  Created by mac on 2016/6/16.
//  Copyright © 2016年 group7. All rights reserved.
//

import Foundation
import SQLite

struct Route {
    var name: String?
    var locationList: [String]
    
    init(_name: String, _locationList: String?){
        self.name = _name
        if _locationList != nil {
            self.locationList = _locationList!.componentsSeparatedByString(",")
        } else {
            self.locationList = []
        }
        
        
    }
    
    
    func locationListToStr() -> String {
        if locationList != []{
            return self.locationList.joinWithSeparator(",")
        } else {
            return ""
        }
    }
}
struct RouteTable {
    static let table = Table("routes")
    static let itemId = Expression<Int64>("id")
    static let name = Expression<String>("name")
    static let locationList = Expression<String>("locationList")
    
    
    
    
}

class RouteSource{
    
    var routes: [Route]!
    let fileName: String = "TGLISTDB"
    var filePath: String {
        let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let filePath = (documentFolder as NSString).stringByAppendingPathComponent("\(fileName).sqlite3")
        return filePath
    }
    var databaseConnection: Connection?
    
    static let sharedInstance = RouteSource()
    
    private init() {
        self.openDatabase()
        self.routes = []
    }
    
    func openDatabase(){
        do {
            self.databaseConnection = try Connection(filePath)
            print(filePath)
            
            try self.databaseConnection!.run(RouteTable.table.create(ifNotExists: true) { t in
                t.column(RouteTable.itemId, primaryKey: .Autoincrement)
                t.column(RouteTable.name)
                t.column(RouteTable.locationList)
                //t.foreignKey(RouteTable.locationList, references: LocationTable.table, LocationTable.name)
                })
        } catch {
            print("Cannot open database")
            exit(1)
        }
    }
    
    func loadFromDB(){
        var _list: [Route] = []
        do{
            for l in try databaseConnection!.prepare(RouteTable.table) {
                let l = Route(_name: l[RouteTable.name],
                              _locationList: l[RouteTable.locationList])
                _list.append(l)
            }
        } catch{
            print("Cannot read locations from DB")
        }
        self.routes = _list
    }
    
    func getRouteList() -> [Route] {
        self.loadFromDB()
        return self.routes
    }
    
    func insertRouteToList(newRoute: Route){
        self.routes.append(newRoute)
        self.writeBacktoDB()
    }
    
    func insertPinToLocationList(PinToRoute: [String], index: Int){
        if  (self.routes?[index].locationList[0])! == ""{
        self.routes?[index].locationList = PinToRoute
        }else{
            for pinIndex in 0..<PinToRoute.count{
            self.routes?[index].locationList.append(PinToRoute[pinIndex])
            }
        }
        self.writeBacktoDB()

        
    }
    /*
    func insertPinToLocationList(PinToRoute: String, index: Int){
        
        if  (self.routes?[index].locationList[0])! == "" {
            self.routes?[index].locationList[0] = PinToRoute
        }else{
            self.routes?[index].locationList.append(PinToRoute)
        }
        self.writeBacktoDB()
        
        
    }
    */
    
    func removePinFromLocationList(RouteIndex: Int, LocationIndex: Int){
        self.routes?[RouteIndex].locationList.removeAtIndex(LocationIndex)
        self.writeBacktoDB()
    }
    
    func removeRouteFromList(targetRoute: Route){
        if let indexOfTarget = routes.indexOf({$0.name == targetRoute.name}){
            self.routes.removeAtIndex(indexOfTarget)
        } else {
            print("Target route to remove not found")
        }
        self.writeBacktoDB()
    }
    

    
    func writeBacktoDB(){
        if self.databaseConnection == nil {
            return
        }
        // should be called when App is closed
        do {
            // first delete all rows in db
            try self.databaseConnection!.run(RouteTable.table.delete())
            // then insert from list
            do{
                for l in self.routes{
                    try self.databaseConnection!.run(RouteTable.table.insert(
                        RouteTable.name <- l.name!,
                        RouteTable.locationList <- l.locationListToStr()
                        ))
                }
            } catch {
                print("Cannot insert data")
            }
            
        } catch {
            print("Cannot write back to database")
            exit(1)
        }
    }
}


