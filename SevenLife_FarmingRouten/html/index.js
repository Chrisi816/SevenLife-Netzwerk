// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Start Script------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$("document").ready(function () {
	$(".baumarkt-container").hide();
	$(".progress-bar-zwei").hide();
	$(".progress-bar-drei").hide();
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".container-shop").hide();
	$(".progress-bar-vier").hide();
	$(".progress-bar-fuenf").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openbaumarkt-container") {
			$(".container-shop").show();
		} else if (event.data.type === "removebaumarkt-container") {
			$(".container-shop").hide();
		} else if (event.data.type === "openvararbeiternavsand") {
			$(".progress-bar-zwei").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-zwei")[0];
			progress = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
				getcounter += 1;
			}, 120);
		} else if (event.data.type === "resetnavbar") {
			$(".progress-bar-zwei").hide();
			clearInterval(progress);
			const progressBar =
				document.getElementsByClassName("progress-bar-zwei")[0];
			progressBar.style.removeProperty("--width");
		} else if (event.data.type === "opensammelkarrot") {
			$(".progress-bar-drei").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-drei")[0];
			progress = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 100);
		} else if (event.data.type === "removesammelnkarott") {
			$(".progress-bar-drei").hide();
			clearInterval(progress);

			const progressBar =
				document.getElementsByClassName("progress-bar-drei")[0];
			progressBar.style.removeProperty("--width");
		} else if (event.data.type === "verarbeiten") {
			$(".verarbeiter-container").fadeIn(500);
		} else if (event.data.type === "opennavbarkarottenverarbeiter") {
			$(".progress-bar-vier").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-vier")[0];
			progress = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 360);
		} else if (event.data.type === "removenavbarkarottenverarbeiter") {
			$(".progress-bar-vier").hide();
			clearInterval(progress);

			const progressBar =
				document.getElementsByClassName("progress-bar-vier")[0];
			progressBar.style.removeProperty("--width");
		} else if (event.data.type === "opennavbarkartoffelverarbeiter") {
			$(".progress-bar-fuenf").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-fuenf")[0];
			progress = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 440);
		} else if (event.data.type === "removenavbarkartoffelverarbeiter") {
			$(".progress-bar-fuenf").hide();
			clearInterval(progress);

			const progressBar =
				document.getElementsByClassName("progress-bar-fuenf")[0];
			progressBar.style.removeProperty("--width");
		}
	});
});
// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Display Items-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Buying Things-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Close-------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".close").click(function () {
	$(".baumarkt-container").hide("slow");
	location.reload(true);
	$.post("https://SevenLife_FarmingRouten/close", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		$(".verarbeiter-container").fadeOut(200);
		$(".karottenmenu").hide();
		$(".kartoffelmenu").hide();
		$(".kürbismenu").hide();
		$(".ledermenu").hide();
		$(".hauptmenu").show();
		CloseMenu();
		$.post("https://SevenLife_FarmingRouten/closes", JSON.stringify({}));
	}
});
// --------------------------------------------------------------------------------------------------------------
// ------------------------------------------Working-------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

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
// --------------------------------------------------------------------------------------------------------------
// ------------------------------------------Buttons-------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

$(".karottense").click(function () {
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$.post("https://SevenLife_FarmingRouten/karottense", JSON.stringify({}));
});

$(".kartoffelss").click(function () {
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$.post("https://SevenLife_FarmingRouten/kartoffelss", JSON.stringify({}));
});

$("#leders").click(function () {
	$(".verarbeiter-container").hide();
	$(".karottenmenu").hide();
	$(".kartoffelmenu").hide();
	$(".kürbismenu").hide();
	$(".ledermenu").hide();
	$(".hauptmenu").show();
	$.post(
		"https://SevenLife_FarmingRouten/lederverarbeiten",
		JSON.stringify({})
	);
});

$("#lizenzen").click(function () {
	$("#spaten").hide();
	$("#spitzhacke").hide();
	$("#behälter").show();
});

$("#alles").click(function () {
	$("#spaten").show();
	$("#spitzhacke").show();
	$("#behälter").show();
});

$("#waffen").click(function () {
	$("#spaten").show();
	$("#spitzhacke").show();
	$("#behälter").hide();
});

function CloseMenu() {
	$(".container-shop").hide();
	$.post("https://SevenLife_FarmingRouten/close", JSON.stringify({}));
}

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
	<img src="img/spaten.png" class="bigimg" alt="" />
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
	<img src="img/pickaxe.png" class="bigimg2" alt="" />
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
	<img src="img/behealter.png" class="bigimg"  alt="" />
	<button class="button-down" price = "100" name = "behälter">Kaufen</button>
	`);
});

$(".container-shop").on("click", ".button-down", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $price = $button.attr("price");
	$(".container-shop").hide();

	$.post(
		"https://SevenLife_FarmingRouten/payforitem",
		JSON.stringify({ name: $name, price: $price })
	);
});

function CloseMenu2() {
	$(".container-shop").hide();
	$.post("https://SevenLife_FarmingRouten/close", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu2();
	}
});
