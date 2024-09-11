$("document").ready(function () {
	$(".notify").hide();
	$(".container-tankstelle").hide();
	$(".kaufen").hide();
	$(".unten").hide();

	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openinfobar") {
			$(".notify").fadeIn(500);
			$(".unten").fadeIn(500);
			shownotifytext(
				msg.name,
				msg.owner,
				msg.liter,
				msg.avergevalue,
				msg.preisproliter
			);
		} else if (event.data.type === "removeinfobar") {
			$(".notify").fadeOut(500);
			$(".unten").fadeOut(500);
		} else if (event.data.type === "opentankenui") {
			$(".container-tankstelle").show();
			showtanke(
				msg.owner,
				msg.liter,
				msg.preis,
				msg.activefuel,
				msg.preislifter
			);
		} else if (event.data.type === "updatedata") {
			showtanke(
				msg.owner,
				msg.liter,
				msg.preis,
				msg.activefuel,
				msg.preislifter
			);
		} else if (event.data.type === "closetanknui") {
			$(".container-tankstelle").hide();
		} else if (event.data.type === "openTankeBuyNUI") {
			$(".kaufen").fadeIn(400);
			OpenShopBuying(msg.result);
		}
	});
});
function shownotifytext(name, owner, liter, avergevalue, preisprol) {
	document.getElementById("text").innerHTML = name;
	document.getElementById("text2").innerHTML = owner;
	document.getElementById("text3").innerHTML = avergevalue + "$";
	document.getElementById("text4").innerHTML = preisprol + "$";
	document.getElementById("text5").innerHTML = liter + "L";
}
function showtanke(owner, liter, preis, fuel, preisfuel) {
	document.getElementById("names").innerHTML = owner + "'Tankstelle";
	document.getElementById("liter").innerHTML = liter + "L";
	document.getElementById("preiss").innerHTML = preis + "$";
	document.getElementById("preisliter").innerHTML = preisfuel + "$";
	document.getElementById("literübrig").innerHTML = fuel + "L";
}
$(".submit-btn").click(function () {
	$.post("http://SevenLife_Fuel/Zahlen", JSON.stringify({}));
});
function OpenShopBuying(items) {
	$(".container-info").html("");

	$.each(items, function (index, item) {
		$(".container-info").append(
			`
			<div class="container-information">
			<h1 class="Item-Name-Logistik2">Tankstellen ID: ${item.tankstellennummer}</h1>
			<img
				src="src/outline_house_siding_white_48dp.png"
				class="img-shopbuy"
				alt=""
			/>
			<h1 class="preistxt">Preis:</h1>
			<h1 class="preistxt2">${item.wert}$</h1>
			<h1 class="locationtxt">Location Markieren:</h1>
			<img
				src="src/Screenshot_174.png"
				class="img-location"
				name = ${item.tankstellennummer}
				alt=""
			/>
			<button class="Button-BuyShop" name = ${item.tankstellennummer}>Shop Kaufen</button>
		</div>
         `
		);
	});
}

$(".kaufen").on("click", ".img-location", function () {
	var $bild = $(this);
	var $id = $bild.attr("name");
	$(".kaufen").hide();
	$.post("http://SevenLife_Fuel/location", JSON.stringify({ id: $id }));
});

$(".kaufen").on("click", ".Button-BuyShop", function () {
	var $button = $(this);
	var $id = $button.attr("name");
	$(".kaufen").hide();
	$.post("http://SevenLife_Fuel/buytanke", JSON.stringify({ id: $id }));
});
function CloseMenu() {
	$(".kaufen").hide();

	$.post("http://SevenLife_Fuel/rauses", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
