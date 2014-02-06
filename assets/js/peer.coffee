localUsername = null
localId = null
connectedToRTC = false


ackHandler = (msgType, msgData) ->
  console.log arguments

selectUserHander = (user) ->
  ->
    console.log "clicked - #{user.username} - #{user.id}"
    # The packet for this call can just be empty; we only need metadata
    easyrtc.sendData user.id, 'challenge', { }, ackHandler

challengeListener = (id, type, data, targeting) ->
  # For now, all challenges are accepted!
  easyrtc.sendData id, 'accepted', { }, ackHandler
  # Add game start logic here
  console.log('challenge')

acceptedListener = (id, type, data, targeting) ->
  # Add game start logic here
  console.log('accepted')

gameStateListener = (id, type, data, targeting) ->
  # Do game logic here
  console.log('gamestate')

easyrtc.setPeerListener(challengeListener, 'challenge')
easyrtc.setPeerListener(acceptedListener, 'accepted')
easyrtc.setPeerListener(gameStateListener)

easyrtc.enableDataChannels true
easyrtc.enableDebug true

socket = io.connect(document.location.origin)
socket.on "connectedUsers", (data) ->
  otherClientDiv = document.getElementById("otherClients")
  $(otherClientDiv).empty()
  for user in data.users when user.id && user.id != localId
    button = $('<a>').addClass('lobby-user')
    button.append(user.username)
    button.attr('data-id', user.id)
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