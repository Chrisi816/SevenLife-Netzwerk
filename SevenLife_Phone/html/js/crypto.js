$("document").ready(function () {
    window.addEventListener('message', function(event) {
        var msg = event.data
        if (event.data.type === "opendashboard"){
$(".loadingsitecrypto").hide()
      loaddata(msg.name,msg.btc,msg.eth)
           $(".deashboard").fadeIn(400)
        } else if(event.data.type === "DontAccount") {
            $(".loadingsitecrypto").hide()
            $(".youdonthaveanaccount").show()
            
            var timeleft = 10;
            var downloadTimer = setInterval(function(){
              if(timeleft <= 0){
                $(".youdonthaveanaccount").hide()
                $(".loginseite").fadeIn(200)
                clearInterval(downloadTimer)
                
              } else {
                document.getElementById("demo").innerHTML = "Du wirst in " + timeleft + " Sekunden zurückgeleitet";
              }
              timeleft -= 1;
            }, 1000);
        } else if (event.data.type === "duhastschonnenacc") {
          $(".loadingsitecrypto").hide()
            $(".youhaveannacccount").show()
            
            var timeleft = 10;
            var downloadTimer = setInterval(function(){
              if(timeleft <= 0){
                $(".youhaveannacccount").hide()
                $(".loginseite").fadeIn(200)
                clearInterval(downloadTimer)
                
              } else {
                document.getElementById("demo").innerHTML = "Du wirst in " + timeleft + " Sekunden zurückgeleitet";
              }
              timeleft -= 1;
            }, 1000);
        }else if (event.data.type === "openlogin") {
           $(".loadingsitecrypto").hide()
          $(".cryptos").fadeIn(500)
          $(".loginseite").fadeIn(500)
          clearInterval(inter)
         interval = setInterval(function() {
          wordflick();
          $(".loginsymbol").fadeIn(500)
          $(".crypto-name").fadeIn(1000)
          $(".inputbenutzer").fadeIn(1200)
          $(".inputps").fadeIn(1400)
          $(".SubmitbuttonLoginCrypto").fadeIn(1600)
          $(".word").fadeIn(1600)
          $(".account-create-text").fadeIn(1600)
          clearInterval(interval)
           }, 300)
        } else if (event.data.type === "walletdidintexists") {
          $(".loadingsitecrypto").hide()
          $(".walletdidntexists").show()
          
          var timeleft = 5;
          var downloadTimer = setInterval(function(){
            if(timeleft <= 0){
              $(".walletdidntexists").hide()
              $(".loginseite").fadeIn(200)
              clearInterval(downloadTimer)
              
            } else {
              document.getElementById("demos").innerHTML = "Du wirst in " + timeleft + " Sekunden zurückgeleitet";
            }
            timeleft -= 1;
          }, 1000);
        } else if (event.data.type === "zuwenigcash") {
          $(".loadingsitecrypto").hide()
          $(".zuwenigmoney").show()
          
          var timeleft = 5;
          var downloadTimer = setInterval(function(){
            if(timeleft <= 0){
              $(".zuwenigmoney").hide()
              $(".loginseite").fadeIn(200)
              clearInterval(downloadTimer)
              
            } else {
              document.getElementById("demoss").innerHTML = "Du wirst in " + timeleft + " Sekunden zurückgeleitet";
            }
            timeleft -= 1;
          }, 1000);
        } else if (event.data.type === "erfolgtransfer") {
          $(".loadingsitecrypto").hide()
          $(".erfolg").show()
          
          var timeleft = 5;
          var downloadTimer = setInterval(function(){
            if(timeleft <= 0){
              $(".erfolg").hide()
              $(".loginseite").fadeIn(200)
              clearInterval(downloadTimer)
              
            } else {
              document.getElementById("demosss").innerHTML = "Du wirst in " + timeleft + " Sekunden zurückgeleitet";
            }
            timeleft -= 1;
          }, 1000);
        }
    });
 
})

