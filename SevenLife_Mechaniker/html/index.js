var indialogmenu = false;
var inmenudialog = false;
$("document").ready(function () {
	$(".container-garage").hide();
	$(".mainpage").hide();
	$(".kaufenpage").hide();
	$(".SprayMenu").hide();
	$(".Mechaniker-Laggerraum").hide();
	$(".einlagernitems-lager").hide();
	// $(".main-farbemenu").hide()
	$(".primär").hide();
	$(".pearl").hide();
	$(".changemenu").hide();
	$(".sekundär").hide();
	$(".changeingmenu").hide();
	$(".lohnsite").hide();
	$(".rechnung").hide();
	//$(".mainpage-boss").hide()
	$(".Rechnungen").hide();
	$(".angestellte-list").hide();
	$(".geld-taken").hide();
	$(".bos-menu-mechaniker").hide();
	//$(".tuning").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenGarageWerkstatt") {
			$(".container-garage").show();
			$(".mainpage").show();
			$(".kaufenpage").hide();
			$(".garagepage").hide();
			OpenVehicleShop(msg.list);
		} else if (event.data.type === "AddGarage") {
			OpeenGarageItem(msg.name, msg.plate);
		} else if (event.data.type === "OpenLager") {
			$(".Mechaniker-Laggerraum").show();
			OpenLagerItems(msg.lageritems);
			$(".mainlagerseite").show();
			OpenLagerGereate(msg.gereate);
		} else if (event.data.type === "OpenNUIInventory") {
			InsertInventoryItems(msg.inventoryitems);
		} else if (event.data.type === "OpenSprayMenu") {
			$(".SprayMenu").fadeIn(200);
			$(".main-farbemenu").show();
			$(".primär").hide();
			$(".pearl").hide();
			$(".sekundär").hide();
		} else if (event.data.type === "CloseAll") {
			$(".SprayMenu").hide();
		} else if (event.data.type === "OpenLackierungMenuPrimear") {
			$(".main-farbemenu").hide();
			$(".primär").show();
		} else if (event.data.type === "OpenLackierungMenuSekundär") {
			$(".main-farbemenu").hide();
			$(".sekundär").show();
		} else if (event.data.type === "OpenLackierungMenuPearl") {
			$(".main-farbemenu").hide();
			$(".pearl").show();
		} else if (event.data.type === "OpenMenuMenu") {
			$(".changemenu").show();
			indialogmenu = true;
		} else if (event.data.type === "OpenDialogMenu") {
			$(".changeingmenu").show();
			inmenudialog = true;
		} else if (event.data.type === "OpenRechnungen") {
			$(".Rechnungen").show();
			MakeRechnungen(msg.result);
		} else if (event.data.type === "OpenAngestellte") {
			$(".angestellte-list").show();
			MakeAngestellte(msg.result);
		} else if (event.data.type === "UpdateAngestellte") {
			MakeAngestellte(msg.result);
		} else if (event.data.type === "OpenBossMenu") {
			var ds = 0;
			$(".bos-menu-mechaniker").show();
			$(".mainpage-boss").show();
			document.getElementById("geld-boss").innerHTML = msg.cash;
			$.each(msg.result, function (index, item) {
				ds++;
			});
			document.getElementById("membercount").innerHTML = ds;
		} else if (event.data.type === "OpenRechnung") {
			$(".rechnung").show();
		} else if (event.data.type === "OpenTuning") {
			$(".tuning").show();
			MakeFirstTuningList(msg.result);
		} else if (event.data.type === "OpenTuningID") {
			MakeSecondTuningList(msg.result, msg.names);
		} else if (event.data.type === "UpdateLohn") {
			MakeLohn(msg.result);
		}
	});
});

function MakeFirstTuningList(items) {
	$(".box-container-tuning").html(" ");

	$.each(items, function (index, item) {
		$(".box-container-tuning").append(
			`
         <div class="tuning-container" name = ${item.name}>
             <img src="src/outline_directions_car_filled_white_36dp.png" class="imgs" alt="">
             <h1 class="text-detail">
                ${item.title}
             </h1>
         </div>
         `
		);
	});
}

