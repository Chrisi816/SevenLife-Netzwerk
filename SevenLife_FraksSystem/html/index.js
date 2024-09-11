SL = {};

SL.Inventory = {};
SL.Inventory.MaxSlots = 18;
SL.FRAK = false;
$("document").ready(function () {
	$(".inventoryWaffenschrank").hide();
	$(".frakmitglieder").hide();
	$(".frakmenu").hide();
	$(".container-bauern").hide();
	$(".invitemenu").hide();
	//$(".frakfrontside").hide();
	$(".tasks").hide();
	$(".rating").hide();
	//$(".mainpage").hide();
	$(".container-garage").hide();
	$(".bos-menu-mechaniker").hide();
	//$(".mainpage-boss").hide();
	$(".kaufenpage").hide();
	$(".garagepage").hide();
	$(".angestellte-list").hide();
	$(".geld-taken").hide();
	$(".lohnsite").hide();
	$(".Rechnungen").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenInventoryWaffenSchrankFRAK") {
			SL.FRAK = true;
			$(".inventoryWaffenschrank").show();
			SL.Inventory.MakeSlotsWaffenSchrank(
				msg.items,
				msg.slots,
				54,
				msg.boxexglov,
				msg.inventorykofferaum,
				msg.weapons
			);
			document.getElementById("inventoryweightwaffenschrank").innerHTML =
				msg.plyweight + " / 100.0";
		} else if (event.data.type === "UpdateWaffenschrankFRAK") {
			SL.Inventory.UpdateWaffenschrank(msg.list, msg.items, msg.weapons);
		} else if (event.data.type === "OpenFrakInvite") {
			$(".invitemenu").show();
			document.getElementById(
				"textinfoeinladung"
			).innerHTML = `Der spieler ${msg.name} möchte dich in die
			Fraktion ${msg.frak} einladen. Willst du diese Einladenung
			annehmen/ablehenen?`;
			document.getElementById("Ablehnen").setAttribute("id", msg.id);
			document.getElementById("Annehmen").setAttribute("id", msg.id);
			document.getElementById("Annehmen").setAttribute("id", msg.frak);
		} else if (event.data.type === "OpenFrakMenu") {
			$(".frakmenu").show();
			document.getElementById("levelnummero1").innerHTML = msg.level;
			document.getElementById("levelnummero2").innerHTML = msg.level;
			document.getElementById("xpma").innerHTML = msg.nochwieviel;
			document.getElementById("leaderinfo").innerHTML = msg.leader;
			document.getElementById("ranginfo5").innerHTML =
				msg.mitglieder + " Mitglieder";
			document.getElementById("reichtum").innerHTML = msg.reichtum + " $";
			document.getElementById("frakname").innerHTML = msg.namederfamilie;
			document.getElementById("frakinfohistory").innerHTML =
				msg.descderfamilie;
			document.getElementById("process").style.width =
				parseInt(msg.xp) + "px";
			document.getElementById("ranginfo3").innerHTML =
				msg.onlinepersonen + " Person(en)";
			if (msg.colorpallete === "LCS") {
				document.getElementById("familietext1").style.color = "#121211";
				document.getElementById("levelnummero1").style.color =
					"#121211";
				document.getElementById("ranginfo").style.color = "#121211";
				document.getElementById("titelevent").style.color = "#121211";
				document.getElementById("ranginfo3").style.color = "#121211";
				document.getElementById("leaderinfo").style.color = "#121211";
				document.getElementById("levelnummero2").style.color =
					"#121211";
				document.getElementById("xpma").style.color = "#121211";
				document.getElementById("ranginfo5").style.color = "#121211";
				document.getElementById("reichtum").style.color = "#121211";
				document.getElementById("left3").style.background =
					"linear-gradient(to left,rgb(18, 18, 17),rgba(0, 0, 255, 0) 95.71%);;";
				document.getElementById("right3").style.background =
					"linear-gradient(to right,rgb(18, 18, 17),rgba(0, 0, 255, 0) 95.71%);;";
			}
		} else if (event.data.type === "InsertMembers") {
			InsertMembers(msg.result);

			document.getElementById("anzahlonlinemitglieder").innerHTML =
				msg.onlinepersonen;
			document.getElementById("mitgliedertext").innerHTML =
				msg.insgesamtplayer;
		} else if (event.data.type === "OpenGarageLCN") {
			$(".container-garage").show();
			$(".mainpage").show();
			$(".kaufenpage").hide();
			$(".garagepage").hide();
			OpenVehicleShop(msg.list);
		} else if (event.data.type === "AddGarage") {
			OpeenGarageItem(msg.name, msg.plate);
		} else if (event.data.type === "OpenSpecialItems") {
			document.getElementById("lokalerbauertext").innerHTML = msg.frak;
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
			$(".container-bauern").show();
			MakeNuis(msg.items);
		} else if (event.data.type === "UpdateMoney") {
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
		} else if (event.data.type === "OpenBossMenu") {
			var ds = 0;
			$(".bos-menu-mechaniker").show();
			$(".mainpage-boss").show();

			document.getElementById("geld-boss").innerHTML = msg.cash + "$";
			$.each(msg.result, function (index, item) {
				ds++;
			});
			$.each(msg.informationen, function (index, item) {
				document.getElementById("familienname").innerHTML =
					"Famlilien Name: " + item.name;
				document.getElementById("standort").innerHTML =
					"Standort: " + item.standort;
				document.getElementById("businnes").innerHTML =
					"Business: " + item.bussiness;
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
		} else if (event.data.type === "OpenAngestellte") {
			$(".angestellte-list").show();
			MakeAngestellte(msg.result);
		} else if (event.data.type === "UpdateAngestellte") {
			MakeAngestellte(msg.result);
		} else if (event.data.type === "UpdateRanking") {
			InsertRanking(msg.list);
		}
	});
});
SL.Inventory.MakeSlotsWaffenSchrank = function (
	items,
	slots,
	limit,
	slotkofferraum,
	inventorygloves,
	weapons
) {
	$(".playeritems").html("");
	$(".waffenschrank").html("");
	document.getElementById("inputt-waffenschrank").value = 1;
	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-waffenschrank .playeritems").append(
			`<div data-slot="${i}" class="item-box"></div>`
		);
	}

	var c = 0;
	glovesslot = slotkofferraum;
	for (i = 1; i < slotkofferraum + 1; i++) {
		$(".waffenschrank").append(
			`<div data-slot="${i}" class="item-box-waffenschrank"></div>`
		);
	}

	$.each(items, function (k, v) {
		if (v != null) {
			d++;
			$(".playeritems")
				.find(`[data-slot="${d}"]`)
				.append(
					`
                    <img class="img-am" src="items/${v.name}.png">
                    <div class="item-amount">${v.count}</div>
                    <div class="item-name">${v.label}</div>
                    <div class="action" name=${v.name} label = ${v.label}></div>
            `
				)
				.attr("data-name", v.name)
				.attr("data-label", v.label)
				.attr("data-weapon", "item")
				.attr("data-inventory", "inventory");
		}
	});

	$.each(weapons, function (k, v) {
		if (v != null) {
			d++;
			$(".playeritems")
				.find(`[data-slot="${d}"]`)
				.append(
					`
                    <img class="img-am" src="items/${v.name}.png">
                    <div class="item-amount">1</div>
                    <div class="item-name">${v.label}</div>
                    <div class="action" name=${v.name} label = ${v.label}></div>
            `
				)
				.attr("data-name", v.name)
				.attr("data-label", v.label)
				.attr("data-weapon", "weapon")
				.attr("data-inventory", "inventory");
		}
	});

	$.each(inventorygloves, function (k, v) {
		if (v != null) {
			c++;
			$(".waffenschrank")
				.find(`[data-slot="${c}"]`)
				.append(
					`
				
					    <img class="img-am" src="items/${v.items}.png" />
					    <div class="item-amount">${v.anzahl}</div>
						<div class="item-name">${v.label}</div>
					    <div class="action" name=${v.items} label = ${v.label}></div>
				 
                
            `
				)
				.attr("data-name", v.items)
				.attr("data-label", v.label)
				.attr("data-weapon", "item")
				.attr("data-inventory", "waffenschrank");
		}
	});

	SL.Inventory.SetUpInventoryWaffenschrank();
};

