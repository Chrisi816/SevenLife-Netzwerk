var chrisi = 0
var maxval 
var colorid

$("document").ready(function () {
    $(".hauptbildschirm").hide()
    $(".einstellungenapp").hide()
    $(".notify").hide()
    $(".computerframe").hide()
    $(".maskshop").hide()
    $(".earpage").hide()
    $(".Brillenpage").hide()
    $(".uhrenpage").hide()
    $(".kettepage").hide()
    window.addEventListener('message', function(event) {
        var msg = event.data
        if (event.data.type === "openmenujewellery"){
            console.log("hey")
            $(".computerframe").show()
        } else if(event.data.type === "removemenujewellery") {
            $(".computerframe").fadeOut(300)
        } else if (event.data.type === "SendJuweliers") {
            $(".maskshop").fadeIn(200)
            $(".mainpage").show()
            $(".Brillenpage").hide()
            $(".earpage").hide()
            $(".uhrenpage").hide()
            $(".kettepage").hide()
            document.getElementById("availeble1").innerHTML = "0 / " + msg.glasses_1
            document.getElementById("availeble2").innerHTML = "0 / " + msg.ear1
            document.getElementById("availeble3").innerHTML = "0 / " + msg.decals_1
            document.getElementById("availeble5").innerHTML = "0 / " + msg.chain_1
        } else if (msg.type === "SendJuweliersOpenGlasses") {
            $(".mainpage").hide()
            $(".Brillenpage").show()
            document.getElementById("artikelnummer").innerHTML = 0
            document.getElementById("artikelnummer2").innerHTML = 0
            maxval = msg.glasses_1
            colorid = msg.glasses_2
        } else if (msg.type === "ColorId") {
            colorid = msg.glasses_2
        } else if (msg.type === "ColorId1") {
            colorid1 = msg.colorid
        } else if (msg.type === "SendJuweliersOpenEars") {
            maxval1 = msg.ear1
            colorid1 = msg.ear2
            document.getElementById("artikelnummer1").innerHTML = 0
            document.getElementById("artikelnummer21").innerHTML = 0
            $(".mainpage").hide()
            $(".earpage").show()
        } else if (msg.type === "SendJuweliersOpenDecals") {
            maxval2 = msg.decals_1
            colorid2 = msg.decals_2
            document.getElementById("artikelnummer12").innerHTML = 0
            document.getElementById("artikelnummer22").innerHTML = 0
            $(".mainpage").hide()
            $(".uhrenpage").show()
        } else if (msg.type === "SendJuweliersOpenChain") {
            maxval3 = msg.chain_1
            colorid3 = msg.chain_2
            document.getElementById("artikelnummer111").innerHTML = 0
            document.getElementById("artikelnummer211").innerHTML = 0
            $(".mainpage").hide()
            $(".kettepage").show()
        }else if (msg.type === "ColorId2") {
            colorid2 = msg.colorid
        } else if (msg.type === "ColorId3") {
            colorid3 = msg.colorid
        } 
    });
    
})

document.getElementById("submitbutton").onclick = function() {
    var password = document.getElementById("inputt").value
    console.log(password)
    if (password == "") {
        $(".login").fadeOut(100)
        $(".inputs").fadeOut(100)
        $(".hauptbildschirm").fadeIn(300)
    } else  {
        $(".notify").fadeIn(300)
        timout = window.setTimeout(clearalert, 3000)
    }
}

function clearalert() {
    $(".notify").fadeOut(200)
    window.clearTimeout(timout)
}

document.getElementById("logoap").onclick = function () {
    $(".einstellungenapp").fadeIn(200)
    $(".hauptbildschirm").hide()
}
document.getElementById("kasten").onclick = function () {
    $(".einstellungenapp").hide()
    $(".hauptbildschirm").fadeIn(200)
}

$("#buttonit").click(function () {
    $.post('http://SevenLife_Juwelleryrob/buttonraus', JSON.stringify({}));
})
$("#buttonhell").click(function () {
    $.post('http://SevenLife_Juwelleryrob/buttonueberweis', JSON.stringify({}));
}) 
$("#buttons").click(function () {
    $.post('http://SevenLife_Juwelleryrob/buttonalarmaus', JSON.stringify({}));
}) 

$(document).keyup(function(e) {
    if (e.key === "Escape") {
        CloseAll()
    }
});

function CloseAll(){
    $(".maskshop").hide()
    $.post('http://SevenLife_Juwelleryrob/CloseMenu', JSON.stringify({}));
}

