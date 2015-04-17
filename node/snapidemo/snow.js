module.exports = function (app) {
    var request = require('request'); //npm install request
    var bodyParser = require('body-parser') //npm install --save body-parser
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({
        extended: true
    }));

    var baseRequest = request.defaults({
        baseUrl: 'https://k15apidemo.service-now.com',
        auth: {
            'user': 'xxxxxx',
            'pass': 'xxxxxxx',
            'sendImmediately': true
        }
    })

    function callback(error, response, body) {
        if (!error && response.statusCode == 200) {
            return body;
        } else {
            console.log('Error from SNOW: ' + error);
            console.log('Error from SNOW: ' + JSON.stringify(body));
            return body;
        }
    }

    // Register Phone numbers
    app.post('/register', function (req, res) {
        // Get Phone number
        var from = req.body.From;

        if (!from) {
            return res.sendStatus(400);
        }
        var postBody = {
            u_phone_num: from
        }

        baseRequest({
            method: 'post',
            uri: '/api/now/import/u_attendee_phone_number_imp_ws',
            json: true,
            body: postBody
        }, function (error, response, body) {
            res.append('Content-Type','text/xml');
            body = '<?xml version="1.0" encoding="UTF-8"?><Response><Message>Thank you for registering. For demo source and docs check http://goo.gl/d9X9XH</Message></Response>';
            res.send(body);
        });
    })

    // Retrieve registered Phone numbers
    app.get('/phoneList', function (req, res) {
        baseRequest('/api/now/stats/u_session_attendees?sysparm_count=true', function (error, response, body) {
            res.send(callback(error, response, body));
        });
    })
}