SL.Inventory.SetUpInventoryWaffenschrank = function () {
	$(".item-box").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryWaffenschrank",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".item-box-waffenschrank").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryWaffenschrank",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".waffenschrank")
		.off()
		.droppable({
			drop: function (event, ui) {
				var inventory = ui.draggable.attr("data-inventory");
				if (inventory === "inventory") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl = document.getElementById(
						"inputt-waffenschrank"
					).value;
					var label = ui.draggable.attr("data-label");
					var type = ui.draggable.attr("data-weapon");
					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminwaffenschrankfrak",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
								type: type,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminwaffenschrankfrak",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
								type: type,
							})
						);
					}
				}
			},
		});

	$(".playeritems")
		.off()
		.droppable({
			drop: function (event, ui) {
				var inventory = ui.draggable.attr("data-inventory");
				if (inventory === "waffenschrank") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl = document.getElementById(
						"inputt-waffenschrank"
					).value;
					var label = ui.draggable.attr("data-label");
					var type = ui.draggable.attr("data-weapon");
					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminventorywaffenschrankfrak",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
								type: type,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminventorywaffenschrankfrak",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
								type: type,
							})
						);
					}
				}
			},
		});
};

$(document).on("keydown", function (event) {
	switch (event.keyCode) {
		case 27:
			SL.Inventory.CloseWaffenschrank();
			break;
	}
});

