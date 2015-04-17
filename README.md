# ServiceNow K15 API Demo
This project contains source code for the ServiceNow K15 breakout session titled **[Enabling Web API Integrations with ServiceNow](https://knowledge.servicenowevents.com/connect/sessionDetail.ww?SESSION_ID=1283)**.

Speakers
* **[Bryan Barnard](https://github.com/bryanbarnard)** ([@nardbard](https://twitter.com/nardbard)), Integrations Product Manager at ServiceNow
* **[Silas Smith](https://github.com/codersmith)**, Senior Software Engineer at ServiceNow
* **[Venkata Koya](https://github.com/kvkk)**, Senior Software Engineer at ServiceNow

Special thanks to **[Grant Hulbert](https://community.servicenow.com/people/grant.hulbert)** ([@VoiceOfSoftware](https://twitter.com/VoiceOfSoftware)) for assisting in the demo preparation.

## Architecture
Here is an overview of the demo architecture.
![Demo architecture diagram](/images/demo_diagram.jpg "Demo architecture diagram")

## Components
The demo consists of:
* [A ServiceNow instance](#servicenow-instance)
* [A Twilio configuration](#twilio-configuration)
* [A Node.js web application](#nodejs-web-application)
* [iOS applications](#ios-applications)

--------------------------------------------------------------------------
### [ServiceNow](http://www.servicenow.com/) instance
![ServiceNow logo](/images/servicenow-logo.jpg)

The ServiceNow instance is configured with one table to store participant phone numbers, and two Import Set web services to handle registering participants and triggering the bridge.

| Component | Table | Description |
| ----------|-------|------------ |
| Session Participants | `u_session_attendees` | Stores the registered phone numbers |
| Session Participants Import Set Web Service | `u_attendee_phone_number_imp_ws` | Registers a phone number |
| Urgent Incident Conf Trigger Import Set Web Service | `u_urgent_incident_conf_trigger` | Triggers opening a bridge from a transform script |

The update set with these components can be found [here](/servicenow/K15_API_DEMO_UpdateSet.xml).

Additionally, [Notify API](http://wiki.servicenow.com/index.php?title=Notify) properties are configured as:
![NotifyNow configuration](/images/notify_config.jpg "NotifyNow configuration")

--------------------------------------------------------------------------
### [Twilio](https://www.twilio.com/) configuration
![Twilio logo](/images/twilio-logo.jpg)

Twilio is configured to forward SMS messages received at the register phone number (312-313-1772) to the registration endpoint served by the [Node.js app](#nodejs-web-application).

![Twilio registration configuration](/images/twilio_register_config.jpg "Twilio registration configuration")

Additionally a separate Twilio number (312-488-1677) is configured to act as the bridge line -- this is the line from which calls and texts about the bridge are sent to participants.

![Twilio bridge configuration](/images/twilio_bridge_config.jpg "Twilio bridge configuration")

--------------------------------------------------------------------------
### [Node.js](https://nodejs.org/) web application
![Node.js logo](/images/nodejs-logo.jpg)

The Node.js application source code can be found [here](/node/snapidemo).

This app can be hosted on any server capable of running Node.js applications (for this demo we used a VM provided by [Digital Ocean](https://www.digitalocean.com/)).

The app consists of a `/register` endpoint which proxies the incoming message from Twilio to ServiceNow using the [Import Set API](http://wiki.servicenow.com/index.php?title=Import_Set_API).

It also contains an index page to display the registration info and current count of participants, which uses the ServiceNow [Aggregate API](http://wiki.servicenow.com/index.php?title=Aggregate_API) to retrieve the count from the `u_session_attendees` table.

![Registration page](/images/node_view.jpg "Registration page")

--------------------------------------------------------------------------
### [iOS](https://developer.apple.com/devcenter/ios/) applications
![iOS logo](/images/ios-logo.jpg)

The iOS apps consist of an iPhone app and a Watch app which retrieve the most recent P1 incidents, and can trigger a bridge for the incidents.

They use the ServiceNow [Table API](http://wiki.servicenow.com/index.php?title=Table_API) to retrieve the P1 incidents, and the [Import Set API](http://wiki.servicenow.com/index.php?title=Import_Set_API) to trigger opening a bridge for an incident. The Import Set Transform Map is configured with a transform script that uses ServiceNow's [Notify API](http://wiki.servicenow.com/index.php?title=Notify) to open a bridge through Twilio.

The source code for the apps can be found [here](/xcode).
