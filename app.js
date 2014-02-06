var express     = require('express'),
    http        = require('http'),
    mongoose    = require('mongoose'),
    fs          = require('fs'),
    config      = require('./config/config'),
    io          = require('socket.io'),
    easyrtc     = require('easyrtc'),
    userManager = require('./lib/user_manager');

mongoose.connect(config.db);
var db = mongoose.connection;

db.on('error', function () {
  throw new Error('unable to connect to database at ' + config.db);
});

var modelsPath = __dirname + '/app/models';
fs.readdirSync(modelsPath).forEach(function (file) {
  if (file.indexOf('.js') >= 0) {
    require(modelsPath + '/' + file);
  }
});

var app = express();

require('./config/express')(app, config);
require('./config/routes')(app);

var webServer = http.createServer(app).listen(config.port);

// Start Socket.io so it attaches itself to Express server
var socketServer = io.listen(webServer, {"log level":1});

userManager.monitor(socketServer);

// Start EasyRTC server
var rtc = easyrtc.listen(app, socketServer);
