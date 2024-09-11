var btc;
$("document").ready(function () {
	$(".kaufen").hide();
	$(".einlagernpage").hide();
	$(".entnehmne").hide();
	$(".mods").hide();
	$(".modifikationen").hide();
	$(".lager").hide();
	$(".auslagern").hide();
	//$(".hauptpage").hide();
	$(".container-bauern").hide();
	$(".seitemining").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		id = msg.id;
		preis = msg.preis;
		if (event.data.type === "openlagerhallekaufen") {
			$(".kaufen").fadeIn(400);
			showtimetNotification(msg.id, msg.preis, msg.quali);
		} else if (event.data.type === "removelagerhallekaufen") {
			$(".kaufen").fadeOut(300);
		} else if (event.data.type === "OpenLager") {
			$(".lager").fadeIn(500);
			$(".hauptpage").fadeIn(500);
			MakeEinlagern(msg.inventory);
			$(".modifikationen").hide();
			MakeAuslagern(msg.lagers);
			useweight = msg.lagerused;
			SETALLIN(
				msg.id,
				msg.btc,
				msg.eth,
				msg.lagerused,
				msg.platzupgrade,
				msg.mining
			);
		} else if (event.data.type === "UpdateRig") {
			InsertItems(msg.items);
			InsertThings(msg.itemse);
			document.getElementById("leistungmining").innerHTML =
				msg.leistung + "%";
			document.getElementById("cpumining").innerHTML = msg.cpu + "GHz";
			document.getElementById("rammining").innerHTML = msg.ram + "GB";
			document.getElementById("gpumining").innerHTML = msg.gpu + "MHz";
			document.getElementById("stromining").innerHTML =
				msg.endstrom + "W";
			document.getElementById("btccount").innerHTML = msg.btc + "BTC";
			btc = msg.btc;
		} else if (event.data.type === "UpdateKeys") {
			InsertThings(msg.items);
		} else if (event.data.type === "OpenComputer") {
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
			$(".container-bauern").show();
			MakeNuis(msg.items);
		} else if (event.data.type === "UpdateMoney") {
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
		}
	});
});
$(".close").click(function () {
	$(".kaufen").fadeOut(500);
	$.post("https://SevenLife_Lagerhallen/close", JSON.stringify({}));
});

function showtimetNotification(id, preis, quali) {
	document.getElementById("id").innerHTML = id;
	document.getElementById("ides").innerHTML = id;
	document.getElementById("geld").innerHTML = preis + "$";
	document.getElementById("quali").innerHTML = quali;
}

function SETALLIN(id, btc, eth, used, platz, mining) {
	document.getElementById("text-lagerhalle").innerHTML = "Lagerhalle " + id;
	document.getElementById("ether").innerHTML = eth + " ETH";
	document.getElementById("bitcoin").innerHTML = btc + " BTC";

	if (platz === "1") {
		document.getElementById("number").innerHTML = used + " / 200kg";
		document.getElementById("number1").innerHTML = used + " / 200kg";
		document.getElementById("number2").innerHTML = used + " / 200kg";
		document.getElementById("first").innerHTML = "Stufe 1";
		max = 200;
	} else if (platz === "2") {
		document.getElementById("number").innerHTML = used + " / 300kg";
		document.getElementById("number1").innerHTML = used + " / 300kg";
		document.getElementById("number2").innerHTML = used + " / 300kg";
		document.getElementById("first").innerHTML = "Stufe 2";
		max = 100;
	} else if (platz === "3") {
		document.getElementById("number").innerHTML = used + " / 400kg";
		document.getElementById("number1").innerHTML = used + " / 400kg";
		document.getElementById("number2").innerHTML = used + " / 400kg";
		document.getElementById("first").innerHTML = "Stufe 3";
		max = 100;
	} else {
		document.getElementById("number").innerHTML = used + " / 100kg";
		document.getElementById("number1").innerHTML = used + " / 100kg";
		document.getElementById("number2").innerHTML = used + " / 100kg";
		document.getElementById("first").innerHTML = "Nicht Aktiv";
	}
	if (mining === "true") {
		document.getElementById("second").innerHTML = "Aktiv";
	} else {
		document.getElementById("second").innerHTML = "Nicht Aktiv";
	}
}

function showinfoslagerhalle() {}

