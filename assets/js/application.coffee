#= require ../components/jquery/jquery
#= require ../components/leapjs/leap
#= require ../components/socket.io-client/dist/socket.io
#= require easyrtc
#= require easyrtcdemo

socket = io.connect("http://localhost")
socket.on "news", (data) ->
  console.log data
  socket.emit "my other event",
    my: "data"


