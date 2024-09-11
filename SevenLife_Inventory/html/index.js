SL = {};

SL.Inventory = {};
SL.Inventory.MaxSlots = 18;
SL.FRAK = false;
var glovesslot;
$("document").ready(function () {
	$(".inventory").hide();
	$(".contextmenu").hide();
	$(".inventoryGlovebox").hide();
	$(".inventoryTrunk").hide();
	$(".inventoryGlove").hide();
	$(".inventoryWaffenschrank").hide();
	$(".inventoryDurchsuchen").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenInventory") {
			$(".inventory").fadeIn();
			SL.Inventory.MakeSlots(msg.items, msg.slots, 54, msg.people);
			document.getElementById("inventoryweight").innerHTML =
				msg.weight + " / 100.0";
			document.getElementById("inputt-mainraum").value = "1";
		}
		if (event.data.type === "OpenInventory30KG") {
			$(".inventory").fadeIn();
			SL.Inventory.MakeSlots(msg.items, msg.slots, 64, msg.people);
			document.getElementById("inventoryweight").innerHTML =
				msg.weight + " / 130.0";
			document.getElementById("inputt-mainraum").value = "1";
		} else if (event.data.type === "OpenInventoryGloveBox") {
			$(".inventoryGlovebox").fadeIn();
			SL.Inventory.MakeSlotsGloveBox(msg.items, msg.slots, 54);
			document.getElementById("inventoryweight").innerHTML =
				msg.plyweight + " / 100.0";
		} else if (event.data.type === "OpenInventoryTrunk") {
			$(".inventoryTrunk").fadeIn();
			SL.Inventory.MakeSlotsTrunk(
				msg.items,
				msg.slots,
				54,
				msg.boxexglov,
				msg.inventorykofferaum,
				msg.carweight
			);
			document.getElementById("inventoryweighttrunk").innerHTML =
				msg.plyweight + " / 100.0";
			document.getElementById("inputt-kofferraum").value = "1";
		} else if (event.data.type === "OpenInventoryTrunk30KG") {
			$(".inventoryTrunk").fadeIn();
			SL.Inventory.MakeSlotsTrunk(
				msg.items,
				msg.slots,
				54,
				msg.boxexglov,
				msg.inventorykofferaum,
				msg.carweight
			);
			document.getElementById("inputt-kofferraum").value = "1";
			document.getElementById("inventoryweighttrunk").innerHTML =
				msg.plyweight + " / 130.0";
		} else if (event.data.type === "UpdateKofferraum") {
			SL.Inventory.UpdateTrunk(msg.list, msg.items);
		} else if (event.data.type === "CloseTrunk") {
			SL.Inventory.Close();
			SL.Inventory.CloseWaffenschrank();
		} else if (event.data.type === "OpenInventoryGlove") {
			$(".inventoryGlove").fadeIn();
			SL.Inventory.MakeSlotsGloves(
				msg.items,
				msg.slots,
				54,
				msg.boxexglov,
				msg.inventorykofferaum,
				msg.carweight
			);
			document.getElementById("inventoryweightgloves").innerHTML =
				msg.plyweight + " / 100.0";
			document.getElementById("inputt-glovesraum").value = "1";
		} else if (event.data.type === "OpenInventoryGlove30KG") {
			$(".inventoryGlove").fadeIn();
			SL.Inventory.MakeSlotsGloves(
				msg.items,
				msg.slots,
				54,
				msg.boxexglov,
				msg.inventorykofferaum,
				msg.carweight
			);
			document.getElementById("inventoryweightgloves").innerHTML =
				msg.plyweight + " / 130.0";
			document.getElementById("inputt-glovesraum").value = "1";
		} else if (event.data.type === "UpdateGloves") {
			SL.Inventory.UpdateGloves(msg.list, msg.items);
		} else if (event.data.type === "OpenInventoryWaffenSchrank") {
			$(".inventoryWaffenschrank").fadeIn();
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
			document.getElementById("inputt-waffenschrank").value = "1";
		} else if (event.data.type === "UpdateWaffenschrank") {
			SL.Inventory.UpdateWaffenschrank(msg.list, msg.items, msg.weapons);
		} else if (event.data.type === "OpenInventoryWaffenSchrankFRAK") {
			SL.FRAK = true;
			$(".inventoryWaffenschrank").fadeIn();
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
			document.getElementById("inputt-waffenschrank").value = "1";
		} else if (event.data.type === "UpdateWaffenschrankFRAK") {
			SL.Inventory.UpdateWaffenschrank(msg.list, msg.items, msg.weapons);
		} else if (event.data.type === "OpenInventoryDurchsuchen") {
			$(".inventoryDurchsuchen").hide();
			SL.Inventory.MakeSlotsDurchsuchen(
				msg.items,
				msg.slots,
				54,
				msg.targetinventory
			);

			document.getElementById("inventoryweightwaffenschrank").innerHTML =
				msg.plyweight + " / 130.0";
			document.getElementById("inputt-glovesraum").value = "1";
		} else if (event.data.type === "OpenInventoryDurchsuchenUpdate") {
			SL.Inventory.UpdateSlotsDurchsuchen(
				msg.list,
				msg.items,
				msg.weapons
			);
		}
	});
});

