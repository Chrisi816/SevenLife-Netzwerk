$("document").ready(function () {
	$(".container-menu-laufen").hide();
	$(".container-menu-animation").hide();
	$(".container-menu-auto").hide();
	$(".container-menu-perso").hide();
	$(".container-menu-autooptionen").hide();
	$(".persos").hide();
	$(".lizenzbuch").hide();
	$(".container-menu-pets").hide();
	$(".changeingmenu").hide();
	$(".ambulance").hide();
	$(".policemenu").hide();
	$(".container-menu-ambulance").hide();
	$(".container-menu-police").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenu") {
			$(".container-menu-laufen").show();
			if (msg.activepolicemenu === "police") {
				$(".policemenu").show();
			} else if (msg.activepolicemenu === "ambulance") {
				$(".ambulance").show();
			}
		} else if (event.data.type === "OpenMenuAuto") {
			$(".container-menu-auto").show();
		} else if (event.data.type === "removelagerhallekaufen") {
			$(".kaufen").fadeOut(300);
		} else if (msg.type === "OpenLager") {
			$(".lager").fadeIn(500);
			MakeEinlagern(msg.inventory);
			MakeAuslagern(msg.lagers);
			SETALLIN(
				msg.id,
				msg.btc,
				msg.eth,
				msg.lagerused,
				msg.platzupgrade,
				msg.mining
			);
		} else if (msg.type === "OpenPerso") {
			$(".persos").fadeIn(100);
			document.getElementById("name1").innerHTML = msg.name;
			document.getElementById("geburt").innerHTML = msg.birth;
			document.getElementById("einreise").innerHTML = msg.erstellen;
			document.getElementById("name2").innerHTML = msg.name;
		} else if (msg.type === "removeperso") {
			$(".persos").hide();
		} else if (msg.type === "removelizenzen") {
			$(".lizenzbuch").hide();
		} else if (msg.type === "OpenLizenzen") {
			$(".lizenzbuch").fadeIn(100);
			document.getElementById("name3").innerHTML = msg.name;

			// Perso Info
			if (msg.results.driverlicense === "true") {
				document.getElementById("pkw").innerHTML = "Vorhanden";
			} else {
				document.getElementById("pkw").innerHTML = "Fehlend";
			}
			if (msg.results.bootlicense === "true") {
				document.getElementById("lkw").innerHTML = "Vorhanden";
			} else {
				document.getElementById("lkw").innerHTML = "Fehlend";
			}
			if (msg.results.lkwlicense === "true") {
				document.getElementById("motorrad").innerHTML = "Vorhanden";
			} else {
				document.getElementById("motorrad").innerHTML = "Fehlend";
			}
			if (msg.results.motorlicense === "true") {
				document.getElementById("boot").innerHTML = "Vorhanden";
			} else {
				document.getElementById("boot").innerHTML = "Fehlend";
			}
			if (msg.results.gunlicense === "true") {
				document.getElementById("waffe").innerHTML = "Vorhanden";
			} else {
				document.getElementById("waffe").innerHTML = "Fehlend";
			}
		} else if (msg.type === "removepetlicense") {
			$(".container-menu-pets").hide();
		} else if (msg.type === "getpedmenu") {
			$(".changeingmenu").show();
			OpenPetItem(msg.results);
		} else if (event.data.type === "OpenAnim") {
			$(".container-menu-animation").fadeIn();
			var resulting = msg.result;
			var item1 = 1;
			var item2 = 1;
			var item3 = 1;
			resulting.forEach((pannel) => {
				if (item1 === 1) {
					$(".container-menu-animation")
						.append(` <div class="outline-fourth playanim" type = "${pannel.types}" anim = "${pannel.titel}" dancedict = "${pannel.dict}" danceanim = "${pannel.anim}" prop = "${pannel.prop}" propBone = "${pannel.propBone}" propPlacement = "${pannel.propPlacement}" propTwo = "${pannel.propTwo}" propTwoBone = "${pannel.propTwoBone}" propTwoPlacement = "${pannel.propTwoPlacement}">
					<img
						src="src/outline_motion_photos_paused_white_24dp.png"
						class="picture2"
						alt=""
					/>
					<h1 class="innentext322">${pannel.titel}</h1>
				</div>`);
					item1 = pannel.titel;
				} else if (item2 === 1) {
					$(".container-menu-animation")
						.append(`<div class="outline-fifth playanim" type = "${pannel.types}" anim = "${pannel.titel}" dancedict = "${pannel.dict}" danceanim = "${pannel.anim}" prop = "${pannel.prop}" propBone = "${pannel.propBone}" propPlacement = "${pannel.propPlacement}" propTwo = "${pannel.propTwo}" propTwoBone = "${pannel.propTwoBone}" propTwoPlacement = "${pannel.propTwoPlacement}" >
						<img
							src="src/outline_motion_photos_paused_white_24dp.png"
							class="picture2"
							alt=""
						/>
						<h1 class="innentext322">${pannel.titel}</h1>
					</div>
					`);
					item2 = pannel.titel;
				} else if (item3 === 1) {
					$(".container-menu-animation").append(` 
					<div class="outline-six playanim" type = "${pannel.types}" anim = "${pannel.titel}" dancedict = "${pannel.dict}" danceanim = "${pannel.anim}" prop = "${pannel.prop}" propBone = "${pannel.propBone}" propPlacement = "${pannel.propPlacement}" propTwo = "${pannel.propTwo}" propTwoBone = "${pannel.propTwoBone}" propTwoPlacement = "${pannel.propTwoPlacement}">
						<img
							src="src/outline_motion_photos_paused_white_24dp.png"
							class="picture2"
							alt=""
						/>
						<h1 class="innentext322">${pannel.titel}</h1>
					</div>`);
					item3 = pannel.titel;
				}
			});
		}
	});
});

