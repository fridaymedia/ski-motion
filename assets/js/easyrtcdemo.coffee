localUsername = null
localId = null
connectedToRTC = false


selectUserHander = (user) ->
  ->
    console.log "clicked - #{user.username} - #{user.id}"
    easyrtc.sendData user.id, 'data', { hi: "from #{localUsername}" }, (msgType, msgData) -> console.log arguments

easyrtc.enableDataChannels true
easyrtc.enableDebug true

socket = io.connect(document.location.origin)
socket.on "connectedUsers", (data) ->
  otherClientDiv = document.getElementById("otherClients")
  $(otherClientDiv).empty()
  for user in data.users when user.id && user.id != localId
    button = $('<button>').addClass('btn btn-default')
    button.append(user.username)
    button.click selectUserHander(user)

    $('#otherClients').append(button)

connect = ->
  easyrtc.connect "ski-motion", loginSuccess, loginFailure
  connectedToRTC = true

clearConnectList = ->
  otherClientDiv = document.getElementById("otherClients")
  otherClientDiv.removeChild otherClientDiv.lastChild  while otherClientDiv.hasChildNodes()

convertListToButtons = (roomName, data, isPrimary) ->
  clearConnectList()

loginSuccess = (easyrtcId) ->
  localId = easyrtcId
  document.getElementById("iam").innerHTML = "I am " + localUsername
  socket.emit 'setUsername',
    username: localUsername
    id: easyrtc.cleanId(easyrtcId)
  $('#lobby').removeClass('hidden')
  $('#user-form').hide()

loginFailure = (errorCode, message) ->
  easyrtc.showError errorCode, message

connectClickHander = (event) ->
  localUsername = $('#name').val()
  connect() unless connectedToRTC

$ ->
  $('#connect').click connectClickHander