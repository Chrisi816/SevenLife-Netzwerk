$("document").ready(function () {
    $(".aussen-container").hide()
    $(".nachricht").hide()
    window.addEventListener('message', function(event) {
var msg = event.data
        if (event.data.type === "openfahrzeug"){

            $(".aussen-container").show()
        } else if(event.data.type === "removefahrzeug") {
            $(".aussen-container").fadeOut(300)
        }
        if (event.data.type === "openmelde"){
            $(".nachricht").show()
            showtimetNotification(msg.ueberschrift, msg.nachricht)
        } else if(event.data.type === "removemelde") {
            $(".nachricht").fadeOut(300)
        }
    });
    
})
function showtimetNotification(ueberschrift, nachricht) {
    document.getElementById('eins').innerHTML = ueberschrift;
    document.getElementById('zwei').innerHTML = nachricht;
}
$(".close").click(function() {
    $.post('http://SevenLife_CarThief/fahrzeugraus', JSON.stringify({}));
})
$("#leicht").click(function() {
    $.post('http://SevenLife_CarThief/leicht', JSON.stringify({}));
})
$("#mittel").click(function() {
    $.post('http://SevenLife_CarThief/mittel', JSON.stringify({}));
})
$("#schwer").click(function() {
    $.post('http://SevenLife_CarThief/schwer', JSON.stringify({}));
})