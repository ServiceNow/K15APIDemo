//
//  IncidentDetailViewController.swift
//  P1Watch
//
//  Created by Grant Hulbert on 3/23/15.
//  Copyright (c) 2015 ServiceNow, Inc. All rights reserved.
//

import UIKit

public class IncidentDetailViewController: UIViewController {

  let bridgeCreator = EscalationTracker()

  var incidentDetails = NSDictionary()
  var incidentSysID = ""
  
  @IBOutlet weak var incidentNumberLabel: UILabel!
  @IBOutlet weak var shortDescriptionLabel: UILabel!

  @IBAction func openBridge(sender: AnyObject) {
    bridgeCreator.manageBridge( incidentSysID, action:"open" )
  }

  public override func viewDidLoad() {
    incidentNumberLabel?.text = incidentDetails["number"] as? String
    shortDescriptionLabel?.text = incidentDetails["short_description"] as? String
  }

  public func setIncident( incidentDetails: NSDictionary ) {
    self.incidentDetails = incidentDetails
    self.incidentSysID = incidentDetails["sys_id"] as String
  }
}