$(".submitbuttonsees").click(function () {
	$.post(
		"https://SevenLife_Lagerhallen/buying",
		JSON.stringify({ id: id, preis: preis })
	);
});

$(".einlagern").click(function () {
	$(".einlagernpage").fadeIn(500);
	$(".hauptpage").hide();
	$(".auslagern").hide();
	$(".modifikationen").hide();
});
$(".auslagerns").click(function () {
	$(".einlagernpage").hide();
	$(".hauptpage").hide();
	$(".modifikationen").hide();
	$(".auslagern").fadeIn(500);
});
$(".modi").click(function () {
	$(".modifikationen").fadeIn(500);
	$(".einlagernpage").hide();
	$(".hauptpage").hide();
	$(".auslagern").hide();
});

/*New */
$(".return").click(function () {
	$(".einlagernpage").hide();
	$(".hauptpage").fadeIn(600);
	$(".auslagern").hide();
	$(".modifikationen").hide();
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".lager ").fadeOut(300);
	$(".hauptpage").show();
	$(".modifikationen").hide();
	$(".einlagernpage").hide();
	$(".auslagern").hide();
	$(".kaufen").hide();
	$(".seitemining").hide();
	$(".container-bauern").hide();
	$.post("https://SevenLife_Lagerhallen/CloseMenu", JSON.stringify({}));
}

function MakeEinlagern(items) {
	$(".items1").html("");

	$.each(items, function (index, item) {
		$(".items1").append(
			`
         <div class="item-container">
                        <div class="rechteck-bild">
                            <div class="imgframe">
                              <img src="src/${item.label}.png" class="picturse" alt="">
                            </div>
                            <h1 class="itemname" id="name">
                              ${item.label}
                            </h1>
                            <span id="count">
                                 ${item.count}x
                            </span>
                        </div>
                        <div class="untens">
                          <input class="inputt" id="inputte" placeholder="0">
                          <button type="button" name= "${item.label}" names ="${item.weight}" id="submitbuttonsess" class="submitbuttons submit1">Accept</button>
                        </div>
                     </div>
         `
		);
	});
}
function MakeAuslagern(items) {
	$(".items2").html("");

	$.each(items, function (index, item) {
		$(".items2").append(
			`
         <div class="item-container">
         <div class="rechteck-bild">
             <div class="imgframe">
               <img src="src/${item.label}.png" class="picturse" alt="">
             </div>
             <h1 class="itemname" id="name">
               ${item.label}
             </h1>
             <span id="count">
                  ${item.count}x
             </span>
         </div>
         <div class="untens">
           <input class="inputt" id="inputte" placeholder="0">
           <button type="button" name= "${item.label}" names ="${item.weight}" id="submitbuttonsess" class="submitbuttons submit2">Accept</button>
         </div>
       </div>
         `
		);
	});
}

$(".lager").on("click", ".submit1", function () {
	CloseAll();
	var $button = $(this);
	var $name = $button.attr("name");
	var $count = parseFloat($button.parent().find(".inputt").val());
	var $weight = parseInt($button.attr("names"));
	var $engweight = $weight * $count;
	if ($engweight <= max) {
		$.post(
			"https://SevenLife_Lagerhallen/einlagern",
			JSON.stringify({
				item: $name,
				count: $count,
				lager: id,
				weight: $engweight,
				max: max,
			})
		);
	} else {
		$(".lager ").fadeOut(300);
		$(".hauptpage").hide();
		$.post(
			"https://SevenLife_Lagerhallen/keinplatzmehr",
			JSON.stringify({})
		);
	}
});

$(".lager").on("click", ".submit2", function () {
	CloseAll();
	var $button = $(this);
	var $name = $button.attr("name");
	var $count = parseFloat($button.parent().find(".inputt").val());
	var $weight = useweight;
	var $engweight = $weight * $count;
	$.post(
		"https://SevenLife_Lagerhallen/entnahmen",
		JSON.stringify({
			item: $name,
			count: $count,
			lager: id,
			weight: $engweight,
		})
	);
});

$(".submitupgradenr1").click(function () {
	$(".lager ").fadeOut(300);
	$(".hauptpage").hide();
	$.post(
		"https://SevenLife_Lagerhallen/kaufplatz",
		JSON.stringify({ id: 1 })
	);
});