SL.Inventory.CloseWaffenschrank = function () {
	$.post("https://" + GetParentResourceName() + "/CloseWaffenSchrank");
	$.post("https://" + GetParentResourceName() + "/CloseFamilienMenu");
	document.getElementById("playeritems").innerHTML = "";
	$(".inventory").hide();
	$(".frakmenu").hide();
	CloseAll();
	$(".inventoryWaffenschrank").hide();
	$(".inventoryTrunk").hide();
	$(".inventoryGlove").hide();
};
SL.Inventory.UpdateWaffenschrank = function (items, inventoryitems, weapons) {
	$(".waffenschrank").html("");
	$(".playeritems").html("");

	var c = 0;
	for (i = 1; i < glovesslot + 1; i++) {
		$(".waffenschrank").append(
			`<div data-slot="${i}"class="item-box-waffenschrank"></div>`
		);
	}

	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-waffenschrank .playeritems").append(
			`<div data-slot="${i}"class="item-box"></div>`
		);
	}

	$.each(inventoryitems, function (k, v) {
		if (v != null) {
			d++;
			$(".playeritems")
				.find(`[data-slot="${d}"]`)
				.append(
					`
                    <img class="img-am" src="items/${v.name}.png">
                    <div class="item-amount">${v.count}</div>
                    <div class="item-name">${v.label}</div>
                    <div class="action" name=${v.name} label = ${v.label}></div>
            `
				)
				.attr("data-name", v.name)
				.attr("data-label", v.label)
				.attr("data-weapon", "item")
				.attr("data-inventory", "inventory");
		}
	});

	$.each(weapons, function (k, v) {
		if (v != null) {
			d++;
			$(".playeritems")
				.find(`[data-slot="${d}"]`)
				.append(
					`
                    <img class="img-am" src="items/${v.name}.png">
                    <div class="item-amount">1</div>
                    <div class="item-name">${v.label}</div>
                    <div class="action" name=${v.name} label = ${v.label}></div>
            `
				)
				.attr("data-name", v.name)
				.attr("data-label", v.label)
				.attr("data-weapon", "weapon")
				.attr("data-inventory", "inventory");
		}
	});

	$.each(items, function (k, v) {
		if (v != null) {
			c++;
			$(".waffenschrank")
				.find(`[data-slot="${c}"]`)
				.append(
					`
				
					    <img class="img-am" src="items/${v.items}.png" />
					    <div class="item-amount">${v.anzahl}</div>
						<div class="item-name">${v.label}</div>
					    <div class="action" name=${v.items} label = ${v.label}></div>
            `
				)
				.attr("data-name", v.items)
				.attr("data-label", v.label)
				.attr("data-weapon", "item")
				.attr("data-inventory", "waffenschrank");
		}
	});

	SL.Inventory.SetUpInventoryWaffenschrank();
};
$("#Annehmen").click(function () {
	var $button = $(this);
	$(".invitemenu").hide();
	var id = $button.attr("id");
	var job = $button.attr("job");
	$.post(
		"https://" + GetParentResourceName() + "/GiveMenuJob",
		JSON.stringify({
			job: job,
			id: id,
		})
	);
});
$("#Ablehnen").click(function () {
	$(".invitemenu").hide();
	var $button = $(this);
	var id = $button.attr("id");
	$.post(
		"https://" + GetParentResourceName() + "/CloseMenuAblehnen",
		JSON.stringify({
			id: id,
		})
	);
});
function searchanimasauslager() {
	$(".container-memberinfo").hide();
	let input = document.getElementById("inputts").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("container-memberinfo");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".mitgliedername")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
