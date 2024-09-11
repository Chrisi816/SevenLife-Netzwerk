var d = 0;
$("document").ready(function () {
	$(".container").hide();
	$(".hauptseite").hide();
	$(".seasonpassreiter").hide();

	$(".ranking-container").hide();
	$(".banlist").hide();
	$(".fragezwei").hide();
	$(".tickets").hide();
	$(".faq-bereich").hide();
	$(".fragedrei").hide();
	$(".fragevier").hide();
	$(".fragesechs").hide();
	$(".fragefünf").hide();
	$(".statistiks").hide();
	$(".bug-melden").hide();
	$(".onlineplayerranking").hide();
	$(".bestehendetickets").hide();
	$(".linkticket").hide();

	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMainNUI") {
			$(".seasonpassreiter").hide();
			$(".container").fadeIn(1000);
			$(".ranking-container").hide();
			$(".bug-melden").hide();
			$(".statistiks").hide();
			$(".tickets").hide();
			$(".faq-bereich").hide();
			$(".hauptseite").show();
			renderProgress(msg.visaprozent);
			renderProgresss(msg.visaprozent);
			InsertFirstSite(
				msg.visastufe,
				msg.vip,
				msg.status,
				msg.warns,
				msg.name,
				msg.job,
				msg.orga,
				msg.jobgrade,
				msg.wohnort
			);
			document.getElementById("spieler").style.backgroundColor =
				"rgba(0, 0, 0, 0.575)";

			document.getElementById("seasonpass").style.backgroundColor =
				"rgba(0, 0, 0, 0.575)";
			document.getElementById("faq").style.backgroundColor =
				"rgba(0, 0, 0, 0.575)";
			document.getElementById("stats").style.backgroundColor =
				"rgba(0, 0, 0, 0.575)";
			document.getElementById("ticket").style.backgroundColor =
				"rgba(0, 0, 0, 0.575)";
			document.getElementById("profil").style.backgroundColor =
				"rgba(120, 120, 120, 0.757)";

			// SkillBaum
			document.getElementById("skillbaumlevel2").innerHTML =
				msg.level + "Level";
			document.getElementById("skillbaumlevelxp2").innerHTML =
				msg.xp + "XP";
			document.getElementById("skillbaumlevelpoints2").innerHTML =
				msg.points + "P.";

			document.getElementById("spielerid").innerHTML = msg.id;

			document.getElementById("infobelohnung").innerHTML =
				"Du musst noch " +
				msg.number +
				" Min aktiv spielen um deine Belohnung zu bekommen;";

			document.getElementById("spieleractive").innerHTML =
				msg.onlineplayer + " / 10";

			document.getElementById("connected").innerHTML = msg.zeit;
		} else if (event.data.type === "OpenMenuPlayer") {
			MakePlayerList(msg.players);

			var toSort = document.getElementById("ranking").children;
			toSort = Array.prototype.slice.call(toSort, 0);
			toSort.sort(function (a, b) {
				var aord = +a.id.split("-")[1];
				var bord = +b.id.split("-")[1];
				return aord - bord;
			});
			var parent = document.getElementById("ranking");
			parent.innerHTML = "";

			for (var i = 0, l = toSort.length; i < l; i++) {
				parent.prepend(toSort[i]);
			}
		} else if (event.data.type === "OpenStats") {
			$(".statistiks").show();
			InsertStats(
				msg.name,
				msg.kills,
				msg.toder,
				msg.kd,
				msg.datumerstellen,
				msg.Days,
				msg.h,
				msg.min
			);
		} else if (event.data.type === "DisplayTickets") {
			DisplayTickets(msg.ticket);
		} else if (event.data.type === "DisplayTicketDetail") {
			MakeTickets(msg.tickets, msg.ticketdetails);
		} else if (event.data.type === "UpdateJobs") {
			document.getElementById("werkstattpl").innerHTML =
				msg.jobs.mechanic;
			document.getElementById("policepl").innerHTML = msg.jobs.police;
			document.getElementById("medicpl").innerHTML = msg.jobs.ems;
			document.getElementById("playlist").innerHTML =
				msg.jobs.player_count;
		} else if (event.data.type === "UpdatePlayerList") {
			InserOnlinePlayerData(msg.players);
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
			DisplayTickets(msg.type);
			$(".linkticket").hide();
		} else if (event.data.type === "OpenBattlePass") {
			document.getElementById("coinsid").innerHTML = msg.coins + " / 200";
			document.getElementById("progressbarinen").style.width =
				parseInt(msg.coins) * 2.8 + "px";
			document.getElementById("passed").innerHTML = msg.days + " Tagen";
			$(".normalpass").html("");
			$(".permiumpass").html("");
			InsertBattlePassNormal(msg.normal);
			InsertBattlePassPremium(msg.premium);
			document.getElementById("infolevel2").innerHTML =
				"Level " + msg.level;
		} else if (event.data.type === "UpdateCoins") {
			document.getElementById("coinsid").innerHTML = msg.coins + " / 200";
			document.getElementById("progressbarinen").style.width =
				parseInt(msg.coins) * 2.8 + "px";
			document.getElementById("infolevel2").innerHTML =
				"Level " + msg.level;
		}
	});
});
const scrollToBottom = (id) => {
	const element = document.getElementById(id);
	element.scrollTop = element.scrollHeight;
};
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function InsertStats(name, kills, deaths, kds, einreisedatum, d, h, min) {
	document.getElementById("name-stats").innerHTML = name;
	document.getElementById("kills").innerHTML = kills;
	document.getElementById("deaths").innerHTML = deaths;
	document.getElementById("kds").innerHTML = kds;
	document.getElementById("einreisedatum").innerHTML = einreisedatum;
	document.getElementById("spielzeit").innerHTML =
		d + " D " + h + " h " + min + " m";
}

