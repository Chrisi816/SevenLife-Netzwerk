$("document").ready(function () {
	$(".container-interaktionsmenu").hide();
	$(".container-teleport").hide();
	$(".container-garage").hide();
	$(".container-teleport2").hide();
	$(".container-teleport3").hide();
	//$(".mainpage").hide();
	$(".rechnung").hide();
	//$(".kaufenpage").hide();
	$(".container-bauern").hide();
	//$(".garagepage").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenInteraktionsMenu") {
			$(".container-interaktionsmenu").show();
		} else if (event.data.type === "OpenMenuTeleport") {
			$(".container-teleport").show();
			$(".container-teleport2").hide();
			$(".container-teleport3").hide();
		} else if (event.data.type === "OpenMenuTeleport2") {
			$(".container-teleport").hide();
			$(".container-teleport2").show();
			$(".container-teleport3").hide();
		} else if (event.data.type === "OpenMenuTeleport3") {
			$(".container-teleport").hide();
			$(".container-teleport2").hide();
			$(".container-teleport3").show();
		} else if (event.data.type === "OpenGarageMedic") {
			$(".container-garage").show();
			$(".mainpage").show();
			$(".kaufenpage").hide();
			$(".garagepage").hide();
			OpenVehicleShop(msg.list);
		} else if (event.data.type === "AddGarage") {
			OpeenGarageItem(msg.name, msg.plate);
		} else if (event.data.type === "OpenRechnung") {
			$(".rechnung").show();
		} else if (event.data.type === "OpenSpecialItems") {
			document.getElementById("lokalerbauertext").innerHTML = msg.frak;
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
			$(".container-bauern").show();
			MakeNuis(msg.items);
		} else if (event.data.type === "UpdateMoney") {
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
		}
	});
});
$(".submitbuttonseedsf").click(function () {
	$(".container-interaktionsmenu").hide();
	$.post("https://SevenLife_Medic/CloseMenugoinside", JSON.stringify({}));
});
$(".submitdienst").click(function () {
	$(".container-interaktionsmenu").hide();
	$.post("https://SevenLife_Medic/ChangeStatus", JSON.stringify({}));
});
$(".deinst1").click(function () {
	$(".container-teleport").hide();
	$(".container-teleport2").hide();
	$(".container-teleport3").hide();
	$.post("https://SevenLife_Medic/TPPlayer", JSON.stringify({ stage: 1 }));
	$.post("https://SevenLife_Medic/CloseMonologue", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue2", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue3", JSON.stringify({}));
});
$(".deinst2").click(function () {
	$(".container-teleport").hide();
	$(".container-teleport2").hide();
	$(".container-teleport3").hide();
	$.post("https://SevenLife_Medic/TPPlayer", JSON.stringify({ stage: 2 }));
	$.post("https://SevenLife_Medic/CloseMonologue", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue2", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue3", JSON.stringify({}));
});
$(".deinst3").click(function () {
	$(".container-teleport").hide();
	$(".container-teleport2").hide();
	$(".container-teleport3").hide();
	$.post("https://SevenLife_Medic/TPPlayer", JSON.stringify({ stage: 3 }));
	$.post("https://SevenLife_Medic/CloseMonologue", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue2", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue3", JSON.stringify({}));
});
$(".submitbuttonseedsf2").click(function () {
	$(".container-teleport").hide();
	$(".container-teleport2").hide();
	$(".container-teleport3").hide();
	$.post("https://SevenLife_Medic/CloseMonologue", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue2", JSON.stringify({}));
	$.post("https://SevenLife_Medic/CloseMonologue3", JSON.stringify({}));
});
$(document).on("keydown", function (event) {
	switch (event.keyCode) {
		case 27:
			CloseWaffenschrank();
			break;
	}
});

function CloseWaffenschrank() {
	$(".container-interaktionsmenu").hide();
	$(".container-teleport").hide();
	$(".container-teleport2").hide();
	$(".container-teleport3").hide();
	$(".rechnung").hide();
	$(".container-bauern").hide();
	$.post("https://SevenLife_Medic/CloseMenuBauer", JSON.stringify({}));
	$(".container-garage").hide();
	$.post("https://" + GetParentResourceName() + "/CloseMenuAuto");
	$.post("https://" + GetParentResourceName() + "/CloseMenuFlugzeug");
}
$(".container-garage").on("click", ".autoteil", function () {
	$(".container-garage").hide();
	var $button = $(this);
	var $name = $button.attr("name");
	var $price = $button.attr("preis");
	$.post(
		"https://SevenLife_Medic/BuyVehicle",
		JSON.stringify({ car: $name, price: $price })
	);
});

$(".container-garage").on("click", ".autoteils", function () {
	$(".container-garage").hide();
	$(".autos-listes").html("");
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"https://SevenLife_Medic/ParkVehicleOut",
		JSON.stringify({ plate: $name })
	);
});