function MakeSecondTuningList(items, names) {
	$(".container-tuning-teile").html(" ");

	$.each(items, function (index, item) {
		$(".container-tuning-teile").append(
			`
         <div class="container-tuning-id" name = ${names} modnumber = ${item.mod} modtype = ${item.modtype} tint = ${item.tint}>
            <h1 class="text-tunint-container">
                ${item.name}
			</h1>
			<h1 class="costs"> 
                ${item.costs}$
			</h1>
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
function MakeAngestellte(items) {
	$(".container-angestellte").html(" ");

	$.each(items, function (index, item) {
		$(".container-angestellte").append(
			`
         <div class="container-angestellte-id">
						<h1 class="name-manage">
							${item.name}
						</h1>
						<h1 class="rank">${item.job_grade}</h1>
						<button type="button" id = ${item.identifier} class="button-rankup">
							Uprank
						</button>
						<button type="button" id = ${item.identifier} class="button-rankdown">
							Downrank
						</button>
						<button type="button" id = ${item.identifier} class="button-feuern">
							Feuern
						</button>
					</div>
         `
		);
	});
}

function OpenLagerGereate(items) {
	$(".utils-container").html(" ");

	$.each(items, function (index, item) {
		$(".utils-container").append(
			`
         <div class="sourounding">
         <img src="src/${item.name}.png" class="bild-lager" alt="">
          <div class="strichmitteeins">

          </div>
          <h1 class="name-lagerrepaire">
             ${item.label}
          </h1>
          <h1 class="stückzahl" id="anzahleins">
            Anzahl: ${item.amount}
          </h1>
          <button type="button" name = ${item.name} class="button-lager">Nehmen</button>
       </div>
         `
		);
	});
}

function OpenLagerItems(items) {
	$(".container-items").html(" ");

	$.each(items, function (index, item) {
		$(".container-items").append(
			`
        <div class="sourounding-item">
            <img src="src/tuning/${item.name}.png" class="bild-lagerzweide" alt="">
            <div class="strichmitteeins">

            </div>
            <h1 class="name-lagername">
              ${item.label}
            </h1>
            <h1 class="stückzahl">
             Anzahl: ${item.amount}
            </h1>
            <button type="button" class="button-lager" name = ${item.name}> Nehmen</button>
        </div>
         `
		);
	});
}

function InsertInventoryItems(items) {
	$(".einlagern-items-inventory").html(" ");

	$.each(items, function (index, item) {
		$(".einlagern-items-inventory").append(
			`
         <div class="inventory-item">
         <img src="src/outline_category_white_48dp.png"class="invitem" alt="">
         <div class="strichmittezwei">

         </div> 
         <h1 class="nameofinventoryitem">
             ${item.label}
         </h1>
         <h1 class="itemstrück">
             Anzahl: ${item.count}
         </h1>
         <button type="button" name=${item.name} class="button-lagereinlager">Nehmen</button>
         </div>
         `
		);
	});
}

function MakeRechnungen(items) {
	$(".rechnungen-container").html(" ");

	$.each(items, function (index, item) {
		$(".rechnungen-container").append(
			`
         <div class="rechnungen-container-id">
         <img src="src/outline_category_white_48dp.png" class="imgscript" alt="">
         <h1 class="resoun-bill">
            ${item.stand}
         </h1>
         <h1 class="titel-bill">
            ${item.reason} 
         </h1>
         <h1 class="haumany">
            ${item.price}$
         </h1>
         </div>
         `
		);
	});
}

function OpeenGarageItem(name, plate) {
	$(".autos-listes").append(
		`
         <div class="autoteils" name = ${plate}>
         <div class="leftautoteil">
            <img src="src/outline_directions_car_filled_white_36dp.png" class="car" alt="">
         </div>
         <h1 class="vehiclename">
              ${name} 
         </h1>
         <div class="kennzeichepage">
             <h1 class="kennzeichen">
             ${plate}
             </h1>
         </div>
       
     </div>

         `
	);
}

$(".container-garage").on("click", ".autoteil", function () {
	$(".container-garage").hide();
	var $button = $(this);
	var $name = $button.attr("name");
	var $price = $button.attr("preis");
	$.post(
		"http://SevenLife_Mechaniker/BuyVehicle",
		JSON.stringify({ car: $name, price: $price })
	);
});

$(".container-garage").on("click", ".autoteils", function () {
	$(".container-garage").hide();
	$(".autos-listes").html("");
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"http://SevenLife_Mechaniker/ParkVehicleOut",
		JSON.stringify({ plate: $name })
	);
});

$(".pacezwei").click(function () {
	$(".mainpage").hide();
	$(".kaufenpage").fadeIn(50);
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

$(".placeeins").click(function () {
	$(".mainpage").hide();
	$(".garagepage").fadeIn(50);
	$.post("http://SevenLife_Mechaniker/Raus", JSON.stringify({}));
	$.post("http://SevenLife_Mechaniker/GetVehicles", JSON.stringify({}));
});

function CloseAll() {
	$(".Mechaniker-Laggerraum").hide();
	$(".autos-liste").html("");
	$(".autos-listes").html("");
	$(".container-garage").hide();
	$(".einlagernitems-lager").hide();
	$(".lohnsite").hide();
	$(".mainpage-boss").show();
	$(".Rechnungen").hide();
	$(".angestellte-list").hide();
	$(".bos-menu-mechaniker").hide();
	$(".changemenu").hide();
	$(".tuning").hide();
	$(".changeingmenu").hide();
	inmenudialog = false;
	indialogmenu = false;
	$(".SprayMenu").hide();
	$.post(
		"http://SevenLife_Mechaniker/CloseMenuLaggerraum",
		JSON.stringify({})
	);
	$.post("http://SevenLife_Mechaniker/CloseMenu", JSON.stringify({}));
	$.post("http://SevenLife_Mechaniker/CloseMenuPaint", JSON.stringify({}));
	$.post("http://SevenLife_Mechaniker/CloseMenuTuning", JSON.stringify({}));
}

$(".Mechaniker-Laggerraum").on("click", ".button-lager", function () {
	var $button = $(this);
	$(".Mechaniker-Laggerraum").hide();
	var $name = $button.attr("name");
	$.post(
		"http://SevenLife_Mechaniker/GetItemOutLager",
		JSON.stringify({ name: $name })
	);
});

$(".button-lager-einlagern").click(function () {
	$(".mainlagerseite").hide();
	$(".einlagernitems-lager").fadeIn(50);
	$.post("http://SevenLife_Mechaniker/GetInventoryItems", JSON.stringify({}));
});

$(".button-lager-auslagern").click(function () {
	$(".mainlagerseite").fadeIn(50);
	$(".einlagernitems-lager").hide();
});
$(".einlagernitems-lager").on("click", ".button-lagereinlager", function () {
	var $button = $(this);
	CloseAll();
	var $name = $button.attr("name");
	$.post(
		"http://SevenLife_Mechaniker/InsertItemIntoLager",
		JSON.stringify({ name: $name })
	);
});
var types = 1;
$(".prmearfarbe").click(function () {
	types = 1;
	$.post(
		"http://SevenLife_Mechaniker/CheckIfMixed",
		JSON.stringify({ type: 1 })
	);
});
$(".sekundärfarbe").click(function () {
	types = 2;
	$.post(
		"http://SevenLife_Mechaniker/CheckIfMixed",
		JSON.stringify({ type: 2 })
	);
});
$(".pearlfarbe").click(function () {
	types = 3;
	$.post(
		"http://SevenLife_Mechaniker/CheckIfMixed",
		JSON.stringify({ type: 3 })
	);
});

var colortype = 0;
var pearl = 0;
var r;
var g;
var b;
var theInput = document.getElementById("headcolor");

theInput.addEventListener(
	"input",
	function () {
		var theColor = theInput.value;
		var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(theColor);
		if (result) {
			r = parseInt(result[1], 16);
			g = parseInt(result[2], 16);
			b = parseInt(result[3], 16);
			if (types == 1) {
				$.post(
					"http://SevenLife_Mechaniker/MakeColorTesting",
					JSON.stringify({ r: r, g: g, b: b, type: colortype })
				);
			} else if (types == 2) {
				$.post(
					"http://SevenLife_Mechaniker/MakeColorTestingSekundär",
					JSON.stringify({ r: r, g: g, b: b, type: colortype })
				);
			}
		}
	},
	false
);

$("input:checkbox").on("click", function () {
	var $box = $(this);
	if ($box.is(":checked")) {
		var group = "input:checkbox[name='" + $box.attr("name") + "']";
		$(group).prop("checked", false);
		$box.prop("checked", true);
		colortype = $box.attr("name");
		if (types == 1) {
			$.post(
				"http://SevenLife_Mechaniker/MakeColorTesting",
				JSON.stringify({ r: r, g: g, b: b, type: colortype })
			);
		} else if (types == 2) {
			$.post(
				"http://SevenLife_Mechaniker/MakeColorTestingSekundär",
				JSON.stringify({ r: r, g: g, b: b, type: colortype })
			);
		}
	} else {
		$box.prop("checked", false);
	}
});

$(".button-mechanikreset").click(function () {
	if (types == 1 || types == 2) {
		$.post("http://SevenLife_Mechaniker/ResetCarColor", JSON.stringify({}));
	} else if (types == 3) {
		$.post("http://SevenLife_Mechaniker/ResetCarPearl", JSON.stringify({}));
	}
});

$(".button-mechanikfarbe").click(function () {
	$(".SprayMenu").hide();
	$.post(
		"http://SevenLife_Mechaniker/farbeapplybuy",
		JSON.stringify({ r: r, g: g, b: b, type: colortype })
	);
});
$(".button-mechaniksekundär").click(function () {
	$(".SprayMenu").hide();
	$.post(
		"http://SevenLife_Mechaniker/farbesekundearrapplybuy",
		JSON.stringify({ r: r, g: g, b: b, type: colortype })
	);
});
$(".button-mechanikfarbepearl").click(function () {
	$(".SprayMenu").hide();
	$.post(
		"http://SevenLife_Mechaniker/farbepearlapplybuy",
		JSON.stringify({ tint: pearl })
	);
});
$(".pearl").on("click", ".container-pearl-auswähle", function () {
	var $button = $(this);
	var $name = $button.attr("type");
	pearl = $name;
	$.post(
		"http://SevenLife_Mechaniker/MakeColorTestingPearl",
		JSON.stringify({ tint: $name })
	);
});

function moveUp() {
	if ($(".selected").prev("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.prev("div")
			.addClass("selected")
			.focus();
	}
}

function moveDown() {
	if ($(".selected").next("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.next("div")
			.addClass("selected")
			.focus();
	}
}

if ($(".selected").length === 0) {
	$(".box-container-menu").first().addClass("focus");
	$(".box-container-menu div").first().addClass("selected").focus();
	$(".box-container-menus").first().addClass("focus");
	$(".box-container-menus div").first().addClass("selected").focus();
}

document.onkeydown = function (e) {
	switch (e.keyCode) {
		case 38:
			moveUp();
			break;
		case 40:
			moveDown();
			break;
		case 13:
			if (indialogmenu === true) {
				$(".changemenu").hide();
				var box = $(".selected");
				var action = box.attr("typeofaction");

				$.post(
					"http://SevenLife_Mechaniker/MakeAction",
					JSON.stringify({ action: action })
				);
				indialogmenu = false;
			} else if (inmenudialog === true) {
				$(".changeingmenu").hide();
				var box = $(".selected");
				var action = box.attr("typeofaction");

				$.post(
					"http://SevenLife_Mechaniker/MakeAction2",
					JSON.stringify({ action: action })
				);
				inmenudialog = false;
			}
	}
};

$("#rechnungen-boss").click(function () {
	$(".mainpage-boss").hide();
	$.post("http://SevenLife_Mechaniker/GetRechnungen", JSON.stringify({}));
});

$(".buton-reset").click(function () {
	$(".Rechnungen").hide();
	$(".lohnsite").hide();
	$(".mainpage-boss").show();
	$(".angestellte-list").hide();
	$(".geld-taken").hide();
});

$("#lohn").click(function () {
	$(".mainpage-boss").hide();
	$.post("http://SevenLife_Mechaniker/GetOldLohn", JSON.stringify({}));
	$(".lohnsite").show();
});
$(".lohnsite").on("click", ".buton-apply", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $lohn = parseFloat($button.parent().find(".inputt-Iban").val());

	$.post(
		"http://SevenLife_Mechaniker/SetLohn",
		JSON.stringify({ type: $name, lohn: $lohn })
	);
});
$("#angestellte").click(function () {
	$(".mainpage-boss").hide();
	$.post("http://SevenLife_Mechaniker/GetMembers", JSON.stringify({}));
	$(".angestellte-list").show();
});
$(".angestellte-list").on("click", ".button-rankup", function () {
	var $button = $(this);
	var $id = $button.attr("id");

	$.post("http://SevenLife_Mechaniker/RankUp", JSON.stringify({ id: $id }));
});
$(".angestellte-list").on("click", ".button-rankdown", function () {
	var $button = $(this);
	var $id = $button.attr("id");
	$.post("http://SevenLife_Mechaniker/DeRank", JSON.stringify({ id: $id }));
});
$(".angestellte-list").on("click", ".button-feuern", function () {
	var $button = $(this);
	var $id = $button.attr("id");
	$.post("http://SevenLife_Mechaniker/feuern", JSON.stringify({ id: $id }));
});
$("#geld-bosstaken").click(function () {
	$(".mainpage-boss").hide();
	$(".geld-taken").show();
});

$("#submitbutton").click(function () {
	$(".mainpage-boss").show();
	$(".geld-taken").hide();
	CloseAll();
	var $benutzer = document.getElementById("auszahlinputt1").value;
	$.post(
		"http://SevenLife_Mechaniker/Einzahlen",
		JSON.stringify({ cash: $benutzer })
	);
});
$("#submitbutton2").click(function () {
	$(".mainpage-boss").show();
	$(".geld-taken").hide();
	CloseAll();
	var $benutzer = document.getElementById("auszahlinputt12").value;
	$.post(
		"http://SevenLife_Mechaniker/Auszahlen",
		JSON.stringify({ cash: $benutzer })
	);
});

$(".buton-abbrechen").click(function () {
	$(".rechnung").hide();
});

$(".rechnung").on("click", ".buton-connect", function () {
	var $titel = document.getElementById("inputitel").value;
	var $grund = document.getElementById("inputreason").value;
	var $hoehedesgelds = document.getElementById("inputamount").value;
	$(".rechnung").hide();
	if (isNaN($hoehedesgelds)) {
		$.post("http://SevenLife_Mechaniker/Fehler", JSON.stringify({}));
	} else {
		$.post(
			"http://SevenLife_Mechaniker/MakeRechnung",
			JSON.stringify({
				titel: $titel,
				grund: $grund,
				hohe: $hoehedesgelds,
			})
		);
	}
});
$(".tuning").on("click", ".tuning-container", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"http://SevenLife_Mechaniker/GetTuningOptions",
		JSON.stringify({ name: $name })
	);
});

$(".tuning").on("click", ".container-tuning-id", function () {
	var $button = $(this);

	var $name = $button.attr("name");
	var $modnumber = $button.attr("modnumber");
	var $modtype = $button.attr("modtype");
	var $tint = $button.attr("tint");
	$.post(
		"http://SevenLife_Mechaniker/TryTuning",
		JSON.stringify({
			name: $name,
			modnumber: $modnumber,
			modtype: $modtype,
			tint: $tint,
		})
	);
});

$(".auszahlbutton123").click(function () {
	CloseAll();
	$.post("http://SevenLife_Mechaniker/BuyUpgrades", JSON.stringify({}));
});

document.querySelectorAll('input[type="range"]').forEach((input) => {
	input.addEventListener("mousedown", () =>
		window.getSelection().removeAllRanges()
	);
});
$(document).keydown(function (e) {
	if (e.key === "d") {
		$.post(
			"http://SevenLife_Mechaniker/rotationleft",
			JSON.stringify({ value: -5 })
		);
	}
});
$(document).keydown(function (e) {
	if (e.key === "a") {
		$.post(
			"http://SevenLife_Mechaniker/rotationright",
			JSON.stringify({ value: 5 })
		);
	}
});
function MakeLohn(item) {
	$.each(item, function (index, items) {
		if (items.grade == 0) {
			document.getElementById("praktilohn").value = items.salary;
		} else if (items.grade == 1) {
			document.getElementById("lehrlinglohn").value = items.salary;
		} else if (items.grade == 2) {
			document.getElementById("gesellelohn").value = items.salary;
		} else if (items.grade == 3) {
			document.getElementById("meisterlohn").value = items.salary;
		} else if (items.grade == 4) {
			document.getElementById("cheflohn").value = items.salary;
		}
	});
}