$(".submitupgradenr2").click(function () {
	$(".lager ").fadeOut(300);
	$(".hauptpage").hide();
	$.post(
		"https://SevenLife_Lagerhallen/kaufplatz",
		JSON.stringify({ id: 2 })
	);
});

$(".submitupgradenr3").click(function () {
	$(".lager ").fadeOut(300);
	$(".hauptpage").hide();
	$.post(
		"https://SevenLife_Lagerhallen/kaufplatz",
		JSON.stringify({ id: 3 })
	);
});
$(".returntomain").click(function () {
	$(".seitemining").hide();
	$(".hauptpage").show();
});

$(".mining").click(function () {
	$(".seitemining").show();
	$(".hauptpage").hide();
	$.post("https://SevenLife_Lagerhallen/OpenMiningPage", JSON.stringify({}));
});

function InsertItems(items) {
	$(".container-items").html("");
	var d;
	$.each(items, function (index, item) {
		d++;
		$(".container-items").append(
			`
			<div data-slot="${d}" class="item-box-kofferaum" name = "${item.name}" data-name = "${item.name}" data-label = "${item.label}">
			<img class="img-am" src="src/box.png" />
			<div class="item-name">${item.label}</div>
			<div class="item-amount">${item.count}</div>
			<div class="action"></div>
		</div>
         `
		);
	});

	$(".item-box-kofferaum").each(function () {
		$(this).draggable({
			helper: "clone",
			appendTo: ".lager",
			revert: "invalid",
			containment: "document",
		});
	});

	$(".container-ram")
		.off()
		.droppable({
			drop: function (event, ui) {
				var name = ui.draggable.attr("data-name");
				var label = ui.draggable.attr("data-label");
				if (name == "sRAM" || name == "lRAM" || name == "seRAM") {
					$.post(
						"https://SevenLife_Lagerhallen/InsertItem",
						JSON.stringify({
							name: name,
							label: label,
							type: "RAM",
						})
					);
				}
			},
		});
	$(".container-gpu")
		.off()
		.droppable({
			drop: function (event, ui) {
				var name = ui.draggable.attr("data-name");
				var label = ui.draggable.attr("data-label");
				if (name == "sGPU" || name == "lGPU" || name == "seGPU") {
					$.post(
						"https://SevenLife_Lagerhallen/InsertItem",
						JSON.stringify({
							name: name,
							label: label,
							type: "GPU",
						})
					);
				}
			},
		});
	$(".container-cpu")
		.off()
		.droppable({
			drop: function (event, ui) {
				var name = ui.draggable.attr("data-name");
				var label = ui.draggable.attr("data-label");
				if (name == "sCPU" || name == "lCPU" || name == "seCPU") {
					$.post(
						"https://SevenLife_Lagerhallen/InsertItem",
						JSON.stringify({
							name: name,
							label: label,
							type: "CPU",
						})
					);
				}
			},
		});
}
function InsertThings(items) {
	$.each(items, function (index, item) {
		if (item.types === "CPU") {
			$(".container-listcpu").append(
				`
			<img
				src="src/box.png"
				class="imagedetasil"
				alt=""
			/>
			<div class="item-name2">${item.label}</div>
         `
			);
		} else if (item.types === "GPU") {
			$(".container-listgpu").append(
				`
			<img
				src="src/box.png"
				class="imagedetasil"
				alt=""
			/>
			<div class="item-name2">${item.label}</div>
         `
			);
		} else if (item.types === "RAM") {
			$(".container-listram").append(
				`
			<img
				src="src/box.png"
				class="imagedetasil"
				alt=""
			/>
			<div class="item-name2">${item.label}</div>
         `
			);
		}
	});
}

$(".submitauszahlen").click(function () {
	CloseAll();
	$.post("https://SevenLife_Lagerhallen/Auszahlen", JSON.stringify({ btc }));
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
					<button class="button-down" label = ${item.label} preis = ${item.preis}>Kaufen</button>
				</div>
            `
		);
	});
}

$(".container-bauern").on("click", ".button-down", function () {
	var $button = $(this);
	var $label = $button.attr("label");
	var $preis = $button.attr("preis");

	$.post(
		"https://SevenLife_Lagerhallen/BuyBauer",
		JSON.stringify({ name: $label, preis: $preis })
	);
});