function loaddata (name, btc, eth) {
  document.getElementById("texthey").innerHTML = "Hallo " + name;
  document.getElementById("bitcoin").innerHTML = Number(btc).toFixed(2);
  document.getElementById("ether").innerHTML = Number(eth).toFixed(2);
}
$(".crypto").click(function() {
  $(".cryptos").show()
   $(".deashboard").hide()
    $(".phone-hauptseite").hide()
    $(".loginsymbol").hide()
   $(".transbtc").hide()
    
    $(".transeth").hide()
 $(".zuwenigmoney").hide()
  $(".erfolg").hide()
  $(".walletdidntexists").hide()
    $(".transseven").hide()
    $(".loginseite").fadeIn(500)
    $(".crypto-name").hide()
    $(".youhaveannacccount").hide()
    $(".inputbenutzer").hide()
    $(".inputps").hide()
    $(".youdonthaveanaccount").hide()
    $(".SubmitbuttonLoginCrypto").hide()
    $(".word").hide()
    $(".registerseite").hide()
    $(".account-create-text").hide()
    $(".loadingsitecrypto").hide()
    interval = setInterval(function() {
        wordflick();
        $(".loginsymbol").fadeIn(500)
        $(".crypto-name").fadeIn(1000)
        $(".inputbenutzer").fadeIn(1200)
        $(".inputps").fadeIn(1400)
        $(".SubmitbuttonLoginCrypto").fadeIn(1600)
        $(".word").fadeIn(1600)
        $(".account-create-text").fadeIn(1600)
        clearInterval(interval)
    }, 100)

})
$(".btctrans").click(function() {
  $(".unten-crypto").hide()
  $(".transbtc").fadeIn(500)
  $(".transseven").hide()
  $(".transeth").hide()
})
$(".ethtrans").click(function() {
  $(".unten-crypto").hide()
  $(".transeth").fadeIn(500)
  $(".transseven").hide()
  $(".transbtc").hide()
})
$(".seventrans").click(function() {
  $(".unten-crypto").hide()
  $(".transseven").fadeIn(500)
  (".transeth").hide()
  $(".transbtc").hide()
})
$(".removebarunten").click(function () {
    $(".phone-hauptseite").show()
    $(".cryptos").hide()
    $(".loginseite").show()
    clearInterval(inter)
})

$(".account-create-text").click(function() {
    $(".loginseite").hide()
    $(".registerseite").show()
})

$(".account-anmelde-text").click(function() {
    $(".registerseite").hide()
    $(".loginseite").show()
})

$(".SubmitbuttonRegisterCrypto").click(function() {
    $(".registerseite").hide()
    $(".loadingsitecrypto").show() 
    $(".container-animationtext").fadeIn(200)
    var $benutzer = document.getElementById("inputbenutzerregist").value
    var $passwort = document.getElementById("inputpsregist").value
    $.post('http://SevenLife_Phone/CryptonicCreateAccount', JSON.stringify({ benutzer :  $benutzer, passwort : $passwort}));
})

$(".SubmitbuttonLoginCrypto").click(function() {
    $(".loginseite").hide()
    $(".loadingsitecrypto").show() 
    $(".container-animationtext").fadeIn(200)
    var $benutzer = document.getElementById("inputbenutzer").value
    var $passwort = document.getElementById("inputps").value
    $.post('http://SevenLife_Phone/AccountCryptoAnmelde', JSON.stringify({ benutzer :  $benutzer, passwort : $passwort}));
})
var words = ["Über 1000 Nutzer", "4.9 / 5 Sterne im Google Play store", "Top Wallet des Jahres 2022", "Zuverlässig und Einfach"],
    part,
    i = 0,
    offset = 0,
    len = words.length,
    forwards = true,
    skip_count = 0,
    skip_delay =20,
    speed = 110;
var wordflick = function () {
  inter = setInterval(function () {
    if (forwards) {
      if (offset >= words[i].length) {
        ++skip_count;
        if (skip_count == skip_delay) {
          forwards = false;
          skip_count = 0;
        }
      }
    }
    else {
      if (offset == 0) {
        forwards = true;
        i++;
        offset = 0;
        if (i >= len) {
          i = 0;
        }
      }
    }
    part = words[i].substr(0, offset);
    if (skip_count == 0) {
      if (forwards) {
        offset++;
      }
      else {
        offset--;
      }
    }
    $('.word').text(part);
  },speed);
};

document.addEventListener("DOMContentLoaded", function() {
  const slider = document.querySelector(".sliders");
  const firstElement = slider.querySelector(".element:first-of-type");

  if (slider === undefined || firstElement === undefined) {
    return;
  }

  document.querySelector(".arrows.left").addEventListener("click", function() {
    slider.scrollLeft -= firstElement.clientWidth;
  });
  document.querySelector(".arrows.right").addEventListener("click", function() {
    slider.scrollLeft += firstElement.clientWidth;
  });
});
/*Key */
$(".btcsubmit").click(function() {
  $(".loadingsitecrypto").show() 
  $(".deashboard").hide()
  var $wallet = document.getElementById("btcinput1").value
  var $cash = document.getElementById("btcinput2").value
  $.post('http://SevenLife_Phone/transferbtc', JSON.stringify({wallet :  $wallet, cash : $cash}));
})
$(".ethsubmit").click(function() {
  $(".loadingsitecrypto").show() 
  $(".deashboard").hide()
  var $wallet = document.getElementById("ethinput1").value
  var $cash = document.getElementById("ethinput2").value
  $.post('http://SevenLife_Phone/transfereth', JSON.stringify({wallet :  $wallet, cash : $cash}));
})
$(".sevensubmit").click(function() {
  $(".loadingsitecrypto").show() 
  $(".deashboard").hide()
  var $wallet = document.getElementById("seveninput1").value
  var $cash = document.getElementById("seveninput2").value
  $.post('http://SevenLife_Phone/transferseven', JSON.stringify({ wallet :  $wallet, cash : $cash}));
})
