$("document").ready(function () {
	$(".seveninfo").hide();
	$(".seveninfoentegennehmer").hide();
	$(".aktenkoffer").hide();
	$(".seveninfokoffer").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenVertragsMenu") {
			$(".seveninfo").show();
		} else if (event.data.type === "Übergeber") {
			$(".seveninfoentegennehmer").show();
			document.getElementById("iputt-titelentgegennehmer").value =
				msg.titel;
			document.getElementById("iputt-beschreibungentgegennehmer").value =
				msg.beschreibung;
			document.getElementById(
				"inputttitelunterschrift1entegennehmer"
			).value = msg.unterschrift;
		} else if (event.data.type === "OpenAktenKoffer") {
			$(".aktenkoffer").show();
			InsertIntoTable(msg.result);
		} else if (event.data.type === "OpenAkte") {
			$(".seveninfokoffer").show();
			document.getElementById("iputt-titelkoffer").value = msg.titel;
			document.getElementById("iputt-beschreibungkoffer").value =
				msg.beschreibung;
			document.getElementById("inputttitelunterschrift1koffer").value =
				msg.unterschrift;
			document.getElementById("inputttitelunterschrift2koffer").value =
				msg.unterschrift2;
		}
	});
});
$("#übergeben").click(function () {
	$(".seveninfo").hide();

	var titel = document.getElementById("iputt-titel").value;
	var beschreibung = document.getElementById("iputt-beschreibung").value;
	var unterschrift = document.getElementById(
		"inputttitelunterschrift1"
	).value;
	$.post(
		"https://SevenLife_Vertrag/Uebergeben",
		JSON.stringify({
			unterschrift: unterschrift,
			beschreibung: beschreibung,
			titel: titel,
		})
	);
});

$("#akzeptieren").click(function () {
	$(".seveninfoentegennehmer").hide();
	var titel = document.getElementById("iputt-titelentgegennehmer").value;
	var beschreibung = document.getElementById(
		"iputt-beschreibungentgegennehmer"
	).value;
	var unterschrift = document.getElementById(
		"inputttitelunterschrift1entegennehmer"
	).value;
	var unterschrift2 = document.getElementById(
		"inputttitelunterschrift2entgegennehmer"
	).value;
	$.post(
		"https://SevenLife_Vertrag/Finish",
		JSON.stringify({
			unterschrift: unterschrift,
			beschreibung: beschreibung,
			titel: titel,
			unterschrift2: unterschrift2,
		})
	);
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".aktenkoffer").hide();
	$(".seveninfokoffer").hide();
	$(".seveninfo").hide();
	$(".seveninfoentegennehmer").hide();
	$.post("https://SevenLife_Vertrag/escape");
}
function InsertIntoTable(items) {
	$(".insert-container").html("");

	$.each(items, function (index, item) {
		$(".insert-container").append(
			`

			<div class="insert-container-result">
				<h1 class="Item-Name-Logistik">${item.titel}</h1>

				<button class="Button-Buy" name="${item.id}">Anschauen</button>
				<button class="Button-Buy2" name="${item.id}">Geben</button>
			</div>

			
			`
		);
	});
}
// Anschauen

$(".aktenkoffer").on("click", ".Button-Buy", function () {
	var $button = $(this);
	var $id = $button.attr("name");

	$(".aktenkoffer").hide();
	$.post("https://SevenLife_Vertrag/OpenAkte", JSON.stringify({ id: $id }));
});

// Geben
$(".aktenkoffer").on("click", ".Button-Buy2", function () {
	var $button = $(this);
	var $id = $button.attr("name");

	$(".aktenkoffer").hide();
	$.post("https://SevenLife_Vertrag/GiveAkte", JSON.stringify({ id: $id }));
});

$("#verlassen").click(function () {
	CloseMenu();
});
