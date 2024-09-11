var switchStatus = false;

$("document").ready(function () {
	$(".container-adminpanel").hide();
	$(".ticketseite").hide();
	$(".rightsidetickes").hide();
	//$(".hauptmenu").hide();
	$(".heraustehendesmenuüberspieler").hide();
	$(".spielerseite").hide();
	$(".frontpage-interaktionen").hide();
	$(".ids").hide();
	$(".Einstellungen").hide();
	$(".notizen").hide();
	$(".bann").hide();
	$(".ButtonWirtschaft").hide();
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").hide();
	$(".pedoptionen").hide();
	$(".ButtonAussehen").hide();
	$(".ButtonItemRecord").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonAuto").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenu") {
			console.log("test");
			$(".container-adminpanel").show();
			document.getElementById("playercount").innerHTML = msg.activeusers;
			document.getElementById("playtime").innerHTML =
				msg.day + "D " + msg.hour + "H";
			document.getElementById("warns").innerHTML = msg.warns;
			document.getElementById("bans").innerHTML = msg.Bans;
			document.getElementById("ticketsactiv").innerHTML =
				msg.ticketsactiv;
			document.getElementById("adminsactiv").innerHTML = msg.admins;
			MakeAdmins(msg.adminse);
		} else if (event.data.type === "OpenTickets") {
			$(".ticketseite").show();
			InsertTickets(msg.result);
		} else if (event.data.type === "DisplayTicketDetail") {
			MakeTickets(msg.tickets, msg.ticketdetails);
		} else if (event.data.type === "UpdateChat") {
			$(".scrollbereich").html(" ");
			$(".scrollbereich").append(
				`
				<h1
										class="anfangstext"
										id="anfangstext"
									>Das ist der Anfang des Tickets</h1>
			 `
			);
			$.each(msg.result, function (index, item) {
				$(".scrollbereich").append(
					`
					<div class="nachrichtcontainer">
						<h1
						class="textinnencontainernachtricht"
						>
							${item.nachricht}
						</h1>
						<h1 class="werhatgesendetamena">
							Absender: ${item.absender}
						</h1>
					</div>
				 `
				);
			});
			scrollToBottom("scrollbereich");
		} else if (event.data.type === "UpdateTicket") {
			$(".rightsidetickes").hide();
			InsertTickets(msg.result);
		} else if (event.data.type === "InsertPlayers") {
			$(".spielerseite").show();
			InsertPlayers(msg.result);
		} else if (event.data.type === "OpenSecondNuiPlayer") {
			$(".heraustehendesmenuüberspieler").show();

			document
				.getElementById("verwahrnen")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("kicken")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("heilen")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("tpzumspieleradmin")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("tpspielerzumiradmin")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("zuschauen")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("betrunkenmachen")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("anzünden")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("crash")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("inputtinformationen")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("bannen")
				.setAttribute("identifier", msg.identifier);
			document
				.getElementById("inputtinformationen")
				.setAttribute("identifier", msg.identifier);
			document.getElementById("steam").innerHTML = msg.steamid;
			document.getElementById("license").innerHTML = msg.license;
			document.getElementById("live").innerHTML = msg.xbl;
			document.getElementById("discord").innerHTML = msg.discord;
			document.getElementById("fivem").innerHTML = msg.liveid;
			document.getElementById("spieleraktionentext4").innerHTML =
				"Warns:" + msg.warns;
			document.getElementById("spieleraktionentext5").innerHTML =
				"Kills: " + msg.kills;
			document.getElementById("spieleraktionentext6").innerHTML =
				"Tode: " + msg.death;
			document.getElementById("spieleraktionentext3").innerHTML =
				"Spielzeit: " + msg.d + "D " + msg.h + "H " + msg.min + "Min ";
			document.getElementById("inputtinformationen").value = msg.notizen;
		} else if (event.data.type === "UpdateMarker") {
			switchStatus = msg.activchat;
			var checkbox1 = document.getElementById("togBtn");
			checkbox1.checked = switchStatus;
		} else if (event.data.type === "InsertAndOpenItems") {
			$(".ButtonAnnounce").hide();
			$(".ButtonsPedOptionen").hide();
			$(".ButtonAussehen").hide();
			$(".ButtonAuto").hide();
			$(".ButtonWaffeOptionen").hide();
			$(".ButtonWirtschaft").hide();

			$(".ButtonItemsOptionen").show();
			$(".ButtonItemRecord").hide();
			InsertItems(msg.result);
		}
	});
});
$("#getticket").click(function () {
	$(".spielerseite").hide();
	$(".pedoptionen").hide();
	$(".hauptmenu").hide();
	$(".spielerseite").hide();
	$(".Einstellungen").hide();
	$.post("https://SevenLife_Admin/GetMainTicket", JSON.stringify({}));
});
function InsertTickets(items) {
	$(".scroll-tickets").html("");
	$.each(items, function (index, item) {
		$(".scroll-tickets").append(
			` 
			<div class="ticketout">
				<h1 class="titel-id">#${item.id}</h1>
				<h1 class="titel-ticket"> ${item.about} </h1>
				<button class="Button-Open-Details" name="${item.id}">></button>
			</div>
             
             `
		);
	});
}
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-adminpanel").hide();
	$(".ticketseite").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
}
$(".ticketseite").on("click", ".Button-Open-Details", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"https://SevenLife_Admin/ShowDetails",
		JSON.stringify({ id: $name })
	);
});
$(document).ready(function () {
	$("#inputtnachricht").keypress(function (e) {
		if (e.which === 13) {
			var inputting = document.getElementById("inputtnachricht").value;
			var id = document
				.getElementById("inputtnachricht")
				.getAttribute("ticketid");
			document.getElementById("inputtnachricht").value = "";
			$.post(
				"https://SevenLife_Admin/MakeNachricht",
				JSON.stringify({ inputting: inputting, id: id })
			);
		}
	});
	$("#inputtinformationen").keypress(function (e) {
		if (e.which === 13) {
			var inputting = document.getElementById(
				"inputtinformationen"
			).value;
			var id = document
				.getElementById("inputtinformationen")
				.getAttribute("identifier");

			$.post(
				"https://SevenLife_Admin/InsertNotiz",
				JSON.stringify({ inputting: inputting, identifier: id })
			);
			console.log(id);
		}
	});
});
function MakeTickets(items, ticketdetails) {
	$(".rightsidetickes").show();
	$(".scrollbereich").html("");
	$.each(items, function (index, item) {
		$(".scrollbereich").append(
			`
			<h1 class="anfangstext" id="anfangstext">Das ist der Anfang des Tickets : ${item.about}</h1>
	 `
		);
		document.getElementById("nameofspieler").innerHTML =
			"Name " + item.name;
		document
			.getElementById("inputtnachricht")
			.setAttribute("ticketid", item.id);
		document
			.getElementById("tpzumspieler")
			.setAttribute("ticketid", item.id);
		document
			.getElementById("tpspielerzumir")
			.setAttribute("ticketid", item.id);
		document
			.getElementById("ticketlöschen")
			.setAttribute("ticketid", item.id);
		document
			.getElementById("tpzumspieler")
			.setAttribute("iddentifier", item.identifier);
		document
			.getElementById("tpspielerzumir")
			.setAttribute("iddentifier", item.identifier);
		document
			.getElementById("ticketlöschen")
			.setAttribute("iddentifier", item.identifier);
	});

	$.each(ticketdetails, function (index, item) {
		$(".scrollbereich").append(
			`
			<div class="nachrichtcontainer">
			    <h1
				class="textinnencontainernachtricht"
				>
					${item.nachricht}
				</h1>
				<h1 class="werhatgesendetamena">
					Absender: ${item.absender}
				</h1>
			</div>
         `
		);
	});
	document.getElementById("inputtnachricht").value = "";
	scrollToBottom("scrollbereich");
}
const scrollToBottom = (id) => {
	const element = document.getElementById(id);
	element.scrollTop = element.scrollHeight;
};
$(".ticketseite").on("click", "#ticketlöschen", function () {
	var $button = $(this);
	var $ticketid = $button.attr("ticketid");
	var $identifier = $button.attr("iddentifier");
	$.post(
		"https://SevenLife_Admin/DeleteTicket",
		JSON.stringify({ id: $ticketid, identifier: $identifier })
	);
});
$(".ticketseite").on("click", "#tpspielerzumir", function () {
	var $button = $(this);
	var $ticketid = $button.attr("ticketid");
	var $identifier = $button.attr("iddentifier");
	$(".container-adminpanel").hide();
	$(".ticketseite").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
	$.post(
		"https://SevenLife_Admin/tpspielerzumir",
		JSON.stringify({ id: $ticketid, identifier: $identifier })
	);
});
$(".ticketseite").on("click", "#tpzumspieler", function () {
	var $button = $(this);
	var $ticketid = $button.attr("ticketid");
	var $identifier = $button.attr("iddentifier");
	$(".container-adminpanel").hide();
	$(".ticketseite").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
	$.post(
		"https://SevenLife_Admin/tpzumspieler",
		JSON.stringify({ id: $ticketid, identifier: $identifier })
	);
});
$(".container-adminpanel").on("click", "#spieleroptionen", function () {
	$(".ticketseite").hide();
	$(".pedoptionen").hide();
	$(".hauptmenu").hide();
	$(".spielerseite").hide();
	$(".Einstellungen").hide();
	$.post("https://SevenLife_Admin/GetPlayerOptions", JSON.stringify({}));
});
function InsertPlayers(items) {
	$(".container-auswahl").html("");
	$.each(items, function (index, item) {
		$(".container-auswahl").append(
			` 
			<div class="container-player" identifier = "${item.identifier}">
						<img
							src="src/foodprint.png"
							class="img-bildfoodprint"
							alt=""
						/>
						<h1 class="nameofplayer">[${item.id}] ${item.name}</h1>
					</div>
             
             `
		);
	});
}
$(".container-adminpanel").on("click", ".container-player", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	$.post(
		"https://SevenLife_Admin/GetDetailInfoAboutPlayer",
		JSON.stringify({ identifier: $identifier })
	);
});