SL.Inventory.MakeSlots = function (items, slots, limit, people) {
	$(".playeritems").html("");
	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items .playeritems").append(
			`<div data-slot="${i}"class="item-box" type = "Inventory"></div>`
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
				.attr("data-label", v.label);
		}
	});
	$(".container-nearplayer").html("");
	$.each(people, function (k, v) {
		$(".container-nearplayer").append(
			`
				<div class="container-player">
				<h1 class="nameofplayer">${v.name}</h1>
				<div class="designundername"></div>
				<h1 class="distanz">Distanz: ${v.distanz}m</h1>
				<h1 class="idthing">ID: ${v.id}</h1>
			    </div>
            `
		);
	});
	SL.Inventory.SetUpInventory(items, slots, people);
};

SL.Inventory.SetUpInventory = function (items, slots) {
	$(".item-box").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventory",
				revert: "invalid",
				containment: "document",
			});
		}
	});
	$(".use-button")
		.off()
		.droppable({
			drop: function (event, ui) {
				var itemname = ui.draggable.attr("data-name");
				$.post(
					"https://" + GetParentResourceName() + "/useItem",
					JSON.stringify({
						item: itemname,
					})
				);
				console.log("test");
				SL.Inventory.Close();
			},
		});
	$(".droprange")
		.off()
		.droppable({
			drop: function (event, ui) {
				var itemname = ui.draggable.attr("data-name");
				var anzahl = document.getElementById("inputt-mainraum").value;
				$.post(
					"https://" + GetParentResourceName() + "/DropItem",
					JSON.stringify({
						item: itemname,
						anzahl: anzahl,
					})
				);
				SL.Inventory.Close();
			},
		});

	$(".container-player")
		.off()
		.droppable({
			drop: function (event, ui) {
				var itemname = ui.draggable.attr("data-name");
				var button = $(this);
				var id = button.attr("id");
				var anzahl = document.getElementById("inputt-mainraum").value;
				$.post(
					"https://" + GetParentResourceName() + "/GiveItemToPlayer",
					JSON.stringify({
						item: itemname,
						id: id,
						anzahl: anzahl,
					})
				);
				SL.Inventory.Close();
			},
		});
};

$(document).on("keydown", function (event) {
	switch (event.keyCode) {
		case 27:
			SL.Inventory.Close();
			SL.Inventory.CloseWaffenschrank();
			break;
	}
});

SL.Inventory.Close = function () {
	$.post("https://" + GetParentResourceName() + "/CloseInventory");
	document.getElementById("playeritems").innerHTML = "";
	$(".inventory").hide();
	$(".inventoryWaffenschrank").hide();
	$(".inventoryTrunk").hide();
	$(".inventoryGlove").hide();
};