function InsertFirstSite(
	visastufe,
	vip,
	status,
	warns,
	name,
	job,
	orga,
	jobgrade,
	haus
) {
	job = job[0].toUpperCase() + job.slice(1);
	jobgrade = jobgrade[0].toUpperCase() + jobgrade.slice(1);
	haus = haus[0].toUpperCase() + haus.slice(1);

	document.getElementById("name").innerHTML = name;
	document.getElementById("status").innerHTML = "Status: " + status;
	if (vip == "false") {
		document.getElementById("vip").innerHTML = "Kein VIP";
	} else {
		document.getElementById("vip").innerHTML = "VIP";
	}
	document.getElementById("warns").innerHTML = "(" + warns + ") warns";

	document.getElementById("stufe").innerHTML = visastufe;

	document.getElementById("stufes").innerHTML = visastufe;

	document.getElementById("jobstatus").innerHTML =
		"- " + job + " - " + jobgrade;

	document.getElementById("wohnungssituation").innerHTML = haus;

	if (orga == undefined) {
		document.getElementById("orgastatus").innerHTML =
			"- Keiner Organisation";
	} else {
		document.getElementById("orgastatus").innerHTML = "- " + orga;
	}
}
function CloseAll() {
	$(".container").hide();
	$.post("http://SevenLife_MainMenu/CloseMenu", JSON.stringify({}));
}

$(".spieler").click(function () {
	$(".seasonpassreiter").hide();
	$(".hauptseite").hide();
	$(".ranking-container").show();
	$(".tickets").hide();
	$(".faq-bereich").hide();
	$(".statistiks").hide();
	$.post("http://SevenLife_MainMenu/GetDataSpieler", JSON.stringify({}));
	document.getElementById("profil").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("seasonpass").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("faq").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("stats").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("ticket").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("spieler").style.backgroundColor =
		"rgba(120, 120, 120, 0.557)";
});

