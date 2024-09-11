var numberofquestion = 1
var antwort = []
var guteantwort = []
var fragebenutzt = []
var Antwortenende = 10;
var mindestfragen = 5; 
var anzahlderfragen = 10; 
var lastClick = 0;
var state

$("document").ready(function () {
       $(".erfolg").hide()
       $(".flylicensespractical").hide()
       $(".main-lizenze").hide()
       $(".questionscar").hide()
       $(".flylicenses").hide()
       $(".misserfolg").hide()
       $(".questions").hide()
       $(".seitelkwprakti").hide()
       $(".seitemotortheorie").hide()
       $(".erfolgs").hide()
       $(".misserfolgs").hide()
       $(".seitemotorprakti").hide()
       $(".seitelkwtheorie").hide()
       $(".seiteautotheorie").hide()
       $(".seiteautoprakti").hide()
       window.addEventListener('message', function(event) {
           var msg = event.data
           if (event.data.type === "OpenNuiFlyLicenseTeorie") {
             $(".flylicenses").fadeIn(200)
             $(".frontsite").fadeIn()
             $(".questions").hide()
           } else if (event.data.type === "startquestions") {
            $(".questions").fadeIn(200)
             openquestion()
           } else if (event.data.type === "OpenNuiFlyLicensePractical") {
             $(".flylicensespractical").fadeIn(200)
           } else if (event.data.type === "RemoveNuiflylicense") {
             CloseAll()
           } else if (event.data.type === "opennormallizenze") {
             $(".main-lizenze").show()
           } else if (event.data.type === "onlytheorieauto") {
             $(".seiteautotheorie").show()
           } else if(event.data.type === "boththeorieauto") {
             $(".seiteautoprakti").show()
           } else if (event.data.type === "onlytheorielkw") {
             $(".seitelkwtheorie").show()
           } else if(event.data.type === "boththeorielkw") {
             $(".seitelkwprakti").show()
           } if (event.data.type === "onlytheoriemotor") {
             $(".seitemotortheorie").show()
           } else if(event.data.type === "boththeoriemotor") {
             $(".seitemotorprakti").show()
           } else if (event.data.type === "OpenPageQuestionsCar") {
             $(".questionscar").fadeIn(200)
             openquestioncar()
             state = "car"
           } else if (event.data.type === "OpenPageQuestionsLKW") {
            $(".questionscar").fadeIn(200)
            state = "lkw"
            openquestioncar()
           } else if (event.data.type === "OpenPageQuestionsMotorrad") {
            $(".questionscar").fadeIn(200)
            state = "motor"
            openquestioncar()
           }
       }); 
  })


$(document).keyup(function(e) {
  if (e.key === "Escape") {
      CloseAll()
  }
});

$(".buttonpraktical").click(function () {
  $(".flylicensespractical").hide(0)
  $.post('http://SevenLife_License/MakePractical', JSON.stringify({}));
})

$(".buttontheo").click(function() {
  $(".frontsite").hide()
  $.post('http://SevenLife_License/MakeQuestion', JSON.stringify({}));
})

$(".buttenleft").click(function () {
  $(".erfolg").hide()
  $(".flylicenses").hide()
  antwort = [];
	 guteantwort = [];
   fragebenutzt = [];
	 numberofquestion = 1;
  $.post('http://SevenLife_License/GiveLicense', JSON.stringify({}));
})
$(".autolizenz").click(function() {
  $(".frontseitenormal").hide()
  $.post('http://SevenLife_License/GetLizenzAuto', JSON.stringify({}));
})
$(".motorlizenz").click(function() {
  $(".frontseitenormal").hide()
  $.post('http://SevenLife_License/GetLizenzMotor', JSON.stringify({}));
})
$(".lkwlizenz").click(function() {
  $(".frontseitenormal").hide()
  $.post('http://SevenLife_License/GetLizenzLKW', JSON.stringify({}));
})

