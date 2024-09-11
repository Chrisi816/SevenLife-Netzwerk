// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Start Script------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

$("document").ready(function () {
    $(".shop-container").hide()
    $(".shop-normal").hide()
    $(".shop-übergang").hide()
   // $(".buttons").hide()
     window.addEventListener('message', function(event) {
         var msg = event.data
         if (event.data.type === "opencarshops"){
            $(".shop-container").show("slow")
            displaycarshops(msg.cars)
            pasting(msg.heandler, msg.nachrichteins)
         } else if(event.data.type === "removecarshops") {
            $(".shop-container").hide("slow")
         }
     });
})

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Pasting Stuff-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

function pasting(händler, nachrichteins ) {
    document.getElementById('shop-name').innerHTML = händler;
    document.getElementById('shop-iteleins').innerHTML = nachrichteins;

    
}

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Button Actios-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

document.getElementById("reiter-button-normal").onclick = function() {
    $(".startseiter").hide("slow")
    $(".shop-übergang").show()
    timout = window.setTimeout(uebergangnormal, 3000) 
}
document.getElementById("reiter-button-import").onclick = function() {
    $(".startseiter").hide("slow")
    $(".shop-übergang").show()
    timout = window.setTimeout(importshop, 3000) 
}

function uebergangnormal() {
    $(".shop-übergang").hide()
    $(".shop-normal").show("slow")
}

function importshop() {
    $(".shop-übergang").hide()
    $(".shop-import").show("slow")
}

// --------------------------------------------------------------------------------------------------------------
// -----------------------------------------Display Normal Cars--------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
function displaycarshops (cars) {
    $(".shop-list").html("")
    
    $.each(cars, function (index,car) {
     $(".shop-list").append(
         `
    <div class="shop-containers">
        <div class="picture-container">
            <img src="src/${car.src}.png" class="bilds" alt="">
        </div>
        <h1 class="shop-name-auto"> 
            ${car.label}
        </h1>
        <h1 class="shop-preis"> 
            Preis: ${car.price}$
        </h1>
        <button type="button" name="${car.name}" id="probe-button" class="probe">Probe</button>
        <button type="button" name="${car.name}" preis="${car.price}"id="kaufen-button" class="kaufen">Kaufen</button>
    </div>
         `
       )
    })
}
// --------------------------------------------------------------------------------------------------------------
// -----------------------------------------Closing Function-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".close").click(function( ) {
    $(".shop-container").hide("slow")
    location.reload(true)
    $.post('http://SevenLife_CarDealer/close', JSON.stringify({}));
})
// --------------------------------------------------------------------------------------------------------------
// -------------------------------------------Test Button--------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".shop-normal").on("click", ".probe", function () {
    $(".shop-container").hide("slow")
    var $button = $(this)
    var $name = $button.attr("name")
    location.reload(true)
    $.post('http://SevenLife_CarDealer/testdrive', JSON.stringify({car : $name}));
})
// --------------------------------------------------------------------------------------------------------------
// -------------------------------------------Buy Button--------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".shop-normal").on("click", ".kaufen", function () {
    $(".shop-container").hide("slow")
    var $button = $(this)
    var $name = $button.attr("name")
    var $price = $button.attr("preis")
    $.post('http://SevenLife_CarDealer/buyingvehicle', JSON.stringify({car : $name, price : $price}));
})