var kofferraumslot;
SL.Inventory.MakeSlotsTrunk = function (
	items,
	slots,
	limit,
	slotkofferraum,
	inventorykofferaum,
	kofferaumweight
) {
	$(".playeritems").html("");
	$(".kofferaum").html("");
	document.getElementById("inputt-kofferraum").value = 1;
	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-trunk .playeritems").append(
			`<div data-slot="${i}" class="item-box"></div>`
		);
	}

	var c = 0;
	kofferraumslot = slotkofferraum;
	for (i = 1; i < slotkofferraum + 1; i++) {
		$(".kofferaum").append(
			`<div data-slot="${i}" class="item-box-kofferaum"></div>`
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
				.attr("data-inventory", "inventory");
		}
	});

	$.each(inventorykofferaum, function (k, v) {
		if (v != null) {
			c++;
			$(".kofferaum")
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
				.attr("data-inventory", "trunk");
		}
	});

	SL.Inventory.SetUpInventoryTrunk(items, slots);
};

SL.Inventory.SetUpInventoryTrunk = function (items, slots) {
	$(".item-box").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryTrunk",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".item-box-kofferaum").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryTrunk",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".kofferaum")
		.off()
		.droppable({
			drop: function (event, ui) {
				var inventory = ui.draggable.attr("data-inventory");
				if (inventory === "inventory") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl =
						document.getElementById("inputt-kofferraum").value;
					var label = ui.draggable.attr("data-label");

					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/givekofferraumitem",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/givekofferraumitem",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
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
				if (inventory === "trunk") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl =
						document.getElementById("inputt-kofferraum").value;
					var label = ui.draggable.attr("data-label");

					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminventory",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminventory",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
							})
						);
					}
				}
			},
		});
};

SL.Inventory.UpdateTrunk = function (items, inventoryitems) {
	$(".kofferaum").html("");
	$(".playeritems").html("");

	var c = 0;
	for (i = 1; i < kofferraumslot + 1; i++) {
		$(".kofferaum").append(
			`<div data-slot="${i}"class="item-box-kofferaum"></div>`
		);
	}

	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-trunk .playeritems").append(
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
				.attr("data-inventory", "inventory");
		}
	});

	$.each(items, function (k, v) {
		if (v != null) {
			c++;
			$(".kofferaum")
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
				.attr("data-inventory", "trunk");
		}
	});

	SL.Inventory.SetUpInventoryTrunk();
};

SL.Inventory.MakeSlotsGloves = function (
	items,
	slots,
	limit,
	slotkofferraum,
	inventorygloves,
	kofferaumweight
) {
	$(".playeritems").html("");
	$(".glovesbox").html("");
	document.getElementById("inputt-glovesraum").value = 1;
	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-gloves .playeritems").append(
			`<div data-slot="${i}" class="item-box"></div>`
		);
	}

	var c = 0;
	glovesslot = slotkofferraum;
	for (i = 1; i < slotkofferraum + 1; i++) {
		$(".glovesbox").append(
			`<div data-slot="${i}" class="item-box-gloves"></div>`
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
				.attr("data-inventory", "inventory");
		}
	});

	$.each(inventorygloves, function (k, v) {
		if (v != null) {
			c++;
			$(".glovesbox")
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
				.attr("data-inventory", "gloves");
		}
	});

	SL.Inventory.SetUpInventoryGloves();
};

SL.Inventory.SetUpInventoryGloves = function () {
	$(".item-box").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryGlove",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".item-box-gloves").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryGlove",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".glovesbox")
		.off()
		.droppable({
			drop: function (event, ui) {
				var inventory = ui.draggable.attr("data-inventory");
				if (inventory === "inventory") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl =
						document.getElementById("inputt-glovesraum").value;
					var label = ui.draggable.attr("data-label");

					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/givekofferraumitemgloves",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/givekofferraumitemgloves",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
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
				if (inventory === "gloves") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl =
						document.getElementById("inputt-glovesraum").value;
					var label = ui.draggable.attr("data-label");

					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminventorygloves",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveiteminventorygloves",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
							})
						);
					}
				}
			},
		});
};

