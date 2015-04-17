var express = require('express')
var app = express()

require('./snow.js')(app);

app.use(express.static('static'));

app.get('/', function (req, res) {
    res.send('index.html');
})

var server = app.listen(80, function () {

    var host = server.address().address;
    var port = server.address().port;

    console.log('Example app listening at http://%s:%s', host, port)

})
