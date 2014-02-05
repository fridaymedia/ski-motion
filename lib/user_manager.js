var connectedUsers = [];

var monitor = function(socketServer) {
  socketServer = socketServer;

  socketServer.sockets.on('connection', function (socket) {
    console.log('User connected');

    socket.emit('connectedUsers', { users: connectedUsers });

    socket.on('disconnect', function() {
      socketServer.sockets.emit('user disconnected');
      console.log('user disconnected');
    });
  });
}

module.exports.monitor = monitor;
