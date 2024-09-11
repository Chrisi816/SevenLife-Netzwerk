
$("document").ready(function () {
    $(".sammeln-nui").hide()
    $(".tracktor").hide()
    $(".textfarmennoraml").hide()
    $(".ausliefer").hide()
     window.addEventListener('message', function(event) {
        if (event.data.type === "openfarminghauptnui"){
             $('.sammeln-nui').fadeIn(200);
        } else if(event.data.type === "removefarminghauptnui") {
             $('.sammeln-nui').fadeOut(200);
        }
    });
})

 $(".apteil-1").click(function() {
    $(".textfarmennoraml").fadeIn(200)
    $(".tracktor").fadeOut(200)
    $(".ausliefer").fadeOut(200)
})
$(".apteil-2").click(function() {
    $(".tracktor").fadeIn(200)
    $(".textfarmennoraml").fadeOut(200)
    $(".ausliefer").fadeOut(200)
})
$(".apteil-3").click(function() {
    $(".ausliefer").fadeIn(200)
    $(".textfarmennoraml").fadeOut(200)
    $(".tracktor").fadeOut(200)
})
$(".button2").click(function() {
    $(".sammeln-nui").fadeOut(200)
    $.post('http://SevenLife_Minijob/zweitemission', JSON.stringify({}));
})
$(".button1").click(function() {
    $(".sammeln-nui").fadeOut(200)
    $.post('http://SevenLife_Minijob/erstemission', JSON.stringify({}));
})
$(".button3").click(function() {
    $(".sammeln-nui").fadeOut(200)
    $.post('http://SevenLife_Minijob/drittemission', JSON.stringify({}));
})
$(".close").click(function() {
    $(".sammeln-nui").fadeOut(200)
    $(".tracktor").hide()
    $(".textfarmennoraml").hide()
    $(".ausliefer").hide()
    $.post('http://SevenLife_Minijob/close', JSON.stringify({}));
})