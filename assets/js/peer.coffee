localUsername = null
localId = null
connectedToRTC = false

ackHandler = (msgType, msgData) ->
  console.log arguments

selectUserHander = (user) ->
  ->
    console.log "clicked - #{user.username} - #{user.id}"
    me = new ski.Player(localId, localUsername)
    easyrtc.sendData user.id, 'challenge', me, ackHandler

challengeListener = (id, type, data, targeting) ->
  # For now, all challenges are accepted!
  me = new ski.Player(localId, localUsername)

  easyrtc.sendData id, 'accepted', me, ackHandler
  console.log('challenge from ' + data.userName + ' accepted!')

  ski.initialiseGame(me, data);

acceptedListener = (id, type, data, targeting) ->
  # Add game start logic here
  console.log('challenge made to ' + data.userName + ' accepted!')
  me = new ski.Player(localId, localUsername)

  ski.initialiseGame(me, data);

  easyrtc.sendData id, 'gamestate', me, ackHandler

sendGameState = () ->

  easyrtc.sendData ski.currentGame.opponent.id, 'gamestate', ski.currentGame.me, ackHandler

gameStateListener = (id, type, data, targeting) ->
  ski.currentGame.opponent = data
  setTimeout(sendGameState, 50)

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