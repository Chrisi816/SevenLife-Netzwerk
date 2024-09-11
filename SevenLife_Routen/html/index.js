var anzahl = 0;

$(".karotte").each(function () {
	$(this).data({
		originalLeft: $(this).css("left"),
		origionalTop: $(this).css("top"),
	});
});
$(".kartoffel").each(function () {
	$(this).data({
		originalLeft: $(this).css("left"),
		origionalTop: $(this).css("top"),
	});
});

$("document").ready(function () {
	$(".container-shop").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".verarbeiter-container").hide();
	$(".Karrote-Farming").hide();
	$(".KastenLoadingVerarbeiter").hide();
	$(".KastenLoadingVerarbeiter2").hide();
	$(".KastenLoadingVerarbeiter3").hide();
	$(".orangenverarbeiter").hide();
	$(".KastenLoadingVerarbeiter4").hide();
	$(".Kartoffel-Farming").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openbaumarkt-container") {
			$(".container-shop").show();
		} else if (event.data.type === "removebaumarkt-container") {
			$(".container-shop").hide();
		} else if (event.data.type === "OpenKarottenFarmen") {
			anzahl = 0;
			$(".Karrote-Farming").show();

			$(".karotte").each(function () {
				$(".karotte").draggable("enable");
				$(this).css({
					left: $(this).data("originalLeft"),
					top: $(this).data("origionalTop"),
				});
			});
		} else if (event.data.type === "OpenKarottenNUI") {
			$(".KastenLoadingVerarbeiter").show();
			document.getElementById("bar-in").style.width = "0px";
			var inter = setInterval(() => {
				var width = $("#bar-in").width();
				document.getElementById("bar-in").style.width =
					width + 11 + "px";
				if (width >= 210) {
					$(".KastenLoadingVerarbeiter").hide();
					clearInterval(inter);
				}
			}, 500);
		} else if (event.data.type === "verarbeiten") {
			$(".verarbeiter-container").fadeIn(500);
		} else if (event.data.type === "OpenNUIVerarbeiter") {
			$(".KastenLoadingVerarbeiter2").show();
			document.getElementById("bar-in2").style.width = "0px";
			var inters = setInterval(() => {
				var width = $("#bar-in2").width();
				document.getElementById("bar-in2").style.width =
					width + 11 + "px";
				if (width >= 210) {
					$(".KastenLoadingVerarbeiter2").hide();
					clearInterval(inters);
				}
			}, msg.time);
		} else if (event.data.type === "OpenBar") {
			$(".KastenLoadingVerarbeiter3").show();
			document.getElementById("bar-in3").style.width = "0px";
		} else if (event.data.type === "UpdateBar") {
			var width = $("#bar-in3").width();
			document.getElementById("bar-in3").style.width = width + 10 + "px";

			if (width >= 210) {
				$(".KastenLoadingVerarbeiter3").hide();
				$.post("https://SevenLife_Routen/GiveSand", JSON.stringify({}));
			}
		} else if (event.data.type === "OpenSandVerarbeiterNUI") {
			$(".orangenverarbeiter").show();
		} else if (event.data.type === "OpenLoadingVerarbeiten") {
			$(".KastenLoadingVerarbeiter4").show();
			document.getElementById("bar-in4").style.width = "0px";
			var inters4 = setInterval(() => {
				var width = $("#bar-in4").width();
				document.getElementById("bar-in4").style.width =
					width + 11 + "px";
				if (width >= 210) {
					$(".KastenLoadingVerarbeiter4").hide();
					clearInterval(inters4);
				}
			}, 1400);
		} else if (event.data.type === "OpenKartoffelFarmen") {
			anzahl = 0;
			$(".Kartoffel-Farming").show();
			$(".kartoffel").each(function () {
				$(".kartoffel").draggable("enable");
				$(this).css({
					left: $(this).data("originalLeft"),
					top: $(this).data("origionalTop"),
				});
			});
		}
	});
});

$(".container-shop").on("click", ".button-down", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $price = $button.attr("price");
	$(".container-shop").hide();

	$.post(
		"https://SevenLife_Routen/payforitem",
		JSON.stringify({ name: $name, price: $price })
	);
});

function CloseMenu2() {
	$(".container-shop").hide();
	$(".verarbeiter-container").fadeOut(200);
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$(".orangenverarbeiter").hide();
	$.post("https://SevenLife_Routen/closes", JSON.stringify({}));
	$.post("https://SevenLife_Routen/close", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu2();
	}
});

