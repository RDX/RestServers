
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , comm = require('C4Communicator');

var app = require('express').createServer()
  , io = require('socket.io').listen(app);

comm.createClient("127.0.0.1");
	

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.static(__dirname + '/public'));
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  var oneYear = 31557600000;
  app.use(express.static(__dirname + '/public', { maxAge: oneYear }));
  app.use(express.errorHandler()); 
});

// Routes

app.get('/', routes.index);

var chat = io
  .of('/chat')
  .on('connection', function (socket) {
    socket.emit('a message', {
        that: 'only'
      , '/chat': 'will get'
    });
    chat.emit('a message', {
        everyone: 'in'
      , '/chat': 'will get'
    });
  });

var news = io
  .of('/news')
  .on('connection', function (socket) {
    socket.emit('item', { news: 'item' });
  });

  

app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
