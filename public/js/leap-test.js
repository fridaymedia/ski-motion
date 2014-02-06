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

});

var loopCallback = function (frame) {
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
};

function updateSteering(steeringVal) {
   $(document).trigger('steeringUpdated', [steeringVal]);
};