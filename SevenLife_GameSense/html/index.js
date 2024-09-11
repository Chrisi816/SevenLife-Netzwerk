$("document").ready(function () {
    $(".announce-container").hide()
    $(".container").hide()
    window.addEventListener('message', function(event) {
        var msg = event.data
        if (event.data.type === "openannounce") {
            $(".container").show()
            showtimetNotification(msg.ueberschrift, msg.nachricht)
            setTimeout(function () { $(".container").hide()}, 10000);
        } else if (event.data.type === "removeannounce") {
            $(".container").hide()
        }
    })
})
function showtimetNotification(ueberschrift, nachricht) {
    document.getElementById('eins1').innerHTML = ueberschrift;
    document.getElementById('zweis').innerHTML = nachricht;
}