$(".perso").click(function () {
	$(".container-menu-laufen").hide();
	$(".container-menu-perso").show();
});
$(".lizenzzeigen").click(function () {
	$(".container-menu-laufen").fadeOut(500);
	$(".container-menu-perso").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/lizenzzeigen", JSON.stringify({}));
});
$(".lizenzsehen").click(function () {
	$(".container-menu-laufen").fadeOut(500);
	$(".container-menu-perso").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/lizenzsehen", JSON.stringify({}));
});
$(".motoroptionen").click(function () {
	$(".container-menu-auto").hide();
	$(".container-menu-autooptionen").fadeIn(500);
});
$(".keys").click(function () {
	$(".container-menu-laufen").fadeOut(500);
	$(".container-menu-auto").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/Car", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});
$(".motor").click(function () {
	$(".container-menu-auto").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/CarMotor", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});
$(".moreanimation").click(function () {
	$(".container-menu-laufen").hide();
	$.post("https://SevenLife_RadialMenu/GetAnim", JSON.stringify({}));
});

$(".petmenuopen").click(function () {
	$(".container-menu-laufen").hide();
	$(".container-menu-pets").fadeIn();
});

$(".spawnhaustier").click(function () {
	$(".container-menu-pets").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/GetHaustierData", JSON.stringify({}));
});

$(".despawnhaustier").click(function () {
	$(".container-menu-pets").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/DespawnHaustier", JSON.stringify({}));
});

$(".getball").click(function () {
	$(".container-menu-pets").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/GetBall", JSON.stringify({}));
});

$(".attechpeople").click(function () {
	$(".container-menu-pets").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/attech", JSON.stringify({}));
});

$(".hinlegen").click(function () {
	$(".container-menu-pets").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/hinlegen", JSON.stringify({}));
});

$(".heanderhoch").click(function () {
	$(".container-menu-animation").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/Heanderhochanim", JSON.stringify({}));
});
$(".arrest").click(function () {
	$(".container-menu-animation").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/arrestanim", JSON.stringify({}));
});
$(".ducken").click(function () {
	$(".container-menu-animation").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/duckenanim", JSON.stringify({}));
});
window.addEventListener("keyup", function onEvent(event) {
	if (event.key === "g") {
		$(".container-menu-laufen").fadeOut(500);
		$(".container-menu-auto").fadeOut(500);
		$(".container-menu-animation").fadeOut(500);
		$(".container-menu-autooptionen").fadeOut(500);
		$(".container-menu-perso").fadeOut(500);
		$(".container-menu-pets").fadeOut(500);
		$(".container-menu-police").fadeOut(500);

		$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
	}
});

$(".tür").click(function () {
	$(".container-menu-autooptionen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/tueropen", JSON.stringify({}));
});
$(".kofferraum").click(function () {
	$(".container-menu-autooptionen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/kofferopen", JSON.stringify({}));
});
$(".motorhaube").click(function () {
	$(".container-menu-autooptionen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/motoropen", JSON.stringify({}));
});
$(".vordersitz").click(function () {
	$(".container-menu-autooptionen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/vordersitz", JSON.stringify({}));
});
$(".hintenlinks").click(function () {
	$(".container-menu-autooptionen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/hintenlinks", JSON.stringify({}));
});
$(".hintenrechts").click(function () {
	$(".container-menu-autooptionen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/hintenrechts", JSON.stringify({}));
});
$(".seeperso").click(function () {
	$(".container-menu-perso").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/seeperso", JSON.stringify({}));
});
$(".giveperso").click(function () {
	$(".container-menu-perso").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/giveperso", JSON.stringify({}));
});

function OpenPetItem(items) {
	var petname;
	var pettype;
	$(".container-listing").html(" ");

	$.each(items, function (index, item) {
		if (item.petname == undefined) {
			petname = "Kein Name";
		} else {
			petname = item.petname;
		}
		var pettypes = parseInt(item.pettypes);

		if (pettypes === 1) {
			pettype = "Rotweiler";
		} else if (pettypes === 2) {
			pettype = "Pudel";
		} else if (pettypes === 3) {
			pettype = "Mops";
		} else if (pettypes === 4) {
			pettype = "G.Retriever";
		} else if (pettypes === 5) {
			pettype = "Bolognerser";
		} else if (pettypes === 6) {
			pettype = "G.hirte";
		} else if (pettypes === 7) {
			pettype = "Huski";
		} else {
			console.log(pettypes);
		}

		$(".container-listing").append(
			`
			<div class="container-pet" types = ${pettypes}>
			    <h1 class="text-mechanikermenu1">${petname}</h1>
			    <h1 class="interaktiontext1">Typ: ${pettype}</h1>
				<img src="src/A_C_Retriever.png" class="pngofdog" alt="" />
		    </div>
         `
		);
	});
}

$(".changeingmenu").on("click", ".container-pet", function () {
	var $button = $(this);
	var $pettype = $button.attr("types");
	console.log($pettype);
	$(".changeingmenu").hide();
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
	$.post(
		"https://SevenLife_RadialMenu/spawnpet",
		JSON.stringify({ types: $pettype })
	);
});

$(".policemenu").click(function () {
	$(".container-menu-laufen").hide();
	$(".container-menu-police").fadeIn();
});
$(".handschellen").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/handschellen", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});
$(".tragen").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/tragen", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});
$(".autotragen").click(function () {
	$(".container-menu-police").fadeOut(500);

	$.post("https://SevenLife_RadialMenu/autotragen", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});
$(".gefeangnis").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/putingefeangnis", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});

$(".schluesselverleih").click(function () {
	$(".container-menu-auto").fadeOut(500);
	$.post(
		"https://SevenLife_RadialMenu/schluesselverleih",
		JSON.stringify({})
	);
});
$(".container-menu-animation").on("click", ".playanim", function () {
	var $button = $(this);
	var type = $button.attr("type");
	var title = $button.attr("anim");
	var dancedict = $button.attr("dancedict");
	var danceanim = $button.attr("danceanim");
	var prop = $button.attr("prop");
	var propBone = $button.attr("propBone");
	var propPlacement = $button.attr("propPlacement");
	var propTwo = $button.attr("propTwo");
	var propTwoBone = $button.attr("propTwoBone");
	var propTwoPlacement = $button.attr("propTwoPlacement");
	$(".container-menu-animation").fadeOut();
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
	$.post(
		"https://SevenLife_Animations/beginAnimation",
		JSON.stringify({
			type: type,
			dancedict: dancedict,
			danceanim: danceanim,
			prop: prop,
			propBone: propBone,
			propPlacement: propPlacement,
			propTwo: propTwo,
			propTwoBone: propTwoBone,
			propTwoPlacement: propTwoPlacement,
		})
	);
});
$(".durchsuchenderperson").click(function () {
	$(".container-menu-laufen").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/DurchsuchePerson", JSON.stringify({}));
});

$(".wiederbeleben").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/wiederbeleben", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});

$(".pillen").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/pillen", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});

$(".tragencarry").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/carrymmedic", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});

$(".rechnungenmedic").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/rechnungmedic", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});

$(".Medikamente").click(function () {
	$(".container-menu-police").fadeOut(500);
	$.post("https://SevenLife_RadialMenu/medikamente", JSON.stringify({}));
	$.post("https://SevenLife_RadialMenu/CloseMenu", JSON.stringify({}));
});