$(".closepage").click(function () {
	$(".heraustehendesmenuüberspieler").hide();
});

$("#Aktionen").click(function () {
	$(".ids").hide();
	$(".frontpage-interaktionen").show();
	$(".notizen").hide();
	$(".bann").hide();
});
$("#Info").click(function () {
	$(".ids").hide();
	$(".frontpage-interaktionen").hide();
	$(".notizen").show();
	$(".bann").hide();
});
$("#idplace").click(function () {
	$(".ids").show();
	$(".frontpage-interaktionen").hide();
	$(".notizen").hide();
	$(".bann").hide();
});
$("#ban").click(function () {
	$(".ids").hide();
	$(".frontpage-interaktionen").hide();
	$(".notizen").hide();
	$(".bann").show();
});

$(".frontpage-interaktionen").on("click", ".verwahrnen", function () {
	var $button = $(this);
	var $identifier = document
		.getElementById("verwahrnen")
		.getAttribute("identifier");

	$.post(
		"https://SevenLife_Admin/Verwahrnspieler",
		JSON.stringify({ identifier: $identifier })
	);
});

$(".kicken").click(function () {
	var $identifier = document
		.getElementById("kicken")
		.getAttribute("identifier");

	$.post(
		"https://SevenLife_Admin/KickPlayer1",
		JSON.stringify({ identifier: $identifier })
	);
});

