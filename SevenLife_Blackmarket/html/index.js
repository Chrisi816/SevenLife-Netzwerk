$("document").ready(function () { 
   $(".firstcontainer").hide()
    window.addEventListener('message', function(event) {
        var msg = event.data;
        if (event.data.type === "openschwarzmarkt"){
            showtext(msg.waffe1preis, msg.waffe2preis, msg.waffe3preis)
            $("#eins").fadeIn(300)
            $("#zwei").fadeIn(600)
            $("#drei").fadeIn(1000)
        } else if(event.data.type === "removeschwarzmarkt") {
           $("#eins").fadeOut(100)
            $("#zwei").fadeOut(100)
            $("#drei").fadeOut(100)
        }
    });
    
})
function showtext(waffe1preis, waffe2preis, waffe3preis) {
    document.getElementById('preis').innerHTML = waffe1preis;
    document.getElementById('preis2').innerHTML = waffe2preis;
    document.getElementById('preis3').innerHTML = waffe3preis;
}
$("#ersterbutton").click( function () {
    $.post('http://SevenLife_Blackmarket/buttonerstewaffe', JSON.stringify({}));
})
$("#zweiterbutton").click( function () {
    $.post('http://SevenLife_Blackmarket/buttonzweitewaffe', JSON.stringify({}));
})
$("#drittebutton").click( function () {
    $.post('http://SevenLife_Blackmarket/buttondrittewaffe', JSON.stringify({}));
})