$(".buttenright").click(function () {
  $(".misserfolg").hide()
  $(".flylicenses").hide()
  antwort = [];
	 guteantwort = [];
   fragebenutzt = [];
	 numberofquestion = 1;
  $.post('http://SevenLife_License/raus', JSON.stringify({}));
})

function CloseAll() {
   $(".flylicenses").hide()
   antwort = [];
	 guteantwort = [];
   fragebenutzt = [];
	 numberofquestion = 1;
   $(".main-lizenze").hide()
   $.post('http://SevenLife_License/CloseMenu', JSON.stringify({}));
   $.post('http://SevenLife_License/CloseMenufly', JSON.stringify({}));

}
$(".back").click(function() {
  $(".frontseitenormal").show()
  $(".seiteautotheorie").hide()
  $(".seiteautoprakti").hide()
  $(".seitelkwprakti").hide()
       $(".seitemotortheorie").hide()
       $(".seitemotorprakti").hide()
       $(".seitelkwtheorie").hide()
})

function showtimetNotification(name,bankgeld, inflation, Kreditkartenbetrag) {
  
  document.getElementById('gelds').innerHTML = bankgeld + "$";
  document.getElementById('inflation').innerHTML = inflation + "%";
  document.getElementById('betrag').innerHTML = Kreditkartenbetrag + "$";
}
/*FRAGEN FLY*/

var tableQuestionfly = [
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "Baum",
    antwortB: "Fortnite",
    antwortC: "Mehr gepäck",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "Baum",
    antwortB: "Fortnite",
    antwortC: "Mehr gepäck",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  }
]

function randomquestion () {
  var random = Math.floor(Math.random() * anzahlderfragen);

	while (true) {
		if (fragebenutzt.indexOf(random) === -1) {
			break;
		}

		random = Math.floor(Math.random() * anzahlderfragen);
	}

	fragebenutzt.push(random);

	return random;
}

function openquestion() {
  $(".questions").fadeIn(200)

  var randomQuestion = randomquestion();
  $("#fragenummer").html("Frage: " + numberofquestion + "/10");
	$("#question").html(tableQuestionfly[randomQuestion].frage);
	$(".answerA").html(tableQuestionfly[randomQuestion].antwortA);
	$(".answerB").html(tableQuestionfly[randomQuestion].antwortB);
	$(".answerC").html(tableQuestionfly[randomQuestion].antwortC);
	$(".answerD").html(tableQuestionfly[randomQuestion].antwortD);
	$('input[name=question]').attr('checked', false);

	guteantwort.push(tableQuestionfly[randomQuestion].richtig);
}

$("#question-form").submit(function (e) {
	e.preventDefault();

	if (numberofquestion != Antwortenende) {
    $(".questions").hide()
		antwort.push($('input[name="question"]:checked').val());
		numberofquestion++;
		openquestion();
	} else {
	
		antwort.push($('input[name="question"]:checked').val());
		var Goodanwer = 0;
		for (i = 0; i < mindestfragen; i++) {
			if (antwort[i] == guteantwort[i]) {
				Goodanwer++;
			}
		}

		$(".questions").hide()
		if (Goodanwer >= mindestfragen) {
			$(".erfolg").fadeIn(200)
		} else {
      $(".misserfolg").fadeIn(200)
		}
	}

	return false;
});



/*Fragen Normal */

$(".autolizenztheo").click(function() {
  $(".seiteautotheorie").hide()
  $.post('http://SevenLife_License/MakeQuestionCar', JSON.stringify({}));
})

var tableQuestioncar = [
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "Baum",
    antwortB: "Fortnite",
    antwortC: "Mehr gepäck",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "Baum",
    antwortB: "Fortnite",
    antwortC: "Mehr gepäck",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  },
  {
    frage: "Was kreiert mehr Last aufm Flugzeug?",
    antwortA: "",
    antwortB: "",
    antwortC: "",
    antwortD: "",
    richtig: "B"
  }
]

