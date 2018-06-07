////
////  DataBaseController.swift
////  NexGTv
////
////  Created by Pramod on 02/12/15.
////  Copyright (c) 2015 Appinventiv. All rights reserved.
////
//
//import Foundation
//import CoreData
//
var moc:NSManagedObjectContext
{
    return XMPPhelper.sharedInstance().managedObjectContext_messageArchive()
}
var persistentStoreCoordinator:NSPersistentStoreCoordinator
{
    return XMPPhelper.sharedInstance().persistentStoreCoordinator_messageArchive()
}
var managedObjectModel:NSManagedObjectModel
{
    return XMPPhelper.sharedInstance().managedObjectModel_messageArchive()
}

func insertChatData(param:[String:AnyObject]) -> XMPPMessageArchiving_Message_CoreDataObject
{
    
    print_debug(object: "insert in core data ====> \(param)")
    var obj:XMPPMessageArchiving_Message_CoreDataObject?
    obj = checkIfChatDataAlreadyExist(param: param)
    if (obj == nil)
    {
        obj = NSEntityDescription.insertNewObject(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", into: moc) as? XMPPMessageArchiving_Message_CoreDataObject
    }
    if let bareJid = param["bareJid"] as? XMPPJID{
        obj!.bareJid = bareJid
    }
    if let message = param["message"] as? XMPPMessage{
        obj!.message = message
    }
    if let messageStr = param["messageStr"]{
        obj!.messageStr = "\(messageStr)"
    }
    if let bareJidStr = param["bareJidStr"]{
        obj!.bareJidStr = "\(bareJidStr)"
    }
    if let body = param["body"]{
        obj!.body = "\(body)"
    }
    if let thread = param["thread"]{
        obj!.thread = "\(thread)"
    }
    if let outgoing = param["outgoing"] as? NSNumber{
        obj!.outgoing = outgoing
    }
    if let isOutgoing = param["isOutgoing"] as? Bool{
        obj!.isOutgoing = isOutgoing
    }
    if let composing = param["composing"] as? NSNumber{
        obj!.composing = composing
    }
    if let isComposing = param["isComposing"] as? Bool{
        obj!.isComposing = isComposing
    }
    if let timestamp = param["timestamp"] as? Date{
        obj!.timestamp = timestamp
    }
    if let sortedTimeStamp = param["sortedTimeStamp"] as? Date{
        obj!.sortedTimeStamp = sortedTimeStamp
    }
    if let isRead = param["isRead"] as? NSNumber{
        obj!.isRead = isRead
    }
    if let streamBareJidStr = param["streamBareJidStr"]{
        obj!.streamBareJidStr = "\(streamBareJidStr)"
    }
    
    if let _ = param["markerStatus"] {
        obj?.markStatus = NSNumber(value: 0)
    }
    if let body = param["body"] as? String {
        obj?.body = body
    }
    saveContext()
    return obj!
}

//MARK:- Check Whether Value Exist or Not
//MARK:-
func checkIfChatDataAlreadyExist(param: [String:AnyObject]) -> XMPPMessageArchiving_Message_CoreDataObject?
{
    if let elementId = param["elementId"] as? String{
        
        let predicate = NSPredicate(format: "streamBareJidStr = '\(CurrentUser.user_id!)@\(xmppHostNameJidSubString)'")
        let compound_predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        
        if let fetchResult = fetchData(modelName: "XMPPMessageArchiving_Message_CoreDataObject", predicateValue: compound_predicate) as? [XMPPMessageArchiving_Message_CoreDataObject]
        {
            
            if (!fetchResult.isEmpty) {
                
                let filteredArr = fetchResult.filter({ obj -> Bool in
                    if let elementID = obj.message?.elementID(){
                        return elementID == elementId
                    }
                    return false
                })
                return (filteredArr.count > 0) ? (filteredArr.first!):nil
            }
        }
    }
    return nil
}


//MARK:- Delete Data Form Core Data
//MARK:-
func deleteAllData(modelName:String,completion:(()->Void)?)
{
    getMainQueue(closure: {
        
        if #available(iOS 9.0, *) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try persistentStoreCoordinator.execute(deleteRequest, with: moc)
            }
            catch _ as NSError {
                // TODO: handle the error
            }
        }
        else {
            
            let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
            fReq.includesPropertyValues = false
            //only fetch the managedObjectID
            do{
                let result = try moc.fetch(fReq)
                
                for resultItem in result
                {
                    let countryItem: AnyObject = resultItem as AnyObject
                    moc.delete(countryItem as! NSManagedObject)
                }
                if moc.hasChanges{
                    saveContext()
                }
            }
            catch{
                print_debug(object: "===========error in Data deletion \(modelName) ===========")
            }
        }
        //print_debug("=========== Data deleted from \(modelName) ===========")
        if let completn = completion{
            completn()
        }
    })
}
func deleteModel(managedObject:NSManagedObject){
    
    moc.delete(managedObject)
    saveContext()
}
func deleteModels(managedObjects:[NSManagedObject]?){
    
    guard managedObjects != nil else {
        return
    }
    for managedObject in managedObjects! {
        moc.delete(managedObject)
    }
    saveContext()
    
}
func deleteData(modelName:String, predicate:String?,managedObjectContext:NSManagedObjectContext=moc,completion:(()->Void)? = nil)-> Bool
{
    let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    
    //Check whether predicate is there
    if (predicate != nil)
    {
        fReq.predicate = NSPredicate(format:predicate!)
    }
    let result = try! managedObjectContext.fetch(fReq)
    for resultItem in result
    {
        let countryItem: AnyObject = resultItem as AnyObject
        managedObjectContext.delete(countryItem as! NSManagedObject)
    }
    saveContext()
    if let completionn = completion{
        completionn()
    }
    return true
}
func deleteData(modelName:String, predicateValue:NSPredicate?,managedObjectContext:NSManagedObjectContext=moc,completion:(()->Void)? = nil)-> Bool
{
    
    let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    
    //Check whether predicate is there
    if (predicateValue != nil)
    {
        fReq.predicate = predicateValue!
    }
    
    let result = try! managedObjectContext.fetch(fReq)
    for resultItem in result
    {
        let countryItem: AnyObject = resultItem as AnyObject
        managedObjectContext.delete(countryItem as! NSManagedObject)
    }
    saveContext()
    if let completionn = completion{
        completionn()
    }
    return true
}
func deleteDB(deleteEntireDB:Bool = false){
    
    getMainQueue(closure: {
        
        let entityNames = managedObjectModel.entities
        for entityName in entityNames{
            
            if deleteEntireDB{
                deleteAllData(modelName: entityName.name!,completion:nil)
            }
            else if entityName.name != "SearchHistory" && entityName.name != "Language" && entityName.name != "UserData"{
                deleteAllData(modelName: entityName.name!,completion:nil)
            }
        }
        if moc.hasChanges{
            saveContext()
        }
    })
}


