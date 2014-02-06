var connectedUsers = [];

var createUserHash = function(socket){
  return { username: '', id: '' }
}

var monitor = function(socketServer) {
  socketServer = socketServer;

  socketServer.sockets.on('connection', function (socket) {
    console.log('User connected');
    userData = createUserHash(socket)
    connectedUsers.push(userData);

    socket.set('userData', userData, function () {
      socket.emit('ready');
    })

    socket.emit('connectedUsers', { users: connectedUsers });

    socket.on('setUsername', function (data) {
      socket.get('userData', function(err, userData) {
        userData.username = data.username;
        userData.id = data.id;
        console.log("username updated - %o", data);
        socket.broadcast.emit('connectedUsers', { users: connectedUsers });
        socket.emit('connectedUsers', { users: connectedUsers });
      });
    });

    socket.on('disconnect', function() {
      socketServer.sockets.emit('user disconnected');
      socket.get('userData', function(err, userData) {
        console.log('user disconnected - ' + userData.username);
        connectedUsers.splice(connectedUsers.indexOf(userData), 1);
        socket.broadcast.emit('connectedUsers', { users: connectedUsers });
      });
    });
  });
}

module.exports.monitor = monitor;