$("#brillen").click(function() {
    chrisi = 1
    $.post('http://SevenLife_Juwelleryrob/GetPageOpen', JSON.stringify({chrisi : chrisi}));
})
$("#ear").click(function() {
    chrisi = 2
    $.post('http://SevenLife_Juwelleryrob/GetPageOpen', JSON.stringify({chrisi : chrisi}));
})
$("#brecelet").click(function() {
    chrisi = 3
    $.post('http://SevenLife_Juwelleryrob/GetPageOpen', JSON.stringify({chrisi : chrisi}));
})
$("#katte").click(function() {
    chrisi = 4
    $.post('http://SevenLife_Juwelleryrob/GetPageOpen', JSON.stringify({chrisi : chrisi}));
})

$(".button-lagerleft1").click(function() {
    var value = $("#artikelnummer").text()
    var values = parseInt(value)
    if (values < 0){
        document.getElementById("artikelnummer").innerHTML = maxval
    } else {
        document.getElementById("artikelnummer").innerHTML = values - 1
    }

    var endvalue2 =  $("#artikelnummer").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle', JSON.stringify({endvalue1 : endvalue2}));
})

$(".button-lagerright1").click(function() {
    var value1 =  $("#artikelnummer").text()
    var value2 = parseInt(value1)
    if (value1 > maxval) {
        document.getElementById("artikelnummer").innerHTML = 0
    } else {
        document.getElementById("artikelnummer").innerHTML = value2 + 1
    }

    var endvalue1 =  $("#artikelnummer").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle', JSON.stringify({endvalue1 : endvalue1}));
})

$(".button-lagerleft2").click(function() {
    var value = $("#artikelnummer2").text()
    var values = parseInt(value)
    if ( values < 0){
        document.getElementById("artikelnummer2").innerHTML = colorid
    } else {
        document.getElementById("artikelnummer2").innerHTML = values - 1
    }

    var endvalue2 = $("#artikelnummer2").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle2', JSON.stringify({endvalue2 : endvalue2}));
})

$(".button-lagerright2").click(function() {
    var value1 = $("#artikelnummer2").text()
    var value2 = parseInt(value1)
    if (value1 > colorid) {
        document.getElementById("artikelnummer2").innerHTML = 0
    } else {
        document.getElementById("artikelnummer2").innerHTML = value2 + 1
    }

    var endvalue1 = $("#artikelnummer2").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle2', JSON.stringify({endvalue2 : endvalue1}));
})

// Ears

$(".button-lagerleft11").click(function() {
    var value = $("#artikelnummer1").text()
    var values = parseInt(value)
    if (values < 0){
        document.getElementById("artikelnummer1").innerHTML = maxval1
    } else {
        document.getElementById("artikelnummer1").innerHTML = values - 1
    }

    var endvalue2 =  $("#artikelnummer1").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle1', JSON.stringify({endvalue1 : endvalue2}));
})

$(".button-lagerright11").click(function() {
    var value1 =  $("#artikelnummer1").text()
    var value2 = parseInt(value1)
    if (value1 > maxval1) {
        document.getElementById("artikelnummer1").innerHTML = 0
    } else {
        document.getElementById("artikelnummer1").innerHTML = value2 + 1
    }

    var endvalue1 =  $("#artikelnummer1").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle1', JSON.stringify({endvalue1 : endvalue1}));
})




$(".button-lagerleft21").click(function() {
    var value = $("#artikelnummer21").text()
    var values = parseInt(value)
    if ( values < 0){
        document.getElementById("artikelnummer21").innerHTML = colorid1
    } else {
        document.getElementById("artikelnummer21").innerHTML = values - 1
    }

    var endvalue2 = $("#artikelnummer21").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle21', JSON.stringify({endvalue2 : endvalue2}));
})

$(".button-lagerright21").click(function() {
    var value1 = $("#artikelnummer21").text()
    var value2 = parseInt(value1)
    if (value1 > colorid1) {
        document.getElementById("artikelnummer21").innerHTML = 0
    } else {
        document.getElementById("artikelnummer21").innerHTML = value2 + 1
    }

    var endvalue1 = $("#artikelnummer21").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle21', JSON.stringify({endvalue2 : endvalue1}));
})

// Uhren

$(".button-lagerleft12").click(function() {
    var value = $("#artikelnummer12").text()
    var values = parseInt(value)
    if (values < 0){
        document.getElementById("artikelnummer12").innerHTML = maxval2
    } else {
        document.getElementById("artikelnummer12").innerHTML = values - 1
    }

    var endvalue2 =  $("#artikelnummer12").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle12', JSON.stringify({endvalue1 : endvalue2}));
})

