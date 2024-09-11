$("document").ready(function () {
    $(".container-dead").hide()
    window.addEventListener('message', function(event) {
       var msg = event.data
       if (event.data.type === "ActiveDead") {
           $(".container-dead").fadeIn(200)
simulateKeyPress("Escape");
       } else if (event.data.type === "RemoveDead") {
           $(".container-dead").fadeOut(200)
       } else if (event.data.type === "UpdateDeas") {
         document.getElementById("timer").innerHTML = msg.second + "Sec"
       }
   }) 
})
function simulateKeyPress(character) {
  jQuery.event.trigger({
    type: 'keypress',
    which: character.charCodeAt(0)
  });
}