function randomquestioncar () {
  var random = Math.floor(Math.random() * anzahlderfragen);

	while (true) {
		if (fragebenutzt.indexOf(random) === -1) {
			break;
		}

		random = Math.floor(Math.random() * anzahlderfragen);
	}

	fragebenutzt.push(random);

	return random;
}

function openquestioncar() {
  $(".questionscar").fadeIn(200)

  var randomQuestion = randomquestioncar();
  $("#fragenummer").html("Frage: " + numberofquestion + "/10");
	$("#question").html(tableQuestioncar[randomQuestion].frage);
	$(".answerA").html(tableQuestioncar[randomQuestion].antwortA);
	$(".answerB").html(tableQuestioncar[randomQuestion].antwortB);
	$(".answerC").html(tableQuestioncar[randomQuestion].antwortC);
	$(".answerD").html(tableQuestioncar[randomQuestion].antwortD);
	$('input[name=question]').attr('checked', false);

	guteantwort.push(tableQuestioncar[randomQuestion].richtig);
}

$("#question-forms").submit(function (e) {
	e.preventDefault();

	if (numberofquestion != Antwortenende) {
    $(".questionscar").hide()
		antwort.push($('input[name="question"]:checked').val());
		numberofquestion++;
		openquestioncar();
	} else {
	
		antwort.push($('input[name="question"]:checked').val());
		var Goodanswer = 0;
		for (i = 0; i < mindestfragen; i++) {
			if (antwort[i] == guteantwort[i]) {
				Goodanswer++;
			}
		}

		$(".questionscar").hide()
		if (Goodanswer >= mindestfragen) {
			$(".erfolgs").fadeIn(200)
		} else {
                  $(".misserfolgs").fadeIn(200)
		}
	}

	return false;
});

$(".buttenlefts").click(function () {
  $(".erfolgs").hide()
  $(".main-lizenze").hide()
  $(".frontseitenormal").show()
   antwort = [];
	 guteantwort = [];
   fragebenutzt = [];
	 numberofquestion = 1;
   $.post('http://SevenLife_License/CloseMenu', JSON.stringify({}));
   $.post('http://SevenLife_License/GiveLicenseCar', JSON.stringify({staing : state}));
})

$(".buttenrights").click(function () {
  $(".misserfolgs").hide()
  $(".main-lizenze").hide()
  $(".frontseitenormal").show()
  antwort = [];
	 guteantwort = [];
   fragebenutzt = [];
	 numberofquestion = 1;
  $.post('http://SevenLife_License/CloseMenu', JSON.stringify({}));
})

$(".autolizenzpractical").click(function() {
  $.post('http://SevenLife_License/StartPractiseAuto', JSON.stringify({}));
  $(".main-lizenze").hide()
  $(".seiteautotheorie").hide()
  $(".frontseitenormal").show()
  $(".seiteautoprakti").hide()
  $.post('http://SevenLife_License/CloseMenu', JSON.stringify({}));
})

$(".lkwlizenztheo").click(function() {
  $(".seitelkwtheorie").hide()
  $.post('http://SevenLife_License/MakeQuestionLKW', JSON.stringify({}));
})

$(".motorlizenztheorie").click(function() {
  $(".seitemotortheorie").hide()
  $.post('http://SevenLife_License/MakeQuestionMotorrad', JSON.stringify({}));
})

$(".lkwprakitlizenz").click(function() {
  $.post('http://SevenLife_License/StartPractiseLKW', JSON.stringify({}));
  $(".main-lizenze").hide()
  $(".seiteautotheorie").hide()
  $(".frontseitenormal").show()
  $(".seiteautoprakti").hide()
  $.post('http://SevenLife_License/CloseMenu', JSON.stringify({}));
})

$(".motorpraktilizent").click(function() {
  $.post('http://SevenLife_License/StartPractiseMotor', JSON.stringify({}));
  $(".main-lizenze").hide()
  $(".seiteautotheorie").hide()
  $(".frontseitenormal").show()
  $(".seiteautoprakti").hide()
  $.post('http://SevenLife_License/CloseMenu', JSON.stringify({}));
})