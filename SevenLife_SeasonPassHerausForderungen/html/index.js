var random, random1, random2;

$("document").ready(function () {
	$(".container-SeasonPassHerausforderungen").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "OpenMissionen") {
			$(".container-SeasonPassHerausforderungen").show();

			document.getElementById("aufgabe1head").innerHTML =
				msg.aufgabe1name;
			document.getElementById("aufgabe1detail").innerHTML =
				msg.aufgabe1detail;

			document.getElementById("aufgabe2head").innerHTML =
				msg.aufgabe2name;
			document.getElementById("aufgabe2detail").innerHTML =
				msg.aufgabe2detail;

			document.getElementById("aufgabe3head").innerHTML =
				msg.aufgabe3name;
			document.getElementById("aufgabe3detail").innerHTML =
				msg.aufgabe3detail;

			if (msg.fertig1 == true) {
				$(".aufgabes1").append(`<div class="fertig">
                <h1 class="Headlinetext2" id="aufgabe1head">
                    ERLEDIGT
                </h1>
                <h1 class="TextAufgabe2" id="aufgabe1detail">
                    Nächste Aufgabe folgt um 4 Uhr Morgens. Sei
                    gespannt!
                </h1>
            </div>`);
			}
			if (msg.fertig2 == true) {
				$(".aufgabes2").append(`<div class="fertig">
                <h1 class="Headlinetext2" id="aufgabe1head">
                    ERLEDIGT
                </h1>
                <h1 class="TextAufgabe2" id="aufgabe1detail">
                    Nächste Aufgabe folgt um 4 Uhr Morgens. Sei
                    gespannt!
                </h1>
            </div>`);
			}
			if (msg.fertig3 == true) {
				$(".aufgabes3").append(`<div class="fertig">
                <h1 class="Headlinetext2" id="aufgabe1head">
                    ERLEDIGT
                </h1>
                <h1 class="TextAufgabe2" id="aufgabe1detail">
                    Nächste Aufgabe folgt um 4 Uhr Morgens. Sei
                    gespannt!
                </h1>
            </div>`);
			}
		}
	});
});
$(".button").click(function () {
	var $button = $(this);

	$.post(
		"https://SevenLife_SeasonPassHerausForderungen/GetEarnings",
		JSON.stringify({})
	);
});
function CloseMenu() {
	$(".container-SeasonPassHerausforderungen").hide();
	$.post(
		"https://SevenLife_SeasonPassHerausForderungen/CloseMenu",
		JSON.stringify({})
	);
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
