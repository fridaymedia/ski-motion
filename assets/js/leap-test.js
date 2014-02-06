var currentSteeringHand = 0;
var FAR_LEFT_ROLL = 1;
var FAR_RIGHT_ROLL = -1;
var CENTRE_ROLL = 0;
var MIN_HAND_VISIBLE_TIME = 0.15;

$(function () {

   // Setup Leap loop with frame callback function
   var controllerOptions = { enableGestures: false };

   Leap.loop(controllerOptions, loopCallback);

   $(document).on('steeringUpdated', function (event, value) {
      var frameOutput = document.getElementById("frameData");
      frameOutput.innerHTML = "Steering: " + value;
   });

   var sampleLobbyUsers = [{ name: "Test 1", id: "1234-456-789" }, { name: "Test 2", id: "abcd-efg-hijk" }];

   generateLobby(sampleLobbyUsers);

});

function generateLobby(lobbyUsers) {
   for (var i = 0; i < lobbyUsers.length; i++) {
      var item = $("<a class='lobby-user' data='" + lobbyUsers[i].id + "'>");
	  item.html(lobbyUsers[i].name);

      item.appendTo('#lobby');
   }
}

var loopCallback = function (frame) {
   d3.selectAll(".cursor").remove();
   $('.lobby-user').css("background-color", "");

   if (frame.pointables.length > 0) {
      frame.pointables.forEach(function (pointable, i) {
         if (i > 0)
            return;

         var width = $(window).width();
         var height = $(window).height();

         // interaction box
         var pos = [
           width / 2 + 6 * pointable.tipPosition[0],
           height - 4 * pointable.tipPosition[1] + 150,
           pointable.tipPosition[2]
         ];

           var element = document.elementFromPoint(pos[0], pos[1]);
           if (element != null && $(element).attr('class') === 'lobby-user')
            {   
              //alert($(element).attr("data"));
              $(element).css("background-color", "green");
            }

         // visual cursor
         var cursor = d3.select("body")
           .append("div")
           .attr("class", "cursor")
           .style({
              top: pos[1] + "px",
              left: pos[0] + "px"
           })
      });
   }

   if (frame.hands.length > 0) {
      for (var i = 0; i < frame.hands.length; i++) {
         var hand = frame.hands[i];

         // Has this hand been around for a bit?
         if (!hand.valid || hand.timeVisible < MIN_HAND_VISIBLE_TIME)
            continue;

         // Make sure we don't get distracted by other hands
         if (currentSteeringHand == 0)
            currentSteeringHand = hand.id;
         else if (currentSteeringHand != hand.id)
            continue;

         // Clean up the steering value before we pass it along
         var steeringVal = hand.roll();
         if (steeringVal < FAR_RIGHT_ROLL)
            steeringVal = FAR_RIGHT_ROLL;
         else if (steeringVal > FAR_LEFT_ROLL)
            steeringVal = FAR_LEFT_ROLL;

         updateSteering(steeringVal);
      }
   }
   else {
      // No more hands; reset our counter
      currentSteeringHand = 0;
      updateSteering(CENTRE_ROLL);
   }

     // Display Gesture object data
  var gestureOutput = document.getElementById("frameData");
  var gestureString = "";
  if (frame.gestures.length > 0) {

    for (var i = 0; i < frame.gestures.length; i++) {
      var gesture = frame.gestures[i];
      gestureString += "gesture id: " + gesture.id + ", "
                    + "type: " + gesture.type + ", "
                    + "state: " + gesture.state + ", "
                    + "hand ids: " + gesture.handIds.join(", ") + ", "
                    + "pointable ids: " + gesture.pointableIds.join(", ") + ", "
                    + "duration: " + gesture.duration + " &micro;s, ";

      switch (gesture.type) {
        case "circle":
        case "swipe":
        case "screenTap":
          gestureString += "No thanks!";
          break;
        case "keyTap":
          gestureString += "position: " + vectorToString(gesture.position) + " mm, "
                        + "direction: " + vectorToString(gesture.direction, 2);
          break;
        default:
          gestureString += "unkown gesture type";
      }
      gestureString += "<br />";
    }
  }
  else {
    gestureString += gestureOutput.innerHTML;
  }
  gestureOutput.innerHTML = gestureString;
};

function updateSteering(steeringVal) {
   $(document).trigger('steeringUpdated', [steeringVal]);
};

function vectorToString(vector, digits) {
  if (typeof digits === "undefined") {
    digits = 1;
  }
  return "(" + vector[0].toFixed(digits) + ", "
             + vector[1].toFixed(digits) + ", "
             + vector[2].toFixed(digits) + ")";
}