$(".profil").click(function () {
	$(".seasonpassreiter").hide();
	$(".hauptseite").show();
	$(".ranking-container").hide();
	$(".faq-bereich").hide();
	$(".tickets").hide();
	$(".statistiks").hide();
	d = 0;
	document.getElementById("spieler").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("seasonpass").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("faq").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("stats").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("ticket").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("profil").style.backgroundColor =
		"rgba(120, 120, 120, 0.557)";
});

$(".faq").click(function () {
	d = 0;
	$(".seasonpassreiter").hide();
	$(".faq-bereich").show();
	$(".hauptseite").hide();
	$(".ranking-container").hide();
	$(".tickets").hide();
	$(".statistiks").hide();
	document.getElementById("spieler").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("seasonpass").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("profil").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("stats").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("ticket").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("faq").style.backgroundColor =
		"rgba(120, 120, 120, 0.557)";
});

$(".stats").click(function () {
	d = 0;
	$(".seasonpassreiter").hide();
	$(".faq-bereich").hide();
	$(".hauptseite").hide();
	$(".ranking-container").hide();
	$(".tickets").hide();
	$(".bestehendetickets").hide();
	$.post("http://SevenLife_MainMenu/GetStats", JSON.stringify({}));
	document.getElementById("spieler").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("seasonpass").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("faq").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("profil").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("ticket").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("stats").style.backgroundColor =
		"rgba(120, 120, 120, 0.557)";
});

$(".ticket").click(function () {
	d = 0;
	$(".seasonpassreiter").hide();
	$(".hauptseite").hide();
	$(".ranking-container").hide();
	$(".tickets").show();
	$(".faq-bereich").hide();
	$(".bug-melden").hide();
	$(".hauptseite-ticket").show();
	$(".frage-melden").hide();
	$(".Spieler-melden").hide();
	$(".statistiks").hide();
	$(".linkticket").hide();
	$(".bestehendetickets").hide();
	document.getElementById("spieler").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("seasonpass").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("faq").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("stats").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("profil").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("ticket").style.backgroundColor =
		"rgba(120, 120, 120, 0.557)";
});

function renderProgress(progress) {
	progress = Math.floor(progress);
	if (progress < 25) {
		var angle = -90 + (progress / 100) * 360;
		$(".animate-0-25-b").css("transform", "rotate(" + angle + "deg)");
	} else if (progress >= 25 && progress < 50) {
		var angle = -90 + ((progress - 25) / 100) * 360;
		$(".animate-0-25-b").css("transform", "rotate(0deg)");
		$(".animate-25-50-b").css("transform", "rotate(" + angle + "deg)");
	} else if (progress >= 50 && progress < 75) {
		var angle = -90 + ((progress - 50) / 100) * 360;
		$(".animate-25-50-b, .animate-0-25-b").css("transform", "rotate(0deg)");
		$(".animate-50-75-b").css("transform", "rotate(" + angle + "deg)");
	} else if (progress >= 75 && progress <= 100) {
		var angle = -90 + ((progress - 75) / 100) * 360;
		$(".animate-50-75-b, .animate-25-50-b, .animate-0-25-b").css(
			"transform",
			"rotate(0deg)"
		);
		$(".animate-75-100-b").css("transform", "rotate(" + angle + "deg)");
	}
	$(".text").html(progress + "%");
}
function renderProgresss(progress) {
	progress = Math.floor(progress);
	if (progress < 25) {
		var angle = -90 + (progress / 100) * 360;
		$(".animate-0-25-bs").css("transform", "rotate(" + angle + "deg)");
	} else if (progress >= 25 && progress < 50) {
		var angle = -90 + ((progress - 25) / 100) * 360;
		$(".animate-0-25-bs").css("transform", "rotate(0deg)");
		$(".animate-25-50-bs").css("transform", "rotate(" + angle + "deg)");
	} else if (progress >= 50 && progress < 75) {
		var angle = -90 + ((progress - 50) / 100) * 360;
		$(".animate-25-50-bs, .animate-0-25-bs").css(
			"transform",
			"rotate(0deg)"
		);
		$(".animate-50-75-bs").css("transform", "rotate(" + angle + "deg)");
	} else if (progress >= 75 && progress <= 100) {
		var angle = -90 + ((progress - 75) / 100) * 360;
		$(".animate-50-75-bs, .animate-25-50-bs, .animate-0-25-bs").css(
			"transform",
			"rotate(0deg)"
		);
		$(".animate-75-100-bs").css("transform", "rotate(" + angle + "deg)");
	}
	$(".texts").html(progress + "%");
}