$(".button-lagerright12").click(function() {
    var value1 =  $("#artikelnummer12").text()
    var value2 = parseInt(value1)
    if (value1 > maxval2) {
        document.getElementById("artikelnummer12").innerHTML = 0
    } else {
        document.getElementById("artikelnummer12").innerHTML = value2 + 1
    }

    var endvalue1 =  $("#artikelnummer12").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle12', JSON.stringify({endvalue1 : endvalue1}));
})

$(".button-lagerleft22").click(function() {
    var value = $("#artikelnummer22").text()
    var values = parseInt(value)
    if ( values < 0){
        document.getElementById("artikelnummer22").innerHTML = colorid2
    } else {
        document.getElementById("artikelnummer22").innerHTML = values - 1
    }

    var endvalue2 = $("#artikelnummer22").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle22', JSON.stringify({endvalue2 : endvalue2}));
})

$(".button-lagerright22").click(function() {
    var value1 = $("#artikelnummer22").text()
    var value2 = parseInt(value1)
    if (value1 > colorid2) {
        document.getElementById("artikelnummer22").innerHTML = 0
    } else {
        document.getElementById("artikelnummer22").innerHTML = value2 + 1
    }

    var endvalue1 = $("#artikelnummer22").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle22', JSON.stringify({endvalue2 : endvalue1}));
})

// Kette

$(".button-lagerleft13").click(function() {
    var value = $("#artikelnummer111").text()
    var values = parseInt(value)
    if (values < 0){
        document.getElementById("artikelnummer111").innerHTML = maxval3
    } else {
        document.getElementById("artikelnummer111").innerHTML = values - 1
    }

    var endvalue2 =  $("#artikelnummer111").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle13', JSON.stringify({endvalue1 : endvalue2}));
})

$(".button-lagerright13").click(function() {
    var value1 =  $("#artikelnummer111").text()
    var value2 = parseInt(value1)
    if (value1 > maxval3) {
        document.getElementById("artikelnummer111").innerHTML = 0
    } else {
        document.getElementById("artikelnummer111").innerHTML = value2 + 1
    }

    var endvalue1 =  $("#artikelnummer111").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle13', JSON.stringify({endvalue1 : endvalue1}));
})

$(".button-lagerleft23").click(function() {
    var value = $("#artikelnummer211").text()
    var values = parseInt(value)
    if ( values < 0){
        document.getElementById("artikelnummer211").innerHTML = colorid3
    } else {
        document.getElementById("artikelnummer211").innerHTML = values - 1
    }

    var endvalue2 = $("#artikelnummer211").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle23', JSON.stringify({endvalue2 : endvalue2}));
})

$(".button-lagerright23").click(function() {
    var value1 = $("#artikelnummer211").text()
    var value2 = parseInt(value1)
    if (value1 > colorid3) {
        document.getElementById("artikelnummer211").innerHTML = 0
    } else {
        document.getElementById("artikelnummer211").innerHTML = value2 + 1
    }

    var endvalue1 = $("#artikelnummer211").text()
    $.post('http://SevenLife_Juwelleryrob/MakeArticle23', JSON.stringify({endvalue2 : endvalue1}));
})


// Buttons

$(".button-lager").click(function() {
    var endvalue1 =  $("#artikelnummer").text()
    var endvalue2 = $("#artikelnummer2").text()
    $(".maskshop").hide()
    $.post('http://SevenLife_Juwelleryrob/BuyProdukt1', JSON.stringify({value1 : endvalue1, value2 : endvalue2 }));
})

$(".button-lager1").click(function() {
    var endvalue1 =  $("#artikelnummer1").text()
    var endvalue2 = $("#artikelnummer21").text()
    $(".maskshop").hide()
    $.post('http://SevenLife_Juwelleryrob/BuyProdukt11', JSON.stringify({value1 : endvalue1, value2 : endvalue2 }));
})

$(".button-lager2").click(function() {
    var endvalue1 =  $("#artikelnummer12").text()
    var endvalue2 = $("#artikelnummer22").text()
    $(".maskshop").hide()
    $.post('http://SevenLife_Juwelleryrob/BuyProdukt12', JSON.stringify({value1 : endvalue1, value2 : endvalue2 }));
})

$(".button-lager3").click(function() {
    var endvalue1 =  $("#artikelnummer111").text()
    var endvalue2 = $("#artikelnummer211").text()
    $(".maskshop").hide()
    $.post('http://SevenLife_Juwelleryrob/BuyProdukt13', JSON.stringify({value1 : endvalue1, value2 : endvalue2 }));
})