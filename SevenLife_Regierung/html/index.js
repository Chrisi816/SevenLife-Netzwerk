$("document").ready(function () {
	$(".unternehmen").hide();
	$(".letztepage").hide();
	$(".final").hide();
	//$(".frontseite").hide();
	$(".wrapper").hide();
	$(".lizenzen").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openregierungsmenu") {
			$(".wrapper").show("fast");
			$(".frontseite").show();
		} else if (event.data.type === "removeregierungsmenu") {
			$(".unternehmen").hide();
			$(".letztepage").hide();
			$(".submitbutton1").hide();
			$(".submitbutton2").hide();
			$(".final").hide();
			$(".frontseite").show();
			$(".lizenzen").hide();
			$(".wrapper").hide("fast");
		}
	});
});
function shownotifytext(name, owner, avergevalue, nummer) {
	document.getElementById("text").innerHTML = name;
	document.getElementById("preis2").innerHTML = owner;
	document.getElementById("preis3").innerHTML = avergevalue;
	document.getElementById("preis3").innerHTML = nummer;
}
$("#lizenzen").click(function () {
	$(".frontseite").hide("fast");
	$(".lizenzen").show("fast");
});

$("#perso").click(function () {
	$(".frontseite").show("fast");
	$(".lizenzen").hide("fast");
	$(".wrapper").hide();
	CloseMenu();
	$.post("http://SevenLife_Regierung/Perso", JSON.stringify({}));
});

$("#buch").click(function () {
	$(".frontseite").show("fast");
	$(".lizenzen").hide("fast");
	$(".wrapper").hide();
	CloseMenu();
	$.post("http://SevenLife_Regierung/Buch", JSON.stringify({}));
});

$("#unternehmen").click(function () {
	$(".frontseite").hide("fast");
	$(".unternehmen").show("fast");
	$.post("http://SevenLife_Regierung/checkcash", JSON.stringify({}));
});
$(".box ").click(function () {
	$(".frontseite").show("fast");
	$(".unternehmen").hide("fast");
	$(".lizenzen").hide("fast");
});
$(".close ").click(function () {
	$(".wrapper").hide("fast");
	$.post("http://SevenLife_Regierung/rause", JSON.stringify({}));
});
$(".submitbutton").click(function () {
	var zeichen = document.getElementById("inputt").value.length;

	var mindexlenght = 5;
	if (zeichen > mindexlenght) {
		var name = document.getElementById("inputt").value;
		$.post(
			"http://SevenLife_Regierung/name",
			JSON.stringify({ unternehmensname: name })
		);
		$(".unternehmen").hide("fast");
		$(".letztepage").show("fast");
		$(".box").hide();
	}
});
$("#eins").click(function () {
	$(".submitbutton1").show("fast");
	$(".submitbutton2").hide();
});
$("#zwei").click(function () {
	$(".submitbutton2").show("fast");
	$(".submitbutton1").hide();
});
$(".submitbutton3").click(function () {
	$(".wrapper").hide("fast");
	$.post("http://SevenLife_Regierung/fertig", JSON.stringify({}));
});
// --------------------------------------------------------------------------------------------------------------
// ------------------------------------Start Script for Impounder------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

