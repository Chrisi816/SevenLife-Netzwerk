$("document").ready(function () {
    $(".auszahlen-card").hide()
    $(".überweisen-card").hide()
    $(".normalbank").hide()
     window.addEventListener('message', function(event) {
         var msg = event.data
         if (event.data.type === "OpenNormalBank"){
            $(".normalbank").fadeIn(1000)
            document.getElementById("guthaben").innerHTML = msg.bankmoney + "$"
            document.getElementById("iban-nummer").innerHTML = msg.iban
            document.getElementById("name").innerHTML = msg.firstname
          
            if (msg.bankcard === 1) {
                document.getElementById("textsteuern").innerHTML = "Transaktions Gebühren: 10%"
            } else if(msg.bankcard === 2) {
                document.getElementById("textsteuern").innerHTML = "Transaktions Gebühren: 5%"
            }else if (msg.bankcard === 3) {
                document.getElementById("textsteuern").innerHTML = "Transaktions Gebühren: 1%"
            } 
         }
     });
})
$(".einzahlen").click(function(){
    $(".einzahlen-card").show()
    $(".auszahlen-card").hide()
    $(".überweisen-card").hide()
})
$(".auszahlen").click(function(){
    $(".einzahlen-card").hide()
    $(".auszahlen-card").show()
    $(".überweisen-card").hide()
})
$(".überweisungen").click(function(){
    $(".einzahlen-card").hide()
    $(".auszahlen-card").hide()
    $(".überweisen-card").show()
})
$(document).keyup(function(e) {
    if (e.key === "Escape") {
        $(".normalbank").fadeOut(300)
        $.post('http://SevenLife_Bank/CloseBank', JSON.stringify({}));
    }
});
$(".einzahlenbutton").click(function() {
    var geldeinzahl = document.getElementById("einzahlengeldinputt").value
    $.post('http://SevenLife_Bank/transaktion', JSON.stringify({type : "einzahlen", geld : geldeinzahl}));
})
$(".auszahlbutton").click(function() {
    var geldeinzahl = document.getElementById("auszahlinputt").value
    $.post('http://SevenLife_Bank/transaktion', JSON.stringify({type : "auszahlen", geld : geldeinzahl}));
})