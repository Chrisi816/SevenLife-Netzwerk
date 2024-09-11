$("document").ready(function () {
    $(".kaufvertrag-body").hide()
    $(".abfrage").hide()
    window.addEventListener('message', function(event) {
        var msg = event.data
        if (event.data.type === "openverkauf") {
            $(".abfrage").show()
        }
    });
    
})
$(document).keyup(function(e) {
    if (e.key === "Escape") {
        CloseAll()
    }
});
function CloseAll() {
    $(".kaufvertrag-body").hide()
    $(".abfrage").hide()
    $.post('http://SevenLife_Verkauf/CloseMenu', JSON.stringify({}));
}