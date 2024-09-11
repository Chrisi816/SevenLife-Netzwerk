
$("document").ready(function () {
  $(".skilltree").hide()
  $(".levelup").hide()
  window.addEventListener('message', function (event) {
    var msg = event.data
    if (msg.type === "OpenSkillTree") {
      $(".skilltree").show()
      document.getElementById("skillpointnumber").innerHTML = msg.skillpoints
      document.getElementById("textxp").innerHTML = "Du hast " + msg.xp + " von " + msg.endxp + " Xp"
      document.getElementById("infolevel").innerHTML = "Level:" + msg.levels
      document.getElementById("name").innerHTML = msg.name

      // Oben Dots
      if (msg.obenbutton1 === "true") {
        document.getElementsByClassName("obenstrich")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.obenobenbutton2 === "true") {
        document.getElementsByClassName("obenstrichext2")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.obenrechtsbutton1 === "true") {
        document.getElementsByClassName("obenstrichext1")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.obenrechtsbutton2 === "true") {
        document.getElementsByClassName("obenstrichext5")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.obenlinksbutton1 === "true") {
        document.getElementsByClassName("obenstrichext3")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.obenlinksbutton2 === "true") {
        document.getElementsByClassName("obenstrichext4")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }

      // Unten Rechts Dots

      if (msg.rechtsuntenbutton1 === "true") {
        document.getElementsByClassName("untenrechtsstrich")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenobenbutton1 === "true") {
        document.getElementsByClassName("untenrechtsstrichext3")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenobenbutton2 === "true") {
        document.getElementsByClassName("untenrechtsstrichext4")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenobenbutton3 === "true") {
        document.getElementsByClassName("untenrechtsstrichext45")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenmittebutton1 === "true") {
        document.getElementsByClassName("untenrechtstrichext2")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenmittebutton2 === "true") {
        document.getElementsByClassName("untenrechtsstrichext5")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenmittebutton3 === "true") {
        document.getElementsByClassName("untenrechtsstrichext55")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenuntenbutton1 === "true") {
        document.getElementsByClassName("untenrechtsstrichext1")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.rechtsuntenuntenbutton2 === "true") {
        document.getElementsByClassName("untenrechtsstrichext6")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }


      // Unten Links Dots

      if (msg.linksuntenbutton1 === "true") {
        document.getElementsByClassName("untenlinksstrich")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenobenbutton1 === "true") {
        document.getElementsByClassName("untenlinksstrichext3")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenobenbutton2 === "true") {
        document.getElementsByClassName("untenlinksstrichext4")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenmittebutton1 === "true") {
        document.getElementsByClassName("untenlinkstrichext2")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenmittebutton2 === "true") {
        document.getElementsByClassName("untenlinkstrichext5")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenmittebutton3 === "true") {
        document.getElementsByClassName("untenlinksstrichext6")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenuntenbutton1 === "true") {
        document.getElementsByClassName("untenlinksstrichext1")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
      if (msg.linksuntenuntenbutton2 === "true") {
        document.getElementsByClassName("untenlinksstrichext7")[0].style.backgroundColor = "rgba(166, 0, 66, 0.574)"
      }
    } else if (event.data.type === "CloseMenu") {
      CloseMenu()
    } else if (event.data.type === "levelup") {
      $(".levelup").fadeIn(1000)
      document.getElementById("skillpointtexte").classList.add("addclasse")
      document.getElementById("leveltext").classList.add("addclass")
      document.getElementById("leveluptexte").classList.add("addclasses")
      document.getElementById("infotexte").classList.add("addclasseese")
      document.getElementById("leveltext").innerHTML = msg.newlevel
      setTimeout(function () {
        $(".levelup").hide()
        document.getElementById("skillpointtexte").classList.remove("addclasse")
        document.getElementById("leveltext").classList.remove("addclass")
        document.getElementById("leveluptexte").classList.remove("addclasses")
        document.getElementById("infotexte").classList.remove("addclasseese")
      }, 5000);
    }
  });
})

function CloseMenu() {
  $(".skilltree").hide()
  $.post('https://SevenLife_SkillSystem/CloseMenu', JSON.stringify({}));
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""
}

$(document).keyup(function (e) {
  if (e.key === "Escape") {
    CloseMenu()
  }
});
// Middle Poins

$(".middletree").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

// First Dots
$(".dotoben1").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks1").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts1").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

// Dots Oben 

$(".dotoben2").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotoben3").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotoben4").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Ausdauer Training Kapitel 1"
  document.getElementById("detailtext").innerHTML = "Mit diesem Skillpunkt erreichst du einen Ausdauer anstieg, welcher 20% beinhaltet"
})

$(".dotoben5").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Ausdauer Training Kapitel 2"
  document.getElementById("detailtext").innerHTML = "Mit diesem Skill erreichst du neue höchstleistungen mitdenen du bis zu 50% mehr Ausdauer besitzt"
})

$(".dotoben6").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

// Dots unten Links

$(".dotuntenlinks2").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks3").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks4").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks5").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks6").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks7").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenlinks8").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

//Dots unten rechts

$(".dotuntenrechts2").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts3").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts4").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts5").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts6").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts7").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts8").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

$(".dotuntenrechts9").click(function() {
  document.getElementById("titelinfokastne").innerHTML = ""
  document.getElementById("detailtext").innerHTML = ""

  document.getElementById("titelinfokastne").innerHTML = "Der Aufstieg von Chrisi"
  document.getElementById("detailtext").innerHTML = "Dies ist dein Anfang, am Anfang bist du noch schwach und Jung, jedoch wirst du mit der Zeit immer mächtiger"
})

// Dots Oben DoppelKlick


$(".dotoben2").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 11}));
})

$(".dotoben3").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 12}));
})

$(".dotoben4").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 13}));
})

$(".dotoben5").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 14}));
})

$(".dotoben6").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 15}));
})

// Dots Unten Links

$(".dotuntenlinks2").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 21}));
})

$(".dotuntenlinks3").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 22}));
})

$(".dotuntenlinks4").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 23}));
})

$(".dotuntenlinks5").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 24}));
})

$(".dotuntenlinks6").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 25}));
})

$(".dotuntenlinks7").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 26}));
})

$(".dotuntenlinks8").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 27}));
})

// Dots Unten Rechts

$(".dotuntenrechts2").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 31}));
})

$(".dotuntenrechts3").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 32}));
})

$(".dotuntenrechts4").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 33}));
})

$(".dotuntenrechts5").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 34}));
})

$(".dotuntenrechts6").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 35}));
})

$(".dotuntenrechts7").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 36}));
})

$(".dotuntenrechts8").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 37}));
})

$(".dotuntenrechts9").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 38}));
})


// Dots DoppelClick

$(".dotoben1").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 1}));
})

$(".dotuntenlinks1").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 2}));
})

$(".dotuntenrechts1").dblclick(function() {
  $.post('https://SevenLife_SkillSystem/DotMenu', JSON.stringify({dot : 3}));
})