function MakePlayerList(items) {
	$(".container-spieler-infos").html("");
	$.each(items, function (index, item) {
		d++;
		$(".container-spieler-infos").append(
			`
             <div class="container-spieler-item" id="-${item.visastufe}" >
             <div class="container-ranking">
             <h1 class="number-rankings" id="Numberse">
                  ${item.id}
             </h1>
         </div>
                           <div class="container-middle">
                              <h1 class="name-container-ranking"> 
                                 ${item.name}
                              </h1>
                              <h1 class="status-container-ranking"> 
                              ${item.statuse}
                             </h1>
                           </div>
                           <div class="container-rechts">
                               <h1 class="visa-container-ranking"> 
                               ${item.visastufe}
                               </h1>
                           </div>
                       </div>
             `
		);
	});
}
$(".visa-rank").click(function () {
	$(".spielerliste").show();
	$(".banlist").hide();
	$(".onlineplayerranking").hide();
	$.post("http://SevenLife_MainMenu/GetDataSpieler", JSON.stringify({}));
});
$(".ban").click(function () {
	$(".banlist").show();
	$(".spielerliste").hide();
	$(".onlineplayerranking").hide();
});

$(".onlineplayer").click(function () {
	$(".banlist").hide();
	$(".spielerliste").hide();
	$(".onlineplayerranking").show();
	$.post(
		"http://SevenLife_MainMenu/GetDataOnlinePlayers",
		JSON.stringify({})
	);
});

$(".familie").click(function () {
	$(".frageeins").show();
	$(".fragezwei").hide();
	$(".fragedrei").hide();
	$(".fragevier").hide();
	$(".fragefünf").hide();
	$(".fragesechs").hide();
});
$(".visas").click(function () {
	$(".fragezwei").show();
	$(".frageeins").hide();
	$(".fragedrei").hide();
	$(".fragevier").hide();
	$(".fragefünf").hide();
	$(".fragesechs").hide();
});
$(".import").click(function () {
	$(".fragezwei").hide();
	$(".frageeins").hide();
	$(".fragedrei").show();
	$(".fragevier").hide();
	$(".fragesechs").hide();
	$(".fragefünf").hide();
});
$(".gang").click(function () {
	$(".fragezwei").hide();
	$(".frageeins").hide();
	$(".fragedrei").hide();
	$(".fragevier").show();
	$(".fragefünf").hide();
	$(".fragesechs").hide();
});
$(".vipse").click(function () {
	$(".fragezwei").hide();
	$(".frageeins").hide();
	$(".fragedrei").hide();
	$(".fragevier").hide();
	$(".fragefünf").show();
	$(".fragesechs").hide();
});
$(".tankstelle").click(function () {
	$(".fragezwei").hide();
	$(".frageeins").hide();
	$(".fragedrei").hide();
	$(".fragevier").hide();
	$(".fragefünf").hide();
	$(".fragesechs").show();
});
$(".bugmelden").click(function () {
	$(".bug-melden").show();
	$(".hauptseite-ticket").hide();
});
$(".frage").click(function () {
	$(".frage-melden").show();
	$(".hauptseite-ticket").hide();
});
$(".spielers").click(function () {
	$(".Spieler-melden").show();
	$(".hauptseite-ticket").hide();
});

