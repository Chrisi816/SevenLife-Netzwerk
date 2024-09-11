$("document").ready(function () {
    $(".container").hide()
    window.addEventListener('message', function(event) {
        var msg = event.data
        if (msg.type === "OpenApothekenMenu") {
            $(".container").show()
        }
    });
 
})



$(".container").on("click", ".submitbutton", function () {
    var $button = $(this)
    $(".container").hide()
    var $type = $button.attr("types")
    var $price = $button.attr("price")
    $.post('https://SevenLife_Krankheiten/BuyItem', JSON.stringify({type : $type, price: $price }));
})
$(document).keyup(function(e) {
    if (e.key === "Escape") {
        CloseAll()
    }
});

function CloseAll(){
    $(".container").hide()
    $.post('https://SevenLife_Krankheiten/CloseMenu', JSON.stringify({}));
}

$(".close").click(function() {
    $(".container").hide()
    $.post('https://SevenLife_Krankheiten/CloseMenu', JSON.stringify({}));
})