$(".container-shop").on("click", "#item1", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Spaten</h1>
	<div class="obenrechtsitem2">
		<h1 class="preis2">
			Aktueller Preis: <span class="color">50.00 $</span>
		</h1>
	</div>
	<div class="line"></div>
	<h1 class="infos-item">Munition:</h1>
	<h1 class="infos-item">Pro Magazin:</h1>
	<h1 class="infos-item">Gewicht:</h1>
	<h1 class="infos-item2">Nicht Vorhanden</h1>
	<h1 class="infos-item2">Nicht Vorhanden</h1>
	<h1 class="infos-item2">1.00KG</h1>
	
	<div class="linie2"></div>
	<div class="linie3"></div>
	
	<h1 class="preisende">$50.00</h1>
	<img src="src/spaten.png" class="bigimg" alt="" />
	<button class="button-down" price = "50" name = "spaten">Kaufen</button>
	`);
});
$(".container-shop").on("click", "#item2", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Spitzhacke</h1>
	<div class="obenrechtsitem2">
		<h1 class="preis2">
			Aktueller Preis: <span class="color">100.00 $</span>
		</h1>
	</div>
	<div class="line"></div>
	<h1 class="infos-item">Munition:</h1>
	<h1 class="infos-item">Pro Magazin:</h1>
	<h1 class="infos-item">Gewicht:</h1>
	<h1 class="infos-item2">Nicht Vorhanden</h1>
	<h1 class="infos-item2">Nicht Vorhanden</h1>
	<h1 class="infos-item2">1.00KG</h1>
	
	<div class="linie2"></div>
	<div class="linie3"></div>
	
	<h1 class="preisende">$100.00</h1>
	<img src="src/pickaxe.png" class="bigimg2" alt="" />
	<button class="button-down" price = "100" name = "pickaxe">Kaufen</button>
	`);
});
$(".container-shop").on("click", "#item3", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Behälter</h1>
	<div class="obenrechtsitem2">
		<h1 class="preis2">
			Aktueller Preis: <span class="color">100.00 $</span>
		</h1>
	</div>
	<div class="line"></div>
	<h1 class="infos-item">Munition:</h1>
	<h1 class="infos-item">Pro Magazin:</h1>
	<h1 class="infos-item">Gewicht:</h1>
	<h1 class="infos-item2">Nicht Vorhanden</h1>
	<h1 class="infos-item2">Nicht Vorhanden</h1>
	<h1 class="infos-item2">1.00KG</h1>
	
	<div class="linie2"></div>
	<div class="linie3"></div>
	
	<h1 class="preisende">$100.00</h1>
	<img src="src/behealter.png" class="bigimg"  alt="" />
	<button class="button-down" price = "100" name = "behälter">Kaufen</button>
	`);
});

$(".karotte").each(function () {
	$(this).draggable({
		appendTo: ".container-farming",
	});
});
$(".kartoffel").each(function () {
	$(this).draggable({
		appendTo: ".container-farming",
	});
});
$(".container-droppebel")
	.off()
	.droppable({
		drop: function (event, ui) {
			var items = ui.draggable.attr("name");
			$("#" + items).draggable("disable");
			anzahl = anzahl + 1;
			console.log(anzahl);
			if (anzahl == 3) {
				$(".Karrote-Farming").hide();
				$.post(
					"https://SevenLife_Routen/GiveKarotten",
					JSON.stringify({})
				);
			}
		},
	});
$(".container-droppebel2")
	.off()
	.droppable({
		drop: function (event, ui) {
			var items = ui.draggable.attr("name");
			$("#" + items).draggable("disable");
			anzahl = anzahl + 1;

			if (anzahl == 3) {
				$(".Kartoffel-Farming").hide();
				$.post(
					"https://SevenLife_Routen/GiveKartoffeln",
					JSON.stringify({})
				);
			}
		},
	});
$(".karotten").click(function () {
	$(".hauptmenu").hide();
	$(".karottenmenu").fadeIn(500);
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	document.getElementById("karotten").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	document.getElementById("kartoffel").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("kürbis").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("leder").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
});

$(".kartoffel").click(function () {
	$(".hauptmenu").hide();
	$(".kartoffelmenu").fadeIn(500);
	$(".karottenmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	document.getElementById("kartoffel").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	document.getElementById("karotten").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("kürbis").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("leder").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
});
$(".kürbis").click(function () {
	$(".hauptmenu").hide();
	$(".kürbismenu").fadeIn(500);
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".ledermenu").hide();
	document.getElementById("kürbis").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	document.getElementById("kartoffel").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("karotten").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("leder").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
});
$(".leder").click(function () {
	$(".hauptmenu").hide();
	$(".ledermenu").fadeIn(500);
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	document.getElementById("leder").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	document.getElementById("kartoffel").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("kürbis").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("karotten").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
});
$(".karottense").click(function () {
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$.post("https://SevenLife_Routen/karottense", JSON.stringify({}));
});

$(".kartoffelss").click(function () {
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$.post("https://SevenLife_Routen/kartoffelss", JSON.stringify({}));
});

$("#leders").click(function () {
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$.post("https://SevenLife_Routen/lederverarbeiten", JSON.stringify({}));
});
$(".button-down").click(function () {
	$(".orangenverarbeiter").hide();
	$.post("https://SevenLife_Routen/MakeVerarbeiten", JSON.stringify({}));
});