$(".bug-button").click(function () {
	$(".bug-melden").hide();
	$(".hauptseite-ticket").show();
	var $titel = document.getElementById("inputts").value;
	var $nachricht = document.getElementById("inputtwasdsese").value;
	$.post(
		"http://SevenLife_MainMenu/MakeBugTicket",
		JSON.stringify({ titel: $titel, nachricht: $nachricht })
	);
	document.getElementById("inputts").value = " ";
	document.getElementById("inputtwasdsese").value = " ";
});

$(".frage-button").click(function () {
	$(".frage-melden").hide();
	$(".hauptseite-ticket").show();
	var $titel = document.getElementById("inputtss").value;
	var $nachricht = document.getElementById("inputtwasdseses").value;
	$.post(
		"http://SevenLife_MainMenu/MakeFrageTicket",
		JSON.stringify({ titel: $titel, nachricht: $nachricht })
	);
	document.getElementById("inputtss").value = " ";
	document.getElementById("inputtwasdseses").value = " ";
});

$(".melden-button").click(function () {
	$(".Spieler-melden").hide();
	$(".hauptseite-ticket").show();
	var $titel = document.getElementById("inputtsss").value;
	var $nachricht = document.getElementById("inputtwasdsesess").value;
	$.post(
		"http://SevenLife_MainMenu/MakeMeldeTicket",
		JSON.stringify({ titel: $titel, nachricht: $nachricht })
	);
	document.getElementById("inputtsss").value = " ";
	document.getElementById("inputtwasdsesess").value = " ";
});

$("#TicketShow").click(function () {
	$(".hauptseite-ticket").hide();
	$(".bug-melden").hide();

	$(".frage-melden").hide();
	$(".Spieler-melden").hide();
	$(".bestehendetickets").show();
	$.post("http://SevenLife_MainMenu/MakeTicketsAppear", JSON.stringify({}));
});
$(".button1").click(function () {
	$(".hauptseite-ticket").show();
	$(".bestehendetickets").hide();
});

function DisplayTickets(items) {
	$(".container-aktiveticket").html("");
	$.each(items, function (index, item) {
		d++;
		$(".container-aktiveticket").append(
			`
             <div class="ticket-aktive-display">
                      <h1 class="ticketid">${item.id}</h1>
                      <h1 class="tickettitel">
                      ${item.about} 
                      </h1>
                      <h1 class="bereichticket">
                      ${item.type}
                      </h1>
                      <button class="button2" name="${item.id}">+</button>
                      <button class="button3" name="${item.id}">/</button>
                   </div>
             `
		);
	});
}

function InserOnlinePlayerData(items) {
	$(".container-online-infos").html("");
	$.each(items, function (index, item) {
		$(".container-online-infos").append(
			`
         <div class="container-spieler-item" >
                        <div class="container-ranking">
                            <h1 class="number-rankings" id="Numberse">
                                ${item.id}
                            </h1>
                        </div>
                        <div class="container-middle">
                            <h1 class="name-container-rankingse"> 
                            ${item.name}
                            </h1>
                        </div>
                        <div class="container-rechts">
                            <h1 class="ping-container-ranking"> 
                            ${item.ping}
                            </h1>
                        </div>
                    </div>
         `
		);
	});
}

$(".tickets").on("click", ".button3", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	$(".bestehendetickets").hide();
	$(".hauptseite-ticket").show();

	$.post(
		"http://SevenLife_MainMenu/DeleteTicket",
		JSON.stringify({ id: $name })
	);
});