SL.Inventory.UpdateGloves = function (items, inventoryitems) {
	$(".glovesbox").html("");
	$(".playeritems").html("");

	var c = 0;
	for (i = 1; i < glovesslot + 1; i++) {
		$(".glovesbox").append(
			`<div data-slot="${i}"class="item-box-gloves"></div>`
		);
	}

	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-gloves .playeritems").append(
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
				.attr("data-inventory", "inventory");
		}
	});

	$.each(items, function (k, v) {
		if (v != null) {
			c++;
			$(".glovesbox")
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
				.attr("data-inventory", "gloves");
		}
	});

	SL.Inventory.SetUpInventoryGloves();
};

// Waffenschrank
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
								"/giveiteminwaffenschrank",
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
								"/giveiteminwaffenschrank",
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
								"/giveiteminventorywaffenschrank",
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
								"/giveiteminventorywaffenschrank",
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
SL.Inventory.CloseWaffenschrank = function () {
	$.post("https://" + GetParentResourceName() + "/CloseWaffenSchrank");
	document.getElementById("playeritems").innerHTML = "";
	$(".inventory").hide();
	$(".inventoryWaffenschrank").hide();
	$(".inventoryTrunk").hide();
	$(".inventoryGlove").hide();
};

SL.Inventory.MakeSlotsDurchsuchen = function (
	items,
	slots,
	limit,
	targetinventory
) {
	$(".playeritems").html("");
	$(".durchsuchen").html("");
	document.getElementById("inputt-glovesraum").value = 1;
	var d = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 13; i++) {
		$(".inventory-items-gloves .playeritems").append(
			`<div data-slot="${i}" class="item-box"></div>`
		);
	}

	var c = 0;
	for (i = 1; i < SL.Inventory.MaxSlots + 1; i++) {
		$(".durchsuchen").append(
			`<div data-slot="${i}" class="item-box-gloves"></div>`
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
				.attr("data-inventory", "inventory");
		}
	});

	$.each(targetinventory, function (k, v) {
		if (v != null) {
			c++;
			$(".glovesbox")
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
				.attr("data-inventory", "target");
		}
	});

	SL.Inventory.SetUpInventoryDurchsuchen();
};

SL.Inventory.SetUpInventoryDurchsuchen = function () {
	$(".item-box").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryGlove",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".item-box-gloves").each(function () {
		if ($(this).data("name")) {
			$(this).draggable({
				helper: "clone",
				appendTo: ".inventoryGlove",
				revert: "invalid",
				containment: "document",
			});
		}
	});

	$(".glovesbox")
		.off()
		.droppable({
			drop: function (event, ui) {
				var inventory = ui.draggable.attr("data-inventory");
				if (inventory === "inventory") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl =
						document.getElementById("inputt-glovesraum").value;
					var label = ui.draggable.attr("data-label");

					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveitemtoplayerdurchsuchen",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveitemtoplayerdurchsuchen",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
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
				if (inventory === "target") {
					var itemname = ui.draggable.attr("data-name");
					var anzahl =
						document.getElementById("inputt-glovesraum").value;
					var label = ui.draggable.attr("data-label");

					if (anzahl !== undefined) {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveitemtoinventory",
							JSON.stringify({
								item: itemname,
								anzahl: anzahl,
								label: label,
							})
						);
					} else {
						$.post(
							"https://" +
								GetParentResourceName() +
								"/giveitemtoinventory",
							JSON.stringify({
								item: itemname,
								anzahl: 1,
								label: label,
							})
						);
					}
				}
			},
		});
};