//MARK:- Commit/Save in Coredata
//MARK:-
func saveContext(){
    
    if moc.hasChanges{
        
        do {
            try moc.save()
            print_debug(object: "------Saved in coredata------")
        }
        catch let error as NSError {
            print_debug(object: error.description)
            //abort()
        }
    }
}

//MARK:- Fetch Data From Core Data
//MARK:-
func fetchData(modelName:String,managedObjectContext:NSManagedObjectContext=moc) -> [AnyObject]?
{
    let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    
    do {
        let result = try managedObjectContext.fetch(fReq)
        return result as [AnyObject]?
    }
    catch {
        
    }
    return nil
}
func fetchData(modelName:String, predicate:String?,managedObjectContext:NSManagedObjectContext=moc) -> [AnyObject]?
{
    let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    
    //Check whether predicate is there
    if (predicate != nil)
    {
        fReq.predicate = NSPredicate(format:predicate!)
    }
    
    do {
        let result = try managedObjectContext.fetch(fReq)
        return result as [AnyObject]?
        
    }
    catch {
        
    }
    return nil
}
func fetchData(modelName:String, predicateValue:NSPredicate?,managedObjectContext:NSManagedObjectContext=moc) -> [AnyObject]?
{
    let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    
    //Check whether predicate is there
    if (predicateValue != nil)
    {
        fReq.predicate = predicateValue!
    }
    
    do {
        let result = try managedObjectContext.fetch(fReq)
        return result as [AnyObject]?
        
    }
    catch {
        
    }
    return nil
}

func fetchData(modelName:String, predicate:String?, sort:[(sortkey:String?,isAscending:Bool)],managedObjectContext:NSManagedObjectContext=moc) -> [AnyObject]?
{
    let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
    //Check whether predicate is there
    if (predicate != nil)
    {
        fReq.predicate = NSPredicate(format:predicate!)
    }
    
    var sorterArr = [NSSortDescriptor]()
    for shortValue in sort{
        //Check whether sorting is to be applied
        if (shortValue.sortkey != nil)
        {
            let sorter: NSSortDescriptor = NSSortDescriptor(key: shortValue.sortkey! , ascending: shortValue.isAscending)
            sorterArr.append(sorter)
        }
    }
    if sorterArr.count > 0{
        fReq.sortDescriptors = sorterArr
    }
    fReq.returnsObjectsAsFaults = false
    
    
    do {
        let result = try managedObjectContext.fetch(fReq)
        return result as [AnyObject]?
        
    }
    catch {
        
    }
    return nil
    
}
