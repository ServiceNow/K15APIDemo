//
//  InterfaceController.swift
//  P1Watch WatchKit Extension
//
//  Created by Grant Hulbert on 3/8/15.
//  Copyright (c) 2015 ServiceNow, Inc. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
  
  let incidentRequester = EscalationTracker()
  var updating = false
  var incidentList = NSArray()
  
  @IBOutlet weak var priceLabel: WKInterfaceLabel!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here.
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    update()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  private func updateContent(content: NSArray) {
    priceLabel.setText(content[0]["short_description"] as NSString)
  }
  
  private func update() {
    if !updating {
      updating = true
      incidentRequester.requestIncidents { (content, error) -> () in
        if error == nil {
          self.updateContent(content!)
          self.incidentList = content!
        }
        self.updating = false
      }
    }
  }
  
  @IBAction func refreshTapped() {
    update()
  }
  
  @IBAction func bridgeTapped() {
    if incidentList.count > 0 {
      incidentRequester.manageBridge( incidentList[0]["sys_id"] as NSString, action:"open" )
    }
  }
  
  @IBAction func closeBridge() {
    if incidentList.count > 0 {
      incidentRequester.manageBridge( incidentList[0]["sys_id"] as NSString, action:"kick" )
    }
  }
}