$(".frontpage-interaktionen").on("click", ".heilen", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");

	$.post(
		"https://SevenLife_Admin/HeilPlayer",
		JSON.stringify({ identifier: $identifier })
	);
	console.log($identifier);
});
$(".frontpage-interaktionen").on("click", ".tpzumspieleradmin", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	$.post(
		"https://SevenLife_Admin/tpzumspieleradmin",
		JSON.stringify({ identifier: $identifier })
	);
	$(".container-adminpanel").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
});
$(".frontpage-interaktionen").on("click", ".tpspielerzumiradmin", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	$.post(
		"https://SevenLife_Admin/tpspielerzumiradmin",
		JSON.stringify({ identifier: $identifier })
	);
	$(".container-adminpanel").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
});
$(".frontpage-interaktionen").on("click", ".zuschauen", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	$.post(
		"https://SevenLife_Admin/zuschauen",
		JSON.stringify({ identifier: $identifier })
	);
	$(".container-adminpanel").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
});
$(".frontpage-interaktionen").on("click", ".betrunkenmachen", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	$.post(
		"https://SevenLife_Admin/betrunkenmachen",
		JSON.stringify({ identifier: $identifier })
	);
});
$(".frontpage-interaktionen").on("click", ".anzünden", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");

	$.post(
		"https://SevenLife_Admin/anzuenden",
		JSON.stringify({ identifier: $identifier })
	);
});
$(".frontpage-interaktionen").on("click", ".crash", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	$.post(
		"https://SevenLife_Admin/crash",
		JSON.stringify({ identifier: $identifier })
	);
	$(".container-adminpanel").hide();
	$.post("https://SevenLife_Admin/CloseMenu", JSON.stringify({}));
});
$(".container-adminpanel").on("click", ".Button-BannPlayer", function () {
	var $button = $(this);

	var $identifier = $button.attr("identifier");
	var grund = document.getElementById("inputtgrund").value;
	var länge = document.getElementById("inputtstunde").value;

	$.post(
		"https://SevenLife_Admin/Bann",
		JSON.stringify({ identifier: $identifier, grund: grund, leange: länge })
	);
});

