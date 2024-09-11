$("document").ready(function () {
       $(".haare").hide()
       $(".augen").hide()
       $(".falten").hide()
      $(".Barber-Container").hide()
      window.addEventListener('message', function(event) {
          var msg = event.data
          if (event.data.type === "opennuibarber") {
              $(".Barber-Container").fadeIn(1000)
              maketattoolist(msg.tatto)
          } 
      }) 
})
$("#haare").click(function( ){
    $(".fontseite-links").hide()
    $(".fontseite-rechts").hide()
    $(".haare").fadeIn(300)
})
$(".back").click(function( ){
    $(".fontseite-links").fadeIn(300)
    $(".fontseite-rechts").fadeIn(300)
    $(".haare").hide()
    $(".augen").hide()
    $(".falten").hide()
})
$("#augens").click(function() {
    $(".fontseite-links").hide()
    $(".fontseite-rechts").hide()
    $(".augen").fadeIn(300)
})
$("#falten").click(function() {
    $(".fontseite-links").hide()
    $(".fontseite-rechts").hide()
    $(".falten").fadeIn(300)
})


$(document).keyup(function(e) {
    if (e.key === "Escape") {
        CloseAll()
    }
});
  
function CloseAll() {
    $(".Barber-Container").hide()
    $(".haare").hide()
    $(".fontseite-links").show()
    $.post('http://SevenLife_Tattoo/CloseMenu', JSON.stringify({}));
}
$(".submitbuttonseedsf").click(function () {
    $(".Barber-Container").hide()
    var $price = document.getElementById('endpreis').value;
    $(".haare").hide()
    $(".fontseite-links").show()
    $.post('http://SevenLife_Tattoo/Kaufen', JSON.stringify({preis : $price}));
})
function maketattoolist(items) {
    $(".container-items").html("")
        $.each(items, function (index, item) {
         $(".container-items").append(
             `
             <div class="items-tatto" name = "${item.nameHash}" preis = "${item.price}" x = ${item.addedX} y = ${item.addedY} z = ${item.addedZ} rot = ${item.rotZ}>
             <div class="tattoname">
                ${item.nameHash}
             </div>
             <div class="preistext" >
                 Preis: ${item.price}
             </div>
             </div>
             `
           )
     })
    
}
$(".Barber-Container").on("click", ".items-tatto", function () {
    var $button = $(this)
    var $name = $button.attr("name")
    var $preis = $button.attr("preis")
    var $x = $button.attr("x")
    var $y = $button.attr("y")
    var $z = $button.attr("z")
    var $rot = $button.attr("rot")
    document.getElementById('endpreis').innerHTML = "";
    document.getElementById('endpreis').innerHTML = $preis + "$";
    console.log($preis)
    $.post('https://SevenLife_Tattoo/gucken', JSON.stringify({ name : $name, preis : $preis, x : $x, y : $y, z : $z, rot : $rot}));
})