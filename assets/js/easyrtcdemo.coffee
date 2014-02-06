localUsername = ''
connectedToRTC = false

socket = io.connect(document.location.origin)
socket.on "connectedUsers", (data) ->
  console.table data.users

connect = ->
  connectedToRTC = true
  easyrtc.setRoomOccupantListener convertListToButtons
  easyrtc.easyApp "easyrtc.audioVideo", "selfVideo", ["callerVideo"], loginSuccess, loginFailure

clearConnectList = ->
  otherClientDiv = document.getElementById("otherClients")
  otherClientDiv.removeChild otherClientDiv.lastChild  while otherClientDiv.hasChildNodes()

convertListToButtons = (roomName, data, isPrimary) ->
  clearConnectList()
  otherClientDiv = document.getElementById("otherClients")
  for easyrtcid of data
    button = document.createElement("button")
    button.onclick = ((easyrtcid) ->
      -> performCall easyrtcid
    )(easyrtcid)
    label = document.createTextNode(easyrtc.idToName(easyrtcid))
    button.appendChild label
    otherClientDiv.appendChild button

performCall = (otherEasyrtcid) ->
  easyrtc.hangupAll()
  successCB = ->
  failureCB = ->

  easyrtc.call otherEasyrtcid, successCB, failureCB

loginSuccess = (easyrtcId) ->
  localId = easyrtcId
  document.getElementById("iam").innerHTML = "I am " + easyrtc.cleanId(easyrtcId)
  socket.emit 'setUsername',
    username: localUsername
    id: easyrtc.cleanId(easyrtcId)

loginFailure = (errorCode, message) ->
  easyrtc.showError errorCode, message

connectClickHander = (event) ->
  localUsername = $('#name').val()
  connect() unless connectedToRTC

$ ->
  $('#connect').click connectClickHander