// Txt
$(".container-adminpanel").on("click", "#Aduty", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/Aduty", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#NoClip", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/NoClip", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Namen", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/Namen", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#GodMode", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/GodMode", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Strokes", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/Strokes", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#PedOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").show();
	$(".ButtonAussehen").hide();
	$(".ButtonWirtschaft").hide();
	$(".ButtonAuto").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonItemRecord").hide();
});
$(".container-adminpanel").on("click", "#AnnounceOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").show();
	$(".ButtonsPedOptionen").hide();
	$(".ButtonAussehen").hide();
	$(".ButtonWirtschaft").hide();
	$(".ButtonAuto").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonItemRecord").hide();
});
$(".container-adminpanel").on("click", "#AussehnOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").hide();
	$(".ButtonAussehen").show();
	$(".ButtonWirtschaft").hide();
	$(".ButtonAuto").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonItemRecord").hide();
});
$(".container-adminpanel").on("click", "#optioenped", function () {
	var $button = $(this);
	$(".ticketseite").hide();
	$(".pedoptionen").show();
	$(".hauptmenu").hide();
	$(".spielerseite").hide();
	$(".Einstellungen").hide();
});
$(".container-adminpanel").on("click", "#homestrich", function () {
	var $button = $(this);
	$(".ticketseite").hide();
	$(".pedoptionen").hide();
	$(".hauptmenu").show();
	$(".spielerseite").hide();
	$(".Einstellungen").hide();
});
$(".container-adminpanel").on("click", "#AutoOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").hide();
	$(".ButtonAussehen").hide();
	$(".ButtonAuto").show();
	$(".ButtonWirtschaft").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonItemRecord").hide();
});
$(".container-adminpanel").on("click", "#WirtschaftsOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").hide();
	$(".ButtonAussehen").hide();
	$(".ButtonAuto").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonWirtschaft").show();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonItemRecord").hide();
});
$(".container-adminpanel").on("click", "#WaffenOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").hide();
	$(".ButtonAussehen").hide();
	$(".ButtonAuto").hide();
	$(".ButtonWaffeOptionen").show();
	$(".ButtonWirtschaft").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonItemRecord").hide();
});
$(".container-adminpanel").on("click", "#ItemsOptionen", function () {
	$.post("https://SevenLife_Admin/GetItems", JSON.stringify({}));
});

$(".container-adminpanel").on("click", "#Announce", function () {
	var $button = $(this);
	var announce = document.getElementById("inputtannounce").value;
	var announcedetail = document.getElementById("inputtannouncedetail").value;
	var id = document.getElementById("inputtid").value;
	$.post(
		"https://SevenLife_Admin/Announce",
		JSON.stringify({
			announce: announce,
			announcedetail: announcedetail,
			id: id,
		})
	);
});
$(".container-adminpanel").on("click", "#AbsendenPed", function () {
	var $button = $(this);
	var name = document.getElementById("inputtpedname").value;
	var id = document.getElementById("inputtid2").value;

	$.post(
		"https://SevenLife_Admin/ChangePed",
		JSON.stringify({
			name: name,
			id: id,
		})
	);
});
$(".container-adminpanel").on("click", "#Mann", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/Mann", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Frau", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/Frau", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Reset", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/Reset", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Auto", function () {
	var $button = $(this);
	var name = document.getElementById("inputtautoname").value;

	$.post("https://SevenLife_Admin/SpawnCar", JSON.stringify({ name: name }));
});
$(".container-adminpanel").on("click", "#NextCar", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/NextCar", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#10MinRadius", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/10MinRadius", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#DespawnAllCars", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/DespawnAllCars", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#SendenGeld", function () {
	var $button = $(this);
	var money = document.getElementById("inputtmoneyammount").value;
	var id = document.getElementById("inputtid3").value;

	$.post(
		"https://SevenLife_Admin/SendenGeld",
		JSON.stringify({
			money: money,
			id: id,
		})
	);
});
$(".container-adminpanel").on("click", "#GeldSetzen", function () {
	var $button = $(this);
	var money = document.getElementById("inputtmoneyammount2").value;
	var id = document.getElementById("inputtid4").value;

	$.post(
		"https://SevenLife_Admin/GeldSetzen",
		JSON.stringify({
			money: money,
			id: id,
		})
	);
});
$(".container-adminpanel").on("click", "#Geldnehmen", function () {
	var $button = $(this);
	var money = document.getElementById("inputtmoneyammount3").value;
	var id = document.getElementById("inputtid5").value;

	$.post(
		"https://SevenLife_Admin/Geldnehmen",
		JSON.stringify({
			money: money,
			id: id,
		})
	);
});
$(".container-adminpanel").on("click", "#WeaponGeben", function () {
	var $button = $(this);
	var name = document.getElementById("inputtweaponammount").value;
	var id = document.getElementById("inputtid7").value;
	console.log(id);
	console.log(name);
	$.post(
		"https://SevenLife_Admin/WeaponGeben",
		JSON.stringify({
			name: name,
			id: id,
		})
	);
});
$(".container-adminpanel").on("click", "#ResetWaffen", function () {
	var $button = $(this);
	var id = document.getElementById("inputtid6").value;

	$.post(
		"https://SevenLife_Admin/ResetWaffen",
		JSON.stringify({
			id: id,
		})
	);
});
function MakeAdmins(items) {
	$(".scroll-tickets4").html("");
	$.each(items, function (index, item) {
		$(".scroll-tickets4").append(
			` 
			<div class="ticketout">
			     <h1 class="titel-ticket4">[Team] ${item}</h1>
		    </div>
             
             `
		);
	});
}

