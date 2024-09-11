$("document").ready(function () {
	$(".verkeufer").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenVerkeaufer") {
			$(".verkeufer").show();
			OpenInfo(msg.result);
		} else if (msg.type === "OpenDarkVerkäufer") {
			$(".verkeufer").show();
			OpenInfo(msg.result);
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".verkeufer").hide();
	$.post("https://SevenLife_VerkeuuferStellen/escape");
}

function OpenInfo(items) {
	$(".container-verkauf").html(" ");

	$.each(items, function (index, item) {
		$(".container-verkauf").append(
			`
			<div class="container-container">
			<div class="container-bild">
				<img src="src/${item.item}.png" class="fleisch" alt="" />
			</div>
			<h1 class="textinfo">${item.item}</h1>
			<div class="strichuntername"></div>
			<h1 class="anzahltext">Anzahl: 1</h1>
			<h1 class="preistext">Preis pro Stück: ${item.preis}$</h1>
			<div class="verkaufenbutton" preis = ${item.preis} name = ${item.item}>
				<h1 class="verkaufentext">Verkaufen</h1>
			</div>
		    </div>
         `
		);
	});
}

$(".verkeufer").on("click", ".verkaufenbutton", function () {
	var $button = $(this);
	var $preis = $button.attr("preis");
	var $name = $button.attr("name");
	var $anzahl = document.getElementById("inputts").value;
	console.log($anzahl);
	$.post(
		"https://SevenLife_VerkeuuferStellen/Verkauf",
		JSON.stringify({ anzahl: $anzahl, name: $name, preis: $preis })
	);
	$(".verkeufer").hide();

	$(".container-verkauf").html("");
	CloseMenu();
});