$(".informationen").click(function () {
	$(".frakfrontside").show();
	$(".frakmitglieder").hide();
	$(".tasks").hide();
	$(".rating").hide();
});
$(".mitglieder").click(function () {
	$(".frakfrontside").hide();
	$(".frakmitglieder").show();
	$(".tasks").hide();
	$(".rating").hide();
	$.post(
		"https://" + GetParentResourceName() + "/GetInfosAboutMitglieder",
		JSON.stringify({})
	);
});
function InsertMembers(items) {
	console.log("phse3");
	$(".container-scrollmember").html(" ");
	$.each(items, function (k, v) {
		var date = timeConverter();
		$(".container-scrollmember").append(`
		            <div class="container-memberinfo">
						<div class="kugelonline" id ="kugel-${k}" ></div>
						<h1 class="textifonline">${v.online}</h1>
						<h1 class="mitgliedername">${v.name}</h1>
						<h1 class="idname">${v.iduniqe}</h1>
						<h1 class="rangname">${v.rang}</h1>
						<h1 class="dataingamereg">${v.datajoin}</h1>
					</div>
		
		`);
		if (v.online === "ONLINE") {
			document.getElementById(`kugel-${k}`).style.backgroundColor =
				"rgb(212, 0, 194)";
		} else if (v.online === "OFFLINE") {
			document.getElementById(`kugel-${k}`).style.backgroundColor =
				"rgb(207, 0, 21)";
		}
	});
}
function timeConverter(UNIX_timestamp) {
	var a = new Date(UNIX_timestamp * 1000);
	var months = [
		"Jan",
		"Feb",
		"Mar",
		"Apr",
		"May",
		"Jun",
		"Jul",
		"Aug",
		"Sep",
		"Oct",
		"Nov",
		"Dec",
	];
	var year = a.getFullYear();
	var month = months[a.getMonth()];
	var date = a.getDate();
	var hour = a.getHours();
	var min = a.getMinutes();
	var sec = a.getSeconds();
	var time = date + " " + month + " " + year;
	return time;
}
var indialogmenu = false;
var inmenudialog = false;

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

