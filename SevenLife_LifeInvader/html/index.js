$("document").ready(function () {
    $(".top-werbungs").hide()
    $(".schalten-container").hide()
    $(".liveinvader").hide()
     window.addEventListener('message', function(event) {
     var msg = event.data
         if (msg.type === "OpenNUILifeInvader") {
                $(".liveinvader").fadeIn(500)
    displaywerbung(msg.result)
         }
     });
     
 })
 
 $("#submit-btns").click(function() {
    $(".normalewerbung-container").fadeIn(200)
    $(".schalten-container").hide()
    $(".top-werbungs").hide()
 })
 $("#submit-btne").click(function() {
   $(".top-werbungs").fadeIn(200)
   $(".schalten-container").hide()
   $(".normalewerbung-container").hide()
})
 $("#submit-btnd").click(function() {
   $(".schalten-container").fadeIn(200)
   $(".normalewerbung-container").hide()
   $(".top-werbungs").hide()
}) 

$(document).keyup(function(e) {
   if (e.key === "Escape") {
      $(".normalewerbung-container").fadeIn(200)
       $(".liveinvader").fadeOut(300)
       $(".top-werbungs").hide()
       $(".schalten-container").hide()
       $.post('https://SevenLife_LifeInvader/Close', JSON.stringify({}));
   }
});
function displaywerbung (werbung) {
   $(".normalewerbungumrandung").html("")
   $(".premiumwerbungumrandung").html("")
   $.each(werbung, function (index,werbung) {
       if (werbung.premiumornot === 1) {
           $(".normalewerbungumrandung").append(
               `
               <div class="normalewerbung">
               <h1 class="titelwerbung">
                  ${werbung.titel}
               </h1>
               <span class="nachrichtwerbung">
                    ${werbung.nachricht}
               </span>
               <h2 class="nachrichtensender">
                   Geschaltet von ${werbung.benutzername}
               </h2>
               </div>
               `
             )
       }  else if (werbung.premiumornot === 2) {
           $(".premiumwerbungumrandung").append(
               `
               <div class="normalewerbung">
               <h1 class="titelwerbung">
                  ${werbung.titel}
               </h1>
               <span class="nachrichtwerbung">
                    ${werbung.nachricht}
               </span>
               <h2 class="nachrichtensender">
                  Premium Werbung von ${werbung.benutzername}
               </h2>
               </div>
               `
             )
       }
   
   })
}
var statuse = 1

$("#eoffentlich").click(function() {
     statuse =  1
}) 
$("#anonym").click(function() {
     statuse = 2
}) 

var statuses = 1

$("#eoffentlich").click(function() {
   statuses =  1
}) 
$("#premium").click(function() {
   statuses = 2
}) 
$(".submitbuttonseesesess").click(function() {
   var $nachricht = document.getElementById("inputtwasdses").value
   var $titel = document.getElementById("inputtwasdsese").value
   $.post('https://SevenLife_LifeInvader/sendnachricht', JSON.stringify({inachrichtcon: $nachricht, status : statuse, statuses : statuses, titel : $titel}));
   document.getElementById("inputtwasdses").value = ""
   document.getElementById("inputtwasdsese").value = ""
   $(".normalewerbung-container").fadeIn(200)
   $(".liveinvader").fadeOut(300)
   $(".top-werbungs").hide()
   $(".schalten-container").hide()
}) 
