localUsername = null
localId = null
connectedToRTC = false

socket = io.connect(document.location.origin)
socket.on "connectedUsers", (data) ->
  otherClientDiv = document.getElementById("otherClients")
  $(otherClientDiv).empty()
  for user in data.users when user.id && user.id != localId
    button = document.createElement("button")
    button.onclick = ((easyrtcid) ->
      # Do stuff
    )(user.id)
    label = document.createTextNode(user.username)
    button.appendChild label
    otherClientDiv.appendChild button

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