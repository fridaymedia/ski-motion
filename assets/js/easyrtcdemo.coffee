connect = ->
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
  selfEasyrtcid = easyrtcId
  document.getElementById("iam").innerHTML = "I am " + easyrtc.cleanId(easyrtcId)

loginFailure = (errorCode, message) ->
  easyrtc.showError errorCode, message

selfEasyrtcid = ""

$ ->
  connect()