function CloseAll() {
	$(".container-garage").hide();
	$(".kaufenpage").hide();
	$(".garagepage").hide();
	$(".container-bauern").hide();
	$(".bos-menu-mechaniker").hide();
	$.post("https://SevenLife_FraksSystem/CloseMenuBauer", JSON.stringify({}));
	$.post(
		"https://SevenLife_FraksSystem/CloseMenuMechaniker",
		JSON.stringify({})
	);
	$.post("https://SevenLife_FraksSystem/CloseMenu", JSON.stringify({}));
}
$(".container-garage").on("click", ".autoteil", function () {
	$(".container-garage").hide();
	var $button = $(this);
	var $name = $button.attr("name");
	var $price = $button.attr("preis");
	$.post(
		"https://SevenLife_FraksSystem/BuyVehicle",
		JSON.stringify({ car: $name, price: $price })
	);
});

$(".container-garage").on("click", ".autoteils", function () {
	$(".container-garage").hide();
	$(".autos-listes").html("");
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"https://SevenLife_FraksSystem/ParkVehicleOut",
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
	$.post("https://SevenLife_FraksSystem/GetVehicles", JSON.stringify({}));
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
		"https://SevenLife_FraksSystem/BuyItems",
		JSON.stringify({ name: $label, preis: $preis, rang: $rang })
	);
});
function MakeLohn(item) {
	$(".container-lohn").html(" ");
	$.each(item, function (index, items) {
		$(".container-lohn").append(
			`
			<div class="container-lohn-manage">
			<h1 class="text-rängeübersichtlohn">${items.grade}. ${items.label}</h1>
			<input
				class="inputt-Iban"
				id="praktilohn"
				placeholder="${items.salary}"
			/>
			<button
				type="button"
				name="${items.label}"
				class="buton-apply"
			>
				Bestätigen
			</button>
		</div>
            `
		);
	});
}
$(".auszahlbutton123").click(function () {
	SL.Inventory.CloseWaffenschrank();
	$.post("https://SevenLife_FraksSystem/BuyUpgrades", JSON.stringify({}));
});

document.querySelectorAll('input[type="range"]').forEach((input) => {
	input.addEventListener("mousedown", () =>
		window.getSelection().removeAllRanges()
	);
});
$("#rechnungen-boss").click(function () {
	$(".mainpage-boss").hide();
	$.post("https://SevenLife_FraksSystem/GetRechnungen", JSON.stringify({}));
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
	$.post("https://SevenLife_FraksSystem/GetOldLohn", JSON.stringify({}));
	$(".lohnsite").show();
});
$(".lohnsite").on("click", ".buton-apply", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $lohn = parseFloat($button.parent().find(".inputt-Iban").val());

	$.post(
		"https://SevenLife_FraksSystem/SetLohn",
		JSON.stringify({ type: $name, lohn: $lohn })
	);
});
$("#angestellte").click(function () {
	$(".mainpage-boss").hide();
	$.post("https://SevenLife_FraksSystem/GetMembers", JSON.stringify({}));
	$(".angestellte-list").show();
});
$(".angestellte-list").on("click", ".button-rankup", function () {
	var $button = $(this);
	var $id = $button.attr("id");

	$.post("https://SevenLife_FraksSystem/RankUp", JSON.stringify({ id: $id }));
});
$(".angestellte-list").on("click", ".button-rankdown", function () {
	var $button = $(this);
	var $id = $button.attr("id");
	$.post("https://SevenLife_FraksSystem/DeRank", JSON.stringify({ id: $id }));
});
$(".angestellte-list").on("click", ".button-feuern", function () {
	var $button = $(this);
	var $id = $button.attr("id");
	$.post("https://SevenLife_FraksSystem/feuern", JSON.stringify({ id: $id }));
});
$("#geld-bosstaken").click(function () {
	$(".mainpage-boss").hide();
	$(".geld-taken").show();
});

