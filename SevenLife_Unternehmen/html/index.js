var valid = true;

$("document").ready(function () {
	$(".besuchen").hide();
	//$(".Übersicht").hide();
	$(".aktuelles").hide();
	$(".Shops").hide();
	$(".SachenAuslagern").hide();
	$(".SachenEinlagern").hide();
	$(".Geldabheben").hide();
	$(".Tankstellen").hide();
	$(".PreiseItems").hide();
	$(".container-shop").hide();
	$(".GeldabhebenTanke").hide();
	$(".Autoskaufen").hide();
	$(".Seite-Shop").hide();
	$(".BenzinKaufen").hide();
	$(".Seite-Tankstellen").hide();
	$(".Josie-Container").hide();
	$(".ShopVerkaufen").hide();
	$(".TankeVerkaufen").hide();
	$(".container-jobs").hide();
	$(".GeldabhebenTanke").hide();
	$(".Bohrer").hide();
	$(".computer").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "MakeInteraktionsMenu") {
			$(".HaveUnternehmen").show();
		} else if (event.data.type === "OpenMenuBesuch") {
			$(".besuchen").show();
		} else if (event.data.type === "OpenNormalMenu") {
			$(".gointohotel").show();
		} else if (event.data.type === "LeaveGarage") {
			$(".gofromgarage").show();
		} else if (event.data.type === "LeaveDach") {
			$(".leavedach").show();
		} else if (event.data.type === "OpenPC") {
			$(".computer").show();
			$(".Übersicht").show();
			$(".aktuelles").hide();
			$(".Shops").hide();
			$(".SachenAuslagern").hide();
			$(".SachenEinlagern").hide();
			$(".Geldabheben").hide();
			$(".PreiseItems").hide();
			$(".Seite-Shop").hide();
			$(".Tankstellen").hide();
			$(".BenzinKaufen").hide();
			if (msg.result !== undefined) {
				document.getElementById("CashFirma").innerHTML =
					msg.result + "$"; //Cash
			} else {
				document.getElementById("CashFirma").innerHTML = "0$"; //Cash
			}
			if (msg.cars !== undefined) {
				document.getElementById("CarsFirma").innerHTML =
					msg.cars + " Stück"; // Cars
			} else {
				document.getElementById("CarsFirma").innerHTML = "0 Stück"; //Cash
			}
			if (msg.shops !== undefined) {
				document.getElementById("ShopsStück").innerHTML =
					msg.shops + " Stück"; // Shops
			} else {
				document.getElementById("ShopsStück").innerHTML = "0 Stück"; //Cash
			}
			if (msg.herstellung !== undefined) {
				document.getElementById("herstellung").innerHTML =
					msg.herstellung; // Items
			} else {
				document.getElementById("herstellung").innerHTML = "0"; // Items
			}
			if (msg.LiterTanke !== undefined) {
				document.getElementById("LiterTanke").innerHTML =
					msg.LiterTanke + "L"; // Tankstellen
			} else {
				document.getElementById("LiterTanke").innerHTML = "0L"; // Tankstellen
			}
			if (msg.TankenWert !== undefined) {
				document.getElementById("WertTanke").innerHTML =
					msg.TankenWert + "$"; // Tankstellen
			} else {
				document.getElementById("WertTanke").innerHTML = "0$"; // Tankstellen
			}
			if (msg.LiterPreis !== undefined) {
				document.getElementById("LiterPreisTanke").innerHTML =
					msg.LiterPreis + "$"; // Tankstellen
			} else {
				document.getElementById("LiterPreisTanke").innerHTML = "0$"; // Tankstellen
			}
			if (msg.angestellte !== undefined) {
				document.getElementById("Angestellte").innerHTML =
					msg.angestellte; // Angestellte
			} else {
				document.getElementById("Angestellte").innerHTML = "0"; // Tankstellen
			}
		} else if (event.data.type === "UpdateÜbersicht") {
			if (msg.result !== undefined) {
				document.getElementById("CashFirma").innerHTML =
					msg.result + "$"; //Cash
			} else {
				document.getElementById("CashFirma").innerHTML = "0$"; //Cash
			}
			if (msg.cars !== undefined) {
				document.getElementById("CarsFirma").innerHTML =
					msg.cars + " Stück"; // Cars
			} else {
				document.getElementById("CarsFirma").innerHTML = "0 Stück"; //Cash
			}
			if (msg.shops !== undefined) {
				document.getElementById("ShopsStück").innerHTML =
					msg.shops + " Stück"; // Shops
			} else {
				document.getElementById("ShopsStück").innerHTML = "0 Stück"; //Cash
			}
			if (msg.herstellung !== undefined) {
				document.getElementById("herstellung").innerHTML =
					msg.herstellung; // Items
			} else {
				document.getElementById("herstellung").innerHTML = "0"; // Items
			}
			if (msg.LiterTanke !== undefined) {
				document.getElementById("LiterTanke").innerHTML =
					msg.LiterTanke + "L"; // Tankstellen
			} else {
				document.getElementById("LiterTanke").innerHTML = "0L"; // Tankstellen
			}
			if (msg.TankenWert !== undefined) {
				document.getElementById("WertTanke").innerHTML =
					msg.TankenWert + "$"; // Tankstellen
			} else {
				document.getElementById("WertTanke").innerHTML = "0$"; // Tankstellen
			}
			if (msg.LiterPreis !== undefined) {
				document.getElementById("LiterPreisTanke").innerHTML =
					msg.LiterPreis + "$"; // Tankstellen
			} else {
				document.getElementById("LiterPreisTanke").innerHTML = "0$"; // Tankstellen
			}
			if (msg.angestellte !== undefined) {
				document.getElementById("Angestellte").innerHTML =
					msg.angestellte; // Angestellte
			} else {
				document.getElementById("Angestellte").innerHTML = "0"; // Tankstellen
			}
		} else if (event.data.type === "UpdateShopList") {
			InsertShops(msg.shops);
		} else if (event.data.type === "OpenShopMenu") {
			$(".Seite-Shop").show();
			document.getElementById("CashInCurrentShop").innerHTML =
				msg.shops + "$";
			document.getElementById("DescText").innerHTML =
				"Shop #" + msg.shopid;
			document.getElementById("Iteminit").innerHTML =
				msg.shopitem + "Items";
			InsertIntoHistory(msg.shopitemse);
			document
				.getElementById("sacheneinlagern")
				.setAttribute("shopid", msg.shopid);
			document
				.getElementById("GeldAbheben")
				.setAttribute("shopid", msg.shopid);
			document
				.getElementById("sachenauslagern")
				.setAttribute("shopid", msg.shopid);
			document
				.getElementById("preisevergeben")
				.setAttribute("shopid", msg.shopid);
			document
				.getElementById("Veröffentlichen")
				.setAttribute("shopid", msg.shopid);
		} else if (event.data.type === "OpenEinlagern") {
			InsertItemsIntoEinlagern(msg.items, msg.id);
			$(".SachenEinlagern").show();
			$(".Shops").hide();
		} else if (event.data.type === "UpdateEinlagern") {
			valid = true;
			InsertItemsIntoEinlagern(msg.items, msg.id);
		} else if (event.data.type === "UpdateShopGeld") {
			document.getElementById("CashInCurrentShop").innerHTML =
				msg.money + "$";
		} else if (event.data.type === "InsertAuslagernItems") {
			$(".Shops").hide();
			$(".SachenAuslagern").show();
			InsertAuslagernItems(msg.item, msg.id);
		} else if (event.data.type === "UpdateUnternehmenAuslagern") {
			InsertAuslagernItems(msg.item, msg.id);
		} else if (event.data.type === "InsertPreisSachen") {
			$(".Shops").hide();
			$(".PreiseItems").show();
			InsertItemsIntoPreisVergeben(msg.items, msg.id);
		} else if (event.data.type === "UpdateTankenList") {
			InsertTanken(msg.shops);
		} else if (event.data.type === "OpenTankeMenu") {
			$(".Seite-Tankstellen").show();
			document.getElementById("CashCurrentTankstelle").innerHTML =
				msg.money + "$";
			document.getElementById("DescText").innerHTML =
				"Shop #" + msg.shopid;
			document.getElementById("TankeLiterInit").innerHTML =
				msg.fuel + "Liter";
			InsertIntoHistoryTanke(msg.history);
			document
				.getElementById("sacheneinlagern")
				.setAttribute("shopid", msg.shopid);
			document
				.getElementById("GeldAbhebenTanke")
				.setAttribute("shopid", msg.shopid);
			document
				.getElementById("AuftragStarten")
				.setAttribute("shopid", msg.shopid);
		} else if (event.data.type === "UpdateTankeGeld") {
			document.getElementById("CashCurrentTankstelle").innerHTML =
				msg.money + "$";
		} else if (event.data.type === "OpenHarvestMenu") {
			$(".Bohrer").show();
		} else if (event.data.type === "OpenShop") {
			$(".container-shop").show();
			document.getElementById("shopnamepers").innerHTML = "Laden #1";
			document.getElementById("warenkorb-2").innerHTML = "0" + "$";
		} else if (event.data.type === "OpenFirstMenu") {
			$(".Josie-Container").show();
		} else if (event.data.type === "OpenJobNui") {
			$(".container-jobs").show();
			InsertJobs(msg.jobs, msg.firmennames);
		} else if (event.data.type === "OpenCarMenu") {
			InsertCars(msg.cars, msg.firma);
		}
	});
});
function InsertJobs(jobs, firma) {
	$(".scroll-container-jobs").html(" ");
	$.each(jobs, function (index, item) {
		if (item.anngenommen === false) {
			$(".scroll-container-jobs").append(
				`
				<div class="container-detail-job">
						<h1 class="textdetailjob">Auftrag - ${item.beschreibung}</h1>
						<div class="strichtxtjob"></div>
						<button
							type="button"
							class="Button-Annehmen"
							id="preisevergeben"
							beschreibung = "${item.beschreibung}"
							firma = "${item.firma}"
							autoid = "${item.id}"
							detail1 = "${item.detail1}"
							detail2 = "${item.detail2}"
							detail3 = "${item.detail3}"
							check = "${item.check}"
						>
							Annehmen
						</button>
					<h1 class="GeldFürAuftrag">100$</h1>
				</div>
			 `
			);
		}
	});
}
function InsertCars(cars, firma) {
	$(".scrollinnenline").html(" ");
	$.each(cars, function (index, item) {
		$(".scrollinnenline").append(
			`
			<div class="container-car-line">
				<div class="container-picture"><img
				src="src/${item.name}.png"
				class="imgpicture"
				alt=""
			/></div>
				<h1 class="container-car-line-text">
					${item.label} 
				</h1>
				<h1 class="container-car-line-price">${item.price}$</h1>
				<div class="container-car-line-textline"></div>
				<button class="Button-Buy-Car" name="${item.name}" price = "${item.price}" firma = "${firma}">
					Kaufen
				</button>
			</div>
			`
		);
	});
}
document.querySelectorAll('input[type="range"]').forEach((input) => {
	input.addEventListener("mousedown", () =>
		window.getSelection().removeAllRanges()
	);
});
$(".button-betreten").click(function () {
	$(".HaveUnternehmen").hide();
	$.post("http://SevenLife_Unternehmen/LeaveApartment", JSON.stringify({}));
});
$("#gointounternehmen").click(function () {
	$(".gointohotel").hide();
	$.post("http://SevenLife_Unternehmen/EnterApartment", JSON.stringify({}));
});
$("#GoIntoGarage").click(function () {
	$(".gointohotel").hide();
	$.post("http://SevenLife_Unternehmen/EnterGarage", JSON.stringify({}));
});
$("#GoIntoGarageFromDach").click(function () {
	$(".leavedach").hide();
	$.post("http://SevenLife_Unternehmen/EnterGarage", JSON.stringify({}));
});
$("#Leavegarage").click(function () {
	$(".gofromgarage").hide();
	$.post("http://SevenLife_Unternehmen/LeaveApartment", JSON.stringify({}));
});
$("#GarageBetreten").click(function () {
	$(".HaveUnternehmen").hide();
	$.post("http://SevenLife_Unternehmen/EnterGarage", JSON.stringify({}));
});
$("#EnterApartmentFromGarage").click(function () {
	$(".gofromgarage").hide();
	$.post("http://SevenLife_Unternehmen/EnterApartment", JSON.stringify({}));
});
$("#EnterAppartmentFromDach").click(function () {
	$(".leavedach").hide();
	$.post("http://SevenLife_Unternehmen/EnterApartment", JSON.stringify({}));
});
$("#LeaveDach").click(function () {
	$(".leavedach").hide();
	$.post("http://SevenLife_Unternehmen/LeaveApartment", JSON.stringify({}));
});
$("#EnterDach").click(function () {
	$(".gointohotel").hide();
	$.post("http://SevenLife_Unternehmen/EnterDach", JSON.stringify({}));
});
$("#EnterDachFromApartment").click(function () {
	$(".HaveUnternehmen").hide();
	$.post("http://SevenLife_Unternehmen/EnterDach", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".gointohotel").hide();
	$(".besuchen").hide();
	$(".container-jobs").hide();
	$(".computer").hide();
	$(".container-shop").hide();
	$(".Josie-Container").hide();
	$.post("https://SevenLife_Unternehmen/escape");
	$.post("http://SevenLife_Unternehmen/close", JSON.stringify({}));
	$.post("https://SevenLife_Unternehmen/closepc");
}

// PC Controls

$("#Übersicht").click(function () {
	$(".Übersicht").show();
	$(".aktuelles").hide();
	$(".Shops").hide();
	$(".Autoskaufen").hide();
	$(".Tankstellen").hide();
	$.post("https://SevenLife_Unternehmen/GetInfosÜbersicht");
});

$("#aktuelles").click(function () {
	$(".Übersicht").hide();
	$(".aktuelles").show();
	$(".Shops").hide();
	$(".Autoskaufen").hide();
	$(".Tankstellen").hide();
});
$("#shops").click(function () {
	$(".Übersicht").hide();
	$(".aktuelles").hide();
	$(".Shops").show();
	$(".Autoskaufen").hide();
	$(".Tankstellen").hide();
	$.post("https://SevenLife_Unternehmen/GetInfosShops");
});
$("#tanken").click(function () {
	$(".Übersicht").hide();
	$(".aktuelles").hide();
	$(".Shops").hide();
	$(".Autoskaufen").hide();
	$(".Tankstellen").show();
	$.post("https://SevenLife_Unternehmen/GetInfosTanken");
});
$("#AutoKaufen").click(function () {
	$(".Übersicht").hide();
	$(".aktuelles").hide();
	$(".Shops").hide();
	$(".Tankstellen").hide();
	$(".Autoskaufen").show();
	$.post("https://SevenLife_Unternehmen/GetInfosCars");
});
$(".backgeld").click(function () {
	$(".Geldabheben").hide();
	$(".Shops").show();
});
$(".GeldAbheben").click(function () {
	$(".Geldabheben").show();
	$(".Shops").hide();
});
function InsertShops(shops) {
	$(".container-background-shops-auswahl").html(" ");
	$.each(shops, function (index, item) {
		$(".container-background-shops-auswahl").append(
			`
			<button type="button" class="Button-Buy" shopid = "${item.ShopNumber}">
				Shop #${item.ShopNumber}
			</button>
         `
		);
	});
}

$(".computer").on("click", ".Button-Buy", function () {
	var $button = $(this);
	var $shopid = $button.attr("shopid");
	$.post(
		"http://SevenLife_Unternehmen/GetDetailsShops",
		JSON.stringify({ shopid: $shopid })
	);
});
$(".computer").on("click", "#sacheneinlagern", function () {
	var $button = $(this);
	var $shopid = $button.attr("shopid");
	$.post(
		"http://SevenLife_Unternehmen/GetDetailsEinlagern",
		JSON.stringify({ shopid: $shopid })
	);
});
$(".computer").on("click", "#GeldAbheben", function () {
	var $button = $(this);
	var id = $button.attr("shopid");
	$(".Shops").hide();
	$(".Geldabheben").show();
	document.getElementById("geld-abheben").setAttribute("id", id);
});
$(".computer").on("click", "#sachenauslagern", function () {
	var $button = $(this);
	var $shopid = $button.attr("shopid");
	$.post(
		"http://SevenLife_Unternehmen/GetDetailsAuslagern",
		JSON.stringify({ shopid: $shopid })
	);
});
function InsertIntoHistory(shops) {
	$(".container-scroll-itemsellder").html(" ");
	$.each(shops, function (index, item) {
		$(".container-scroll-itemsellder").append(
			`
			<div class="containerhistory">
									<h1 class="itemandamount">${item.item} 	x${item.anzahl}</h1>
									<div class="strichabgrenzung"></div>
									<h1 class="itemandamountmoney">	${item.preis}$</h1>
									<div class="strichabgrenzung2"></div>
									<h1 class="itemandamountzeit">
										${item.uhrzeit}
									</h1>
								</div>
         `
		);
	});
}
function InsertItemsIntoEinlagern(items, id) {
	$(".container-einlagern").html(" ");
	$.each(items, function (index, item) {
		$(".container-einlagern").append(
			`
			<div class="container-einlagern-root">
			<h1 class="text_name">${item.label}</h1>
			<input
				class="Inputt-item"
				id="Inputt-einlagern"
				placeholder="0"
			/>
			<button class="Button-Einlagern" shopid = "${id}" name = "${item.name}" label = "${item.label}">
				Einlagern
			</button>
		</div>
	        `
		);
	});
}

$(".computer").on("click", ".Button-Einlagern", function () {
	if (valid) {
		valid = false;
		var $button = $(this);
		var $shopid = $button.attr("shopid");
		var $name = $button.attr("name");
		var $label = $button.attr("label");
		var count = document.getElementById("Inputt-einlagern").value;
		$.post(
			"http://SevenLife_Unternehmen/InsertEinlagern",
			JSON.stringify({
				shopid: $shopid,
				name: $name,
				count: count,
				label: $label,
			})
		);
	}
});
$(".computer").on("click", ".geld-abheben", function () {
	var button = $(this);
	var id = button.attr("id");
	var $money = document.getElementById("Inputt-Money").value;
	$.post(
		"http://SevenLife_Unternehmen/EinzahlenGeld",
		JSON.stringify({
			money: $money,
			id: id,
		})
	);
});
function InsertAuslagernItems(items, shopnumber) {
	$(".container-auslagern").html(" ");
	$.each(items, function (index, item) {
		$(".container-auslagern").append(
			` <div class="container-auslagern-root">
			<h1 class="text_name">${item.label}</h1>
			<input
				class="Inputt-item"
				id="Inputt-einlagern"
				placeholder="0"
			/>
			<button class="Button-Auslagern" shopid = "${shopnumber}" name = "${item.item}" label = "${item.label}" name="">
				Auslagern
			</button>
	        `
		);
	});
}
$(".computer").on("click", ".Button-Auslagern", function () {
	if (valid) {
		valid = false;
		var $button = $(this);
		var $shopid = $button.attr("shopid");
		var $name = $button.attr("name");
		var $label = $button.attr("label");
		var count = document.getElementById("Inputt-einlagern").value;
		$.post(
			"http://SevenLife_Unternehmen/LagerItemAus",
			JSON.stringify({
				shopid: $shopid,
				name: $name,
				count: count,
				label: $label,
			})
		);
	}
});
$(".computer").on("click", ".Geld-Preismachen", function () {
	var $button = $(this);
	var id = $button.attr("shopid");
	var $name = $button.attr("name");
	var $label = $button.attr("label");
	var $money = parseFloat(
		$button.parent().find(".Inputt-PreisEingeben").val()
	);

	$.post(
		"http://SevenLife_Unternehmen/MakePreis",
		JSON.stringify({
			money: $money,
			id: id,
			name: $name,
			label: $label,
		})
	);
});
$(".computer").on("click", "#preisevergeben", function () {
	var $button = $(this);
	var $shopid = $button.attr("shopid");
	$.post(
		"http://SevenLife_Unternehmen/PreisVergeben",
		JSON.stringify({ shopid: $shopid })
	);
});
function InsertItemsIntoPreisVergeben(items, shopnumber) {
	$(".container-preise").html(" ");
	$.each(items, function (index, item) {
		$(".container-preise").append(
			` <div class="container-itempreise">
			<h1 class="nameofitempreis">${item.label}</h1>
			<div class="container-strich"></div>
			<input
				class="Inputt-PreisEingeben"
				id="Inputt-PreisEingeben"
				value = "${item.preis}"
				placeholder="0"
			/>
			<button
				class="Geld-Preismachen"
				id="Geld-Preismachen"
				shopid = "${shopnumber}" 
				name = "${item.item}" 
				label = "${item.label}"
			>
				<img
					src="src/outline_done_white_48dp.png"
					class="akzept"
					alt=""
				/>
			    </button>
		    </div>
	        `
		);
	});
}
$(".backgoing").click(function () {
	$(".Shops").show();
	$(".SachenAuslagern").hide();
	$(".SachenEinlagern").hide();
	$(".Geldabheben").hide();
	$(".PreiseItems").hide();
	$(".Seite-Shop").show();
	$(".ShopVerkaufen").hide();
});
$(".backgoing5").click(function () {
	$(".Tankstellen").show();
	$(".BenzinKaufen").hide();
});
$(".computer").on("click", "#verkaufshops", function () {
	var $button = $(this);
	$(".Shops").hide();
	$(".ShopVerkaufen").show();
});

$(".computer").on("click", "#Veröffentlichen", function () {
	var $box = $(this);
	$(".Shops").show();
	$(".ShopVerkaufen").hide();
	var id = $box.attr("shopid");
	var choice = $(".selectfraktion option:selected").text();
	var zeit = $(".selectfraktion2 option:selected").text();
	var preis = document.getElementById("Inputt-PaymentStart").value;
	var choicenumber;
	if (choice == "Auktion") {
		choicenumber = false;
	} else if (choice == "Sofort Kauf") {
		choicenumber = true;
	}

	if (zeit == "1h") {
		zeitnumber = 1;
	} else if (zeit == "2h") {
		zeitnumber = 2;
	} else if (zeit == "3h") {
		zeitnumber = 3;
	} else if (zeit == "4h") {
		zeitnumber = 4;
	} else if (zeit == "5h") {
		zeitnumber = 5;
	} else if (zeit == "6h") {
		zeitnumber = 6;
	} else if (zeit == "12h") {
		zeitnumber = 7;
	} else if (zeit == "24h") {
		zeitnumber = 8;
	}

	$.post(
		"https://SevenLife_Unternehmen/MakeAuktion",
		JSON.stringify({
			choice: choicenumber,
			zeit: zeitnumber,
			preis: preis,
			type: "shops",
			plate: id,
			count: 1,
			vehicleid: "shop",
			label: id,
		})
	);
});
function InsertTanken(shops) {
	$(".container-background-tankstellen-auswahl").html(" ");
	$.each(shops, function (index, item) {
		$(".container-background-tankstellen-auswahl").append(
			`
			<button type="button" class="Button-OpenTanke" shopid = "${item.tankstellennummer}">
				Tanke #${item.tankstellennummer}
			</button>
         `
		);
	});
}
$(".computer").on("click", ".Button-OpenTanke", function () {
	var $button = $(this);
	var $shopid = $button.attr("shopid");
	$.post(
		"http://SevenLife_Unternehmen/GetDetailsTanke",
		JSON.stringify({ shopid: $shopid })
	);
});
function InsertIntoHistoryTanke(shops) {
	$(".container-scroll-itemselldertanke").html(" ");
	$.each(shops, function (index, item) {
		$(".container-scroll-itemselldertanke").append(
			`
			<div class="containerhistory">
				<h1 class="itemandamount">${item.liter}</h1>
				<div class="strichabgrenzung"></div>
				<h1 class="itemandamountmoney">${item.preis}$</h1>
				<div class="strichabgrenzung2"></div>
				<h1 class="itemandamountzeit">
					${item.uhrzeit}
				</h1>
			</div>
         `
		);
	});
}
$(".computer").on("click", "#GeldAbhebenTanke", function () {
	var $button = $(this);
	var id = $button.attr("shopid");
	$(".GeldabhebenTanke").show();
	$(".Tankstellen").hide();
	document.getElementById("geld-abheben").setAttribute("id", id);
});

$(".backgeld2").click(function () {
	$(".GeldabhebenTanke").hide();
	$(".Tankstellen").show();
});
$(".computer").on("click", "#geld-abhebentanke", function () {
	var button = $(this);
	var id = button.attr("id");
	var $money = document.getElementById("Inputt-Money2").value;
	$.post(
		"http://SevenLife_Unternehmen/AuszahlenGeldTanke",
		JSON.stringify({
			money: $money,
			id: id,
		})
	);
});
$(".computer").on("click", "#VeröffentlichenTanke", function () {
	var $box = $(this);
	$(".Tankstellen").show();
	$(".TankeVerkaufen").hide();
	var id = $box.attr("shopid");
	var choice = $(".selectfraktion3 option:selected").text();
	var zeit = $(".selectfraktion4 option:selected").text();
	var preis = document.getElementById("Inputt-PaymentStartTanke").value;
	var choicenumber;
	if (choice == "Auktion") {
		choicenumber = false;
	} else if (choice == "Sofort Kauf") {
		choicenumber = true;
	}

	if (zeit == "1h") {
		zeitnumber = 1;
	} else if (zeit == "2h") {
		zeitnumber = 2;
	} else if (zeit == "3h") {
		zeitnumber = 3;
	} else if (zeit == "4h") {
		zeitnumber = 4;
	} else if (zeit == "5h") {
		zeitnumber = 5;
	} else if (zeit == "6h") {
		zeitnumber = 6;
	} else if (zeit == "12h") {
		zeitnumber = 7;
	} else if (zeit == "24h") {
		zeitnumber = 8;
	}

	$.post(
		"https://SevenLife_Unternehmen/MakeAuktion",
		JSON.stringify({
			choice: choicenumber,
			zeit: zeitnumber,
			preis: preis,
			type: "fuel",
			plate: id,
			count: 1,
			vehicleid: "fuel",
			label: id,
		})
	);
});
const container = document.querySelectorAll(".range-slider");
var currentliter = 0;
for (let i = 0; i < container.length; i++) {
	const slider = container[i].querySelector(".slider");
	const thumb = container[i].querySelector(".slider-thumb");
	const prgress = container[i].querySelector(".progress");
	function customslider() {
		const maxVal = slider.getAttribute("max");
		const val = (slider.value / maxVal) * 100 + "%";

		prgress.style.width = val;
		thumb.style.left = val;
	}
	customslider();
	slider.addEventListener("input", () => {
		customslider();
		var preis = slider.value * 10;
		document.getElementById("literauswählen").innerHTML =
			slider.value + " Liter - " + preis + "$";
		currentliter = slider.value;
	});
}

const pin1 = document.getElementById("pin1");
const pin2 = document.getElementById("pin2");
const pin3 = document.getElementById("pin3");
const pin4 = document.getElementById("pin4");

var selectedfuel = 0;
pin1.addEventListener("mouseover", (event) => {
	if (selectedfuel == 0) {
		document.getElementById("pin2bottom").style.borderTopColor = "black";
		document.getElementById("pin2").style.borderColor = "black";
		document.getElementById("pin3bottom").style.borderTopColor = "black";
		document.getElementById("pin3").style.borderColor = "black";

		document.getElementById("pin1bottom").style.borderTopColor = "red";
		document.getElementById("pin1").style.borderColor = "red";

		document.getElementById("pin4bottom").style.borderTopColor = "black";
		document.getElementById("pin4").style.borderColor = "black";
	}
});
pin2.addEventListener("mouseover", (event) => {
	if (selectedfuel == 0) {
		document.getElementById("pin1bottom").style.borderTopColor = "black";
		document.getElementById("pin1").style.borderColor = "black";
		document.getElementById("pin3bottom").style.borderTopColor = "black";
		document.getElementById("pin3").style.borderColor = "black";

		document.getElementById("pin2bottom").style.borderTopColor = "red";
		document.getElementById("pin2").style.borderColor = "red";
		document.getElementById("pin4bottom").style.borderTopColor = "black";
		document.getElementById("pin4").style.borderColor = "black";
	}
});
pin3.addEventListener("mouseover", (event) => {
	if (selectedfuel == 0) {
		document.getElementById("pin1bottom").style.borderTopColor = "black";
		document.getElementById("pin1").style.borderColor = "black";
		document.getElementById("pin2bottom").style.borderTopColor = "black";
		document.getElementById("pin2").style.borderColor = "black";
		document.getElementById("pin3bottom").style.borderTopColor = "red";
		document.getElementById("pin3").style.borderColor = "red";
		document.getElementById("pin4bottom").style.borderTopColor = "black";
		document.getElementById("pin4").style.borderColor = "black";
	}
});
pin4.addEventListener("mouseover", (event) => {
	if (selectedfuel == 0) {
		document.getElementById("pin1bottom").style.borderTopColor = "black";
		document.getElementById("pin1").style.borderColor = "black";
		document.getElementById("pin2bottom").style.borderTopColor = "black";
		document.getElementById("pin2").style.borderColor = "black";
		document.getElementById("pin3bottom").style.borderTopColor = "black";
		document.getElementById("pin3").style.borderColor = "black";
		document.getElementById("pin4bottom").style.borderTopColor = "red";
		document.getElementById("pin4").style.borderColor = "red";
	}
});

$(".pin1").click(function () {
	selectedfuel = 1;
	document.getElementById("pin1bottom").style.borderTopColor = "green";
	document.getElementById("pin2bottom").style.borderTopColor = "black";
	document.getElementById("pin2").style.borderColor = "black";
	document.getElementById("pin3bottom").style.borderTopColor = "black";
	document.getElementById("pin3").style.borderColor = "black";
	document.getElementById("pin1").style.borderColor = "green";
	document.getElementById("pin4bottom").style.borderTopColor = "black";
	document.getElementById("pin4").style.borderColor = "black";
});
$(".pin2").click(function () {
	selectedfuel = 2;
	document.getElementById("pin1bottom").style.borderTopColor = "black";
	document.getElementById("pin1").style.borderColor = "black";
	document.getElementById("pin3bottom").style.borderTopColor = "black";
	document.getElementById("pin3").style.borderColor = "black";
	document.getElementById("pin2bottom").style.borderTopColor = "green";
	document.getElementById("pin2").style.borderColor = "green";
	document.getElementById("pin4bottom").style.borderTopColor = "black";
	document.getElementById("pin4").style.borderColor = "black";
});
$(".pin3").click(function () {
	selectedfuel = 3;
	document.getElementById("pin1bottom").style.borderTopColor = "black";
	document.getElementById("pin1").style.borderColor = "black";
	document.getElementById("pin2bottom").style.borderTopColor = "black";
	document.getElementById("pin2").style.borderColor = "black";
	document.getElementById("pin3bottom").style.borderTopColor = "green";
	document.getElementById("pin3").style.borderColor = "green";
	document.getElementById("pin4bottom").style.borderTopColor = "black";
	document.getElementById("pin4").style.borderColor = "black";
});
$(".pin4").click(function () {
	selectedfuel = 4;
	document.getElementById("pin1bottom").style.borderTopColor = "black";
	document.getElementById("pin1").style.borderColor = "black";
	document.getElementById("pin2bottom").style.borderTopColor = "black";
	document.getElementById("pin2").style.borderColor = "black";
	document.getElementById("pin3bottom").style.borderTopColor = "black";
	document.getElementById("pin3").style.borderColor = "black";
	document.getElementById("pin4bottom").style.borderTopColor = "green";
	document.getElementById("pin4").style.borderColor = "green";
});
$(".computer").on("click", "#HolenBenzin", function () {
	var $button = $(this);
	$(".Tankstellen").hide();
	$(".BenzinKaufen").show();
});
$(".computer").on("click", "#AuftragStarten", function () {
	var $button = $(this);
	var id = $button.attr("shopid");
	$(".Tankstellen").show();
	$(".BenzinKaufen").hide();
	$(".computer").hide();
	$.post(
		"https://SevenLife_Unternehmen/StartAuftrag",
		JSON.stringify({
			currentliter: currentliter,
			selectedfuel: selectedfuel,
			id: id,
		})
	);
});
var counter = 0;
const circle = document.querySelector(".circle");

circle.addEventListener("mouseover", () => {
	const computedStyle = getComputedStyle(circle);
	const topColor = computedStyle.getPropertyValue("border-top-color");
	const rightColor = computedStyle.getPropertyValue("border-right-color");

	if (topColor === rightColor) {
		circle.addEventListener(
			"animationend",
			() => {
				circle.classList.add("filled");
				circle.style.pointerEvents = "none";
				counter = counter + 1;
				console.log(counter);
				if (counter == 4) {
					$(".Bohrer").hide();
					$.post(
						"https://SevenLife_Unternehmen/FuelFertig",
						JSON.stringify({})
					);
					reset();
				}
			},
			{ once: true }
		);
	}
});
const circle1 = document.querySelector(".circle1");

circle1.addEventListener("mouseover", () => {
	const computedStyle = getComputedStyle(circle1);
	const topColor = computedStyle.getPropertyValue("border-top-color");
	const rightColor = computedStyle.getPropertyValue("border-right-color");

	if (topColor === rightColor) {
		circle1.addEventListener(
			"animationend",
			() => {
				circle1.classList.add("filled");
				circle1.style.pointerEvents = "none";
				counter = counter + 1;
				console.log(counter);
				if (counter == 4) {
					$(".Bohrer").hide();
					$.post(
						"https://SevenLife_Unternehmen/FuelFertig",
						JSON.stringify({})
					);
					reset();
				}
			},
			{ once: true }
		);
	}
});
const circle2 = document.querySelector(".circle2");

circle2.addEventListener("mouseover", () => {
	const computedStyle = getComputedStyle(circle2);
	const topColor = computedStyle.getPropertyValue("border-top-color");
	const rightColor = computedStyle.getPropertyValue("border-right-color");

	if (topColor === rightColor) {
		circle2.addEventListener(
			"animationend",
			() => {
				circle2.classList.add("filled");
				circle2.style.pointerEvents = "none";
				counter = counter + 1;
				console.log(counter);

				if (counter == 4) {
					$(".Bohrer").hide();
					$.post(
						"https://SevenLife_Unternehmen/FuelFertig",
						JSON.stringify({})
					);
					reset();
				}
			},
			{ once: true }
		);
	}
});
const circle3 = document.querySelector(".circle3");

circle3.addEventListener("mouseover", () => {
	const computedStyle = getComputedStyle(circle3);
	const topColor = computedStyle.getPropertyValue("border-top-color");
	const rightColor = computedStyle.getPropertyValue("border-right-color");

	if (topColor === rightColor) {
		circle3.addEventListener(
			"animationend",
			() => {
				circle3.classList.add("filled");
				circle3.style.pointerEvents = "none";
				counter = counter + 1;
				console.log(counter);
				if (counter == 4) {
					$(".Bohrer").hide();
					$.post(
						"https://SevenLife_Unternehmen/FuelFertig",
						JSON.stringify({})
					);
					reset();
				}
			},
			{ once: true }
		);
	}
});
function reset() {
	circle.style.transform = "";
	circle.style.borderBottom = "";
	circle.style.borderLeft = "";
	circle.classList.remove("filled");
	circle1.style.transform = "";
	circle1.style.borderBottom = "";
	circle1.style.borderLeft = "";
	circle1.classList.remove("filled");
	circle2.style.transform = "";
	circle2.style.borderBottom = "";
	circle2.style.borderLeft = "";
	circle2.classList.remove("filled");
	circle3.style.transform = "";
	circle3.style.borderBottom = "";
	circle3.style.borderLeft = "";
	circle3.classList.remove("filled");
}
var list = {};
$(".container-shop").on("click", ".Button-addtocard", function () {
	var $button = $(this);

	var $name = $button.attr("name");
	var $item = $button.attr("item");
	var $src = $button.attr("src");
	var $count = parseFloat($button.parent().find(".Inputt-Shop").val());

	if ($count) {
		var $vorhandencount = $button.attr("count");
		var $price = parseFloat($button.attr("names"));
		var $realprice = $price * $count;
		var $realprices = 1.02 * $realprice;
		var $oldprice = document
			.getElementById("warenkorb-2")
			.getAttribute("data-value");
		var price = parseInt($realprices);
		var oldprice = parseInt($oldprice);
		var $newprice = oldprice + price;
		document
			.getElementById("warenkorb-2")
			.setAttribute("data-value", $newprice);
		document.getElementById("warenkorb-2").innerHTML = $newprice + "$";

		if ($vorhandencount >= $count) {
			list += $name;
			$(".warenkorb-shop").append(
				`
			<div class="container-container-warnekorb" item = "${$item}" name ="${$name}" names ="${$count}" preis = "${price}">
				<img
					src="src/${$src}.png"
					class="img-warenkorb"
					alt=""
				/>
				<div class="line-unter8"></div>
				<h1 class="name-warenkorb">${$name}</h1>
				<h1 class="name-preis">${price}$</h1>
				<h1 class="name-anzahl">${$count}Stk.</h1>
			</div>
        `
			);
		}
	}
});
$(".container-shop").on("click", ".Button-Buy-Shop", function () {
	var value = document.getElementsByClassName(
		"container-container-warnekorb"
	);
	for (var i = 0; i < value.length; i++) {
		console.log(value.length);
		console.log(i);
		var item = value[i].getAttribute("item");
		var countofitem = value[i].getAttribute("names");
		var preis = value[i].getAttribute("preis");
		$(".container-shop").fadeOut(500);
		$.post("http://SevenLife_Unternehmen/close", JSON.stringify({}));
		$.post(
			"http://SevenLife_Unternehmen/BuyItems",
			JSON.stringify({ Count: countofitem, Item: item, preis: preis })
		);
	}
	$(".warenkorb-shop").html(" ");
	document.getElementById("warenkorb-2").setAttribute("data-value", "0");
	document.getElementById("warenkorb-2").innerHTML = "0" + "$";
});

$(".buttonabbrechen2").click(function () {
	CloseMenu();
});
$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_Unternehmen/Shops", JSON.stringify({}));
});
$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_Unternehmen/closes", JSON.stringify({}));
});
$(".submitjobs").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_Unternehmen/OpenJobMenu", JSON.stringify({}));
});
$(".closejobs").click(function () {
	CloseMenu();
});
$(".container-jobs").on("click", ".Button-Annehmen", function () {
	var $button = $(this);
	var id = $button.attr("firma");
	var coomonid = $button.attr("autoid");
	var beschreibung = $button.attr("beschreibung");
	var detail1 = $button.attr("detail1");
	var detail2 = $button.attr("detail2");
	var detail3 = $button.attr("detail3");
	var check = $button.attr("check");

	CloseMenu();
	$.post(
		"https://SevenLife_Unternehmen/StartJob",
		JSON.stringify({
			id: id,
			comid: coomonid,
			bschreibung: beschreibung,
			detail1: detail1,
			detail2: detail2,
			detail3: detail3,
			check: check,
		})
	);
});
$(".computer").on("click", ".Button-Buy-Car", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $price = $button.attr("price");
	var $firma = $button.attr("firma");
	$.post(
		"http://SevenLife_Unternehmen/BuyCar",
		JSON.stringify({ name: $name, price: $price, firma: $firma })
	);
});