$(".pacezwei").click(function () {
	$(".mainpage").hide();
	$(".kaufenpage").fadeIn(50);
});

$(".placeeins").click(function () {
	$(".mainpage").hide();
	$(".garagepage").fadeIn(50);
	$.post("https://SevenLife_Medic/GetVehicles", JSON.stringify({}));
});
function MakeNuis(items) {
	$(".boxbuying").html(" ");

	$.each(items, function (index, item) {
		$(".boxbuying").append(
			`
            <div class="container-item">
					<h1 class="Bauer-Item">${item.name}</h1>
					<div class="strich-item"></div>
					<div class="container-item-preis">
						<h1 class="Preis-Bauern">${item.preis}$</h1>
					</div>
					<div class="img-container">
						<img src="src/${item.src}.png" class="imgbild" alt="" />
					</div>
					<button class="button-down" label = ${item.label} preis = ${item.preis} rang = ${item.rang}>Kaufen</button>
				</div>
            `
		);
	});
}
function OpenVehicleShop(items) {
	$(".autos-liste").html(" ");

	$.each(items, function (index, item) {
		$(".autos-liste").append(
			`
         <div class="autoteil" name = ${item.lable} preis = ${item.Costs}>
         <div class="leftautoteil">
            <img src="src/outline_directions_car_filled_white_36dp.png" class="car" alt="">
         </div>
         <h1 class="vehiclename">
             ${item.name} 
         </h1>
         <h1 class="preis">
              ${item.Costs}$
         </h1>
        </div>
         `
		);
	});
}
$(".buton-abbrechen").click(function () {
	$(".rechnung").hide();
});

$(".rechnung").on("click", ".buton-connect", function () {
	var $titel = document.getElementById("inputitel").value;
	var $grund = document.getElementById("inputreason").value;
	var $hoehedesgelds = document.getElementById("inputamount").value;
	$(".rechnung").hide();
	if (isNaN($hoehedesgelds)) {
		$.post("http://SevenLife_Medic/Fehler", JSON.stringify({}));
	} else {
		$.post(
			"http://SevenLife_Medic/MakeRechnung",
			JSON.stringify({
				titel: $titel,
				grund: $grund,
				hohe: $hoehedesgelds,
			})
		);
	}
});
function MakeNuis(items) {
	$(".boxbuying").html(" ");

	$.each(items, function (index, item) {
		$(".boxbuying").append(
			`
            <div class="container-item">
					<h1 class="Bauer-Item">${item.name}</h1>
					<div class="strich-item"></div>
					<div class="container-item-preis">
						<h1 class="Preis-Bauern">${item.preis}$</h1>
					</div>
					<div class="img-container">
						<img src="src/${item.src}.png" class="imgbild" alt="" />
					</div>
					<button class="button-down" label = ${item.label} preis = ${item.preis} rang = ${item.rang}>Kaufen</button>
				</div>
            `
		);
	});
}
$(".container-bauern").on("click", ".button-down", function () {
	var $button = $(this);
	var $label = $button.attr("label");
	var $preis = $button.attr("preis");
	var $rang = $button.attr("rang");
	$.post(
		"https://SevenLife_Medic/BuyItems",
		JSON.stringify({ name: $label, preis: $preis, rang: $rang })
	);
});