$("#submitbutton").click(function () {
	$(".mainpage-boss").show();
	$(".geld-taken").hide();
	SL.Inventory.CloseWaffenschrank();
	var $benutzer = document.getElementById("auszahlinputt1").value;
	$.post(
		"https://SevenLife_FraksSystem/Einzahlen",
		JSON.stringify({ cash: $benutzer })
	);
});
$("#submitbutton2").click(function () {
	$(".mainpage-boss").show();
	$(".geld-taken").hide();
	SL.Inventory.CloseWaffenschrank();
	var $benutzer = document.getElementById("auszahlinputt12").value;
	$.post(
		"https://SevenLife_FraksSystem/Auszahlen",
		JSON.stringify({ cash: $benutzer })
	);
});
function MakeAngestellte(items) {
	$(".container-angestellte").html(" ");

	$.each(items, function (index, item) {
		$(".container-angestellte").append(
			`
         <div class="container-angestellte-id">
						<h1 class="name-manage">
							${item.name}
						</h1>
						<h1 class="rank">${item.rang}</h1>
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
$(".aufgaben").click(function () {
	$(".frakfrontside").hide();
	$(".frakmitglieder").hide();
	$(".tasks").show();
	$(".rating").hide();
});
$(".ratings").click(function () {
	$(".frakfrontside").hide();
	$(".frakmitglieder").hide();
	$(".tasks").hide();
	$(".rating").show();
	$.post("https://SevenLife_FraksSystem/CheckWhoIsPlace", JSON.stringify({}));
});
function InsertRanking(items) {
	var firstthree = 1;
	$(".container-lastfraks").html(" ");
	var platz = 0;
	$.each(items, function (index, item) {
		platz++;
		if (firstthree === 1) {
			firstthree = 2;
			document.getElementById("namedelafrak2nummer1").innerHTML =
				item.frak;
			document.getElementById("howmanygebiet1nummer1").innerHTML =
				item.gebiete + "KM²";
			document.getElementById("howmanycriminalnummer1").innerHTML =
				item.krimmipunkte + "P.";
			document.getElementById("howmanylevelnummer1").innerHTML =
				item.level + "LVL";
		} else if (firstthree === 2) {
			document.getElementById("namedelafrak2nummer2").innerHTML =
				item.frak;
			document.getElementById("howmanygebiet1nummer2").innerHTML =
				item.gebiete + "KM²";
			document.getElementById("howmanycriminalnummer2").innerHTML =
				item.krimmipunkte + "P.";
			document.getElementById("howmanylevelnummer2").innerHTML =
				item.level + "LVL";
			firstthree = 3;
		} else if (firstthree === 3) {
			document.getElementById("namedelafrak2nummer3").innerHTML =
				item.frak;
			document.getElementById("howmanygebiet1nummer3").innerHTML =
				item.gebiete + "KM²";
			document.getElementById("howmanycriminalnummer3").innerHTML =
				item.krimmipunkte + "P.";
			document.getElementById("howmanylevelnummer3").innerHTML =
				item.level + "LVL";
			firstthree = 4;
		} else {
			$(".container-lastfraks").append(
				`
				<div class="container-frakname">
				<div class="nummerofcontainer">
					<h1 class="nummerincontainer">${platz}</h1>
				</div>
				<h1 class="namedelafrak">${item.frak}</h1>
				<div class="container-dreieck"></div>
				<h1 class="textgebiet">GEBIET:</h1>
				<h1 class="howmanygebiet">${item.gebiete} KM²</h1>
				<div class="container-dreieck1"></div>
				<h1 class="textcriminälepunke">Kriminelle Punkte:</h1>
				<h1 class="howmanycriminal">${item.points} P.</h1>
				<div class="container-dreieck2"></div>
				<h1 class="textlevel">LEVEL:</h1>
				<h1 class="howmanylevel">${item.level}LVL</h1>
			</div>
         `
			);
		}
	});
}