$("#togBtn").on("change", function () {
	if ($(this).is(":checked")) {
		switchStatus = $(this).is(":checked");
		$.post(
			"https://SevenLife_Admin/UpdateEinstellung",
			JSON.stringify({
				einstellung: 1,
				marked: switchStatus,
			})
		);
	} else {
		switchStatus = $(this).is(":checked");
		$.post(
			"https://SevenLife_Admin/UpdateEinstellung",
			JSON.stringify({
				einstellung: 1,
				marked: switchStatus,
			})
		);
	}
});
$(".container-adminpanel").on("click", "#einstellungenoptionen", function () {
	var $button = $(this);
	$(".ticketseite").hide();
	$(".pedoptionen").hide();
	$(".hauptmenu").hide();
	$(".spielerseite").hide();
	$(".Einstellungen").show();
	$.post("https://SevenLife_Admin/GetCheckMarked", JSON.stringify({}));
});

function searchanimasauslager() {
	$(".Button-Giveitem").hide();
	let input = document.getElementById("inputts-searchplayer").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("Button-Giveitem");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".nameofitem")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
function InsertItems(result) {
	$(".container-itemlist").html("");
	$.each(result, function (index, item) {
		$(".container-itemlist").append(
			` 
			<button
			class="Button-Giveitem"
			name = "${item.name}"
			label = "${item.label}"
			id="Button-Giveitem"
			name=""
		><h1 class = "nameofitem">${item.label}</h1>
		</button
		>
		 
		 `
		);
	});
}

$(".ButtonItemsOptionen").on("click", "#Button-Giveitem", function () {
	var $button = $(this);
	var name = $button.attr("name");
	var label = $button.attr("label");
	console.log("hey");
	$.post(
		"https://SevenLife_Admin/GiveItemToPlayer",
		JSON.stringify({ name: name, label: label })
	);
});
$(".container-adminpanel").on("click", "#repair", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/repair", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#sauber", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/sauber", JSON.stringify({}));
});

$(".container-adminpanel").on("click", "#Button-aufnamestarten", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/aufnamestarten", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Button-aufnamestoppen", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/aufnamestoppen", JSON.stringify({}));
});

$(".container-adminpanel").on("click", "#recordoptionrockstar", function () {
	var $button = $(this);
	CloseAll();
	$.post("https://SevenLife_Admin/recordoptionrockstar", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#Button-aufnameabbrechen", function () {
	var $button = $(this);

	$.post("https://SevenLife_Admin/aufnameabbrechen", JSON.stringify({}));
});
$(".container-adminpanel").on("click", "#RecordingOptionen", function () {
	var $button = $(this);
	$(".ButtonAnnounce").hide();
	$(".ButtonsPedOptionen").hide();
	$(".ButtonAussehen").hide();
	$(".ButtonAuto").hide();
	$(".ButtonWaffeOptionen").hide();
	$(".ButtonWirtschaft").hide();
	$(".ButtonItemsOptionen").hide();
	$(".ButtonItemRecord").show();
});