$("document").ready(function () {
	$(".container-impuonder").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openimpounder") {
			$(".container-impuonder").show("slow");
		} else if (event.data.type === "removeimpounder") {
			$(".container-impuonder").hide("slow");
		} else if (event.data.type == "addcarimpounder") {
			displayavaliblecars(
				event.data.plate,
				event.data.model,
				event.data.fuel,
				msg.versicherung
			);
		}
	});
});

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Show Car aus------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
function displayavaliblecars(plate, model, fuel, versicherung) {
	if (versicherung == "false") {
		$(".container-impounder-insert").append(
			`
			<div class="container-impunder-containing">
						<img
							src="src/outline_directions_car_filled_white_48dp.png"
							alt=""
							class="car-picture"
						/>
						<h1 class="carname-impounder">${model}</h1>
						<h1 class="info-impounder">Kennzeichen:</h1>
						<h1 class="info-impounder">Benzin:</h1>
						<h1 class="info-impounder">Reparatur:</h1>
						<h1 class="info-impounder2" id="kennzeichen">${plate}</h1>
						<h1 class="info-impounder2" id="benzin">${fuel}L</h1>
						<h1 class="info-impounder2" id="reparatur">N.Nötig</h1>
						<button class="button-down" name = ${plate}  price ="100">Freikaufen (100$)</button>
			</div>
			 `
		);
	} else {
		$(".container-impounder-insert").append(
			`
        <div class="container-impunder-containing">
					<img
						src="src/outline_directions_car_filled_white_48dp.png"
						alt=""
						class="car-picture"
					/>
					<h1 class="carname-impounder">${model}</h1>
					<h1 class="info-impounder">Kennzeichen:</h1>
					<h1 class="info-impounder">Benzin:</h1>
					<h1 class="info-impounder">Reparatur:</h1>
					<h1 class="info-impounder2" id="kennzeichen">${plate}</h1>
					<h1 class="info-impounder2" id="benzin">${fuel}L</h1>
					<h1 class="info-impounder2" id="reparatur">N.Nötig</h1>
					<button class="button-down" name = ${plate} price ="15" >Freikaufen (15$)</button>
		</div>
         `
		);
	}
}
// --------------------------------------------------------------------------------------------------------------
// ------------------------------------------- Car function------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".container-impuonder").on("click", ".button-down", function () {
	var $button = $(this);
	var $plate = $button.attr("name");
	var $price = $button.attr("price");
	$(".container-impuonder").hide("slow");
	$(".container-impounder-insert").html(" ");
	$.post(
		"http://SevenLife_Regierung/park-outs",
		JSON.stringify({ plate: $plate, price: $price })
	);
});
$(".impounder-close").click(function () {
	$(".container-impuonder").hide("slow");
	$(".container-impounder-insert").html(" ");
	$.post("http://SevenLife_Regierung/escape");
});
// --------------------------------------------------------------------------------------------------------------
// --------------------------------------Start Script for Anmelde------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

$("document").ready(function () {
	$(".anmeldestelle-container").hide();
	$(".Josie-Container").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openanmelde") {
			$(".anmeldestelle-container").show("slow");
			displayinfos(msg.vehname);
		} else if (event.data.type === "removeanmelde") {
			$(".anmeldestelle-container").hide("slow");
		} else if (event.data.type === "OpenAnmeldeInteraction") {
			$(".Josie-Container").show("slow");
		}
	});
});

// --------------------------------------------------------------------------------------------------------------
// ---------------------------------------------Display Infos----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
function displayinfos(texteins) {
	document.getElementById("textes").innerHTML =
		"Möchtest du dein " +
		texteins +
		" gegen eine kleine Gebühr in höhe von 100$ anmelden?";
}

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Button Actions----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".anmeldestelle-container").on(
	"click",
	".anmeldestelle-container-box-submitbutton",
	function () {
		var $button = $(this);
		var $plate = document.getElementById(
			"anmeldestelle-container-box-inputt"
		).value;
		$(".anmeldestelle-container").hide("slow");
		$.post(
			"http://SevenLife_Regierung/anmeldedaten",
			JSON.stringify({ plate: $plate })
		);
	}
);

$(".letztepage").on("click", ".gebäude", function () {
	var $button = $(this);
	var $id = $button.attr("namses");
	$(".letztepage").hide();
	$(".final").show("fast");
	$.post("http://SevenLife_Regierung/Buero", JSON.stringify({ buero: $id }));
});
$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("http://SevenLife_Regierung/Kennzeicheneandern", JSON.stringify({}));
});

$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("http://SevenLife_Regierung/umschauen", JSON.stringify({}));
});

function CloseMenu() {
	$(".wrapper").hide();
	$(".container-impuonder").hide();
	$(".container-impounder-insert").html(" ");
	$.post("http://SevenLife_Regierung/CloseMenu", JSON.stringify({}));
	$.post("http://SevenLife_Regierung/escape", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