$(".tickets").on("click", ".button2", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"http://SevenLife_MainMenu/ShowDetails",
		JSON.stringify({ id: $name })
	);
});
function MakeTickets(items, ticketdetails) {
	$(".linkticket").show();
	$(".scrollbereich").html("");
	$.each(items, function (index, item) {
		$(".scrollbereich").append(
			`
			<h1 class="anfangstext" id="anfangstext">Das ist der Anfang des Tickets : ${item.about}</h1>
	 `
		);
		document
			.getElementById("inputtnachricht")
			.setAttribute("ticketid", item.id);
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
$("#inputt-sendcommand").keyup(function (e) {
	if (e.which == 13) {
		CloseAll();
		var $value = document.getElementById("inputt-sendcommand").value;
		$.post(
			"http://SevenLife_MainMenu/MakeCode",
			JSON.stringify({ value: $value })
		);
	}
});
$("#inputt-sendcommand2").keyup(function (e) {
	if (e.which == 13) {
		CloseAll();
		var $value = document.getElementById("inputt-sendcommand2").value;
		$.post(
			"http://SevenLife_MainMenu/MakeCreatorCode",
			JSON.stringify({ value: $value })
		);
	}
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
				"http://SevenLife_MainMenu/MakeNachricht",
				JSON.stringify({ inputting: inputting, id: id })
			);
		}
	});
});
$("#seasonpass").click(function () {
	$(".seasonpassreiter").show();
	$(".hauptseite").hide();
	$(".ranking-container").hide();
	$(".tickets").hide();
	$(".faq-bereich").hide();
	$(".statistiks").hide();
	$.post("http://SevenLife_MainMenu/GetDataSeasonPass", JSON.stringify({}));
	document.getElementById("profil").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";

	document.getElementById("faq").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("stats").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("ticket").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
	document.getElementById("seasonpass").style.backgroundColor =
		"rgba(120, 120, 120, 0.557)";
	document.getElementById("spieler").style.backgroundColor =
		"rgba(0, 0, 0, 0.575)";
});
$(".button-abhoilen").click(function () {
	$.post("http://SevenLife_MainMenu/GiveCoins", JSON.stringify({}));
});

function InsertBattlePassNormal(items) {
	$.each(items, function (index, item) {
		$(".normalpass").append(
			`
			<div class="container-normalerpass" index = "${index + 1}" types  = "${
				item.type
			}" label = "${item.label}" amount = "${item.amount}">
			<div class="container-rare">
				<h1 class="textrare">${item.key}</h1>
			</div>
			<div class="container-bild">
				<img
					src="${item.src}"
					class="gewinnbild"
					alt=""
				/>
			</div>
			<h1 class="infolevel">Level ${index + 1}</h1>
			<h1 class="gewinndetail">${item.Texte}</h1>
		</div>
             `
		);
	});
}
function InsertBattlePassPremium(items) {
	$.each(items, function (index, item) {
		$(".permiumpass").append(
			`
			<div class="container-premiumpass" index = "${index + 1}" types  = "${
				item.type
			}" label = "${item.label}" amount = "${item.amount}">
			<div class="container-rare">
				<h1 class="textrare">${item.key}</h1>
			</div>
			<div class="container-bild">
				<img
					src="${item.src}"
					class="gewinnbild"
					alt=""
				/>
			</div>
			<h1 class="infolevel">Level ${index + 1}</h1>
			<h1 class="gewinndetail">${item.Texte}</h1>
		</div>
             `
		);
	});
}
$(".normalpass").on("click", ".container-normalerpass", function () {
	var button = $(this);
	var index = button.attr("index");
	var types = button.attr("types");
	var label = button.attr("label");
	var amount = button.attr("amount");
	var normal = true;
	$.post(
		"http://SevenLife_MainMenu/ValideOption",
		JSON.stringify({
			index: index,
			types: types,
			label: label,
			amount: amount,
			normal: normal,
		})
	);
});
$(".permiumpass").on("click", ".container-premiumpass", function () {
	var button = $(this);
	var index = button.attr("index");
	var types = button.attr("types");
	var label = button.attr("label");
	var amount = button.attr("amount");
	var normal = false;
	$.post(
		"http://SevenLife_MainMenu/ValideOption",
		JSON.stringify({
			index: index,
			types: types,
			label: label,
			amount: amount,
			normal: normal,
		})
	);
});
