//
//  EscalationTracker.swift
//  P1Watch
//
//  Created by Grant Hulbert on 3/8/15.
//  Copyright (c) 2015 ServiceNow, Inc. All rights reserved.
//

import Foundation

public typealias IncidentRequestCompletionBlock = (content: NSArray?, error: NSError?) -> ()

public class EscalationTracker {
  
  let username = "xxxxxxxx"
  let password = "xxxxxxxx"
  let incidentURL = "https://k15apidemo.service-now.com/api/now/table/incident?sysparm_limit=10&sysparm_query=active%3Dtrue%5Epriority%3D1%5EORDERBYDESCsys_created_on"
  let bridgeURL = "https://k15apidemo-service--now-com-fejr5sb8ead6.runscope.net/api/now/import/u_urgent_incident_conf_trigger"
  let session: NSURLSession
  let defaults = NSUserDefaults.standardUserDefaults()
  public var incidents = NSArray()
  
  public init() {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    session = NSURLSession(configuration: configuration);
  }

  private func buildRequest( url:String ) -> NSMutableURLRequest {
    let loginString = NSString(format: "%@:%@", username, password)
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
    
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    return request
  }

  public func requestIncidents(completion: IncidentRequestCompletionBlock) {
    let request = buildRequest( incidentURL )

    let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        var JSONError: NSError?
        let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as NSDictionary
        if JSONError == nil {
          self.incidents = responseDict["result"] as NSArray
          if self.incidents.count > 0 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              completion(content: self.incidents, error: nil)
            })
          }
        } else {
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            completion(content: nil, error: JSONError)
          })
        }
      } else {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          completion(content: nil, error: error)
        })
      }
    })
    task.resume()
  }
  
  public func manageBridge( incidentSysID: String, action:String ) {
    let request = buildRequest( bridgeURL )
    request.HTTPMethod = "POST"

    var params = ["u_incident_sys_id":incidentSysID, "u_action":action] as Dictionary<String, String>
    
    var err: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      var JSONError: NSError?
      let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &JSONError) as NSDictionary
      if JSONError == nil {
        println( "success!" )
      } else {
        println( JSONError )
      }
    })
    task.resume()
  }
}