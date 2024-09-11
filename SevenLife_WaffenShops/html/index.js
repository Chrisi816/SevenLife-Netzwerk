// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Start Script------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$("document").ready(function () {
	//$(".waffenladen-container").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenWeaponShop") {
			$(".waffenladen-container").show();
		}
	});
});

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Buying Things-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$(".waffenladen-container").on("click", ".button-down", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	$(".waffenladen-container").hide();

	$.post(
		"http://SevenLife_WaffenShops/payforitem",
		JSON.stringify({ name: $name })
	);
});
// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Close-------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
function CloseMenu() {
	$(".waffenladen-container").hide();
	$.post("http://SevenLife_WaffenShops/CloseMenu", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

// Items
$(".waffenladen-container").on("click", "#item1", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Baseball Schläger</h1>
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
	<img
		src="img/baseline_lightbulb_white_48dp.png"
		class="information-detail"
		alt=""
	/>
	<div class="linie2"></div>
	<div class="linie3"></div>
	<h1 class="infotmation">
		Du darfst diese Waffen nur im Kofferraum halten, damit du
		dich Notwähren kannst, sobald dich jemand angreift
	</h1>
	<img src="img/weapon_bat.png" class="bigimg" alt="" />
	<button class="button-down"  name = "WEAPON_BAT">Kaufen</button>
	`);
});
$(".waffenladen-container").on("click", "#item2", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Taschenlampe</h1>
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
	<img
		src="img/baseline_lightbulb_white_48dp.png"
		class="information-detail"
		alt=""
	/>
	<div class="linie2"></div>
	<div class="linie3"></div>
	<h1 class="infotmation">
		Du darfst diese Waffen nur im Kofferraum halten, damit du
		dich Notwähren kannst, sobald dich jemand angreift
	</h1>
	<img src="img/weapon_flashlight.png" class="bigimg" alt="" />
	<button class="button-down"  name = "WEAPON_FLASHLIGHT">Kaufen</button>
	`);
});
$(".waffenladen-container").on("click", "#item3", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Messer</h1>
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
	<img
		src="img/baseline_lightbulb_white_48dp.png"
		class="information-detail"
		alt=""
	/>
	<div class="linie2"></div>
	<div class="linie3"></div>
	<h1 class="infotmation">
		Du darfst diese Waffen nur im Kofferraum halten, damit du
		dich Notwähren kannst, sobald dich jemand angreift
	</h1>
<h1 class="preisende">$100.00</h1>
	<img src="img/weapon_knife.png" class="bigimg"  alt="" />
	<button class="button-down"  name = "WEAPON_KNIFE">Kaufen</button>
	`);
});
$(".waffenladen-container").on("click", "#item4", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Angriffs Axt</h1>
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
	<img
		src="img/baseline_lightbulb_white_48dp.png"
		class="information-detail"
		alt=""
	/>
	<div class="linie2"></div>
	<div class="linie3"></div>
	<h1 class="infotmation">
		Du darfst diese Waffen nur im Kofferraum halten, damit du
		dich Notwähren kannst, sobald dich jemand angreift
	</h1>
<h1 class="preisende">$100.00</h1>
	<img src="img/weapon_battleaxe.png" class="bigimg"  alt="" />
	<button class="button-down"  name = "WEAPON_BATTLEAXE">Kaufen</button>
	`);
});
$(".waffenladen-container").on("click", "#item5", function () {
	$(".container-detail").html("");
	$(".container-detail").append(`<div class="left-line2"></div>
	<h1 class="textwaschanlage2">Angriffs Flasche</h1>
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
	<img
		src="img/baseline_lightbulb_white_48dp.png"
		class="information-detail"
		alt=""
	/>
	<div class="linie2"></div>
	<div class="linie3"></div>
	<h1 class="infotmation">
		Du darfst diese Waffen nur im Kofferraum halten, damit du
		dich Notwähren kannst, sobald dich jemand angreift
	</h1>
<h1 class="preisende">$100.00</h1>
	<img src="img/weapon_bottle.png" class="bigimg" alt="" />
	<button class="button-down"  name = "WEAPON_BOTTLE">Kaufen</button>
	`);
});
