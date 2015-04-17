//
//  IncidentTableViewController.swift
//  P1Watch
//
//  Created by Grant Hulbert on 3/23/15.
//  Copyright (c) 2015 ServiceNow, Inc. All rights reserved.
//

import Foundation
import UIKit

class IncidentTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
  
  var updating = false
  let incidentRequester = EscalationTracker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //  set up pull-to-refresh
    var refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: Selector("refreshIncidents"), forControlEvents: UIControlEvents.ValueChanged)
    self.refreshControl = refreshControl
    
    //  initial query of incidents
    refreshIncidents()
  }
  
  func refreshIncidents() {
    incidentRequester.requestIncidents { (content, error) -> () in
      if error == nil {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
      }
      self.updating = false
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return incidentRequester.incidents.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel?.text = incidentRequester.incidents[indexPath.row]["short_description"] as NSString
    cell.detailTextLabel?.text = incidentRequester.incidents[indexPath.row]["number"] as NSString
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("incidentDetail", sender: tableView)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "incidentDetail" {
      let incidentDetailViewController = segue.destinationViewController as IncidentDetailViewController
      let indexPath = self.tableView.indexPathForSelectedRow()!
      let destinationTitle = self.incidentRequester.incidents[indexPath.row]["number"] as String
      let incidentSysID = self.incidentRequester.incidents[indexPath.row]["sys_id"] as String
      incidentDetailViewController.title = destinationTitle
      incidentDetailViewController.setIncident( self.incidentRequester.incidents[indexPath.row] as NSDictionary )
    }
  }
}
