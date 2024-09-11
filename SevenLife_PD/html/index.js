var maxval;
var colorid;
var idhut;
var idtorso;
var idshirt;
var idhose;
var idschuhe;
var activatepfeiltasten;
var activestatus = 1;
var activepfeiltastenessen;
var activepfeiltastencctv;
var activepfeiltastenbesuchen;
var cardfirststreifeexist = false;
var cardzweitestreifeexist = false;
var carddrittestreifeexist = false;
var cardviertestreifeexist = false;
var cardfünftestreifeexist = false;
var cardsechstestreifeexist = false;
var cardsiebtestreifeexist = false;
var cardachtestreifeexist = false;
var cardneuntestreifeexist = false;
var cardzehntestreifeexist = false;
var cardelftetestreifeexist = false;

$("document").ready(function () {
	$(".Josie-Container").hide();
	$(".hut").hide();
	$(".radar").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".KastenLoadingVerarbeiter").hide();
	$(".Josie-Container2").hide();
	$(".interaktionsmenu").hide();
	$(".cctvinteraktionsmenu").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	$(".esseninteraktionsmenu").hide();
	//$(".mainpage").hide();
	$(".kleidungsladen").hide();
	$(".outfitpage").hide();
	$(".besucheninteraktionsmenu").hide();
	$(".container-garage").hide();
	$(".mainpage").hide();
	$(".kaufenpage").hide();
	$(".container-garage-heli").hide();
	$(".mainpage-heli").hide();
	$(".kaufenpageheli").hide();
	$(".garagepageheli").hide();

	// Ipad

	$(".ipad-searchperson").hide();
	$(".container-ipad").hide();

	$(".personsuchen").hide();

	$(".personhinzufügen").hide();
	$(".ipad-loadingpage").hide();
	$(".seeperson").hide();
	$(".editplayer").hide();
	$(".giveakte").hide();
	$(".showakte").hide();
	$(".fahndungenausschreiben").hide();
	// Garage
	$(".loadingpage-garage").hide();
	$(".main-garageseepage").hide();
	$(".inputtwohnort").hide();
	$(".inputtfahdung").hide();
	$(".inputtlizenzen").hide();

	//Lizenzen
	$(".lizenzenbild").hide();
	$(".lizenzendetails").hide();

	// Wohnort
	$(".ipad-wohnortsearch").hide();

	// Laptop
	$(".paycheckseite").hide();
	$(".managenapp").hide();
	$(".container-pc").hide();
	$(".mainpage-business-seeingpeople").hide();
	$(".ipad-business").hide();

	$(".inputt-timejail").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenuDienst") {
			$(".Josie-Container").fadeIn(1000);
		} else if (event.data.type === "OpenKleidungsladenMenu") {
			idhut = msg.idhut;
			idtorso = msg.idtorso;
			idshirt = msg.idshirt;
			idhose = msg.idhose;
			idschuhe = msg.idschuhe;
			$(".kleidungsladen").fadeIn();
			$(".mainpage").show();
		} else if (event.data.type === "MakeOutfits") {
			MakeOutfits(msg.result);
		} else if (event.data.type === "OpenInterAktionsMenuPoliceFirst") {
			activatepfeiltasten = true;
		} else if (event.data.type === "OpenWaffen") {
			MakeWaffenLager(msg.result);
			$(".interaktionsmenu").show();

			setTimeout(function () {
				if ($(".selected").length === 0) {
					$(".boxinter").first().addClass("focus");
					$(".boxinter div").first().addClass("selected").focus();
				}
				activatepfeiltasten = true;
			}, 500);
		} else if (event.data.type === "OpenGaragePolizei") {
			$(".container-garage").show();
			$(".mainpage").show();
			$(".kaufenpage").hide();
			$(".garagepage").hide();
			OpenVehicleShop(msg.list2);
		} else if (event.data.type === "AddGarage") {
			OpeenGarageItem(msg.name, msg.plate);
		} else if (event.data.type === "OpenGarageHeliPolizei") {
			$(".container-garage-heli").show();
			$(".mainpage-heli").show();
			$(".kaufenpageheli").hide();
			$(".garagepageheli").hide();
			OpenHeliShop(msg.list3);
		} else if (event.data.type === "AddGarageHeli") {
			OpeenGarageHeliItem(msg.name, msg.plate);
		} else if (event.data.type === "OpenIpad") {
			$(".container-ipad").show();
			document.getElementById("uhrzeit").innerHTML =
				msg.time.hour + ":" + msg.time.minute;
			document.getElementById("datum").innerHTML = msg.datum;
		} else if (event.data.type === "OpenPlayerSearch") {
			$(".ipad-loadingpage").fadeOut(500);
			activestatus = 1;
			$(".ipad-searchperson").show();
			InsertPersons(msg.result);
		} else if (event.data.type === "CloseTablet") {
			CloseMenu();
			document.getElementById("inputturl").value = "";
			document.getElementById("inputtvorname").value = "";
			document.getElementById("inputtnachname").value = "";
			document.getElementById("inputtnumber").value = "";
			document.getElementById("inputt-desc").value = "";
		} else if (event.data.type === "UpdatePlayers") {
			InsertPersons(msg.result);
			$(".ipad-searchperson").show();
			$(".personhinzufügen").fadeOut(500);
		} else if (event.data.type === "OpenInformationPerson") {
			InsertDataPerson(msg.akten, msg.name, msg.info);
		} else if (event.data.type === "OpenEditMenu") {
			$.each(msg.item, function (index, item) {
				document.getElementById("inputturledit").value = item.url;
				document.getElementById("inputtvornameedit").value =
					item.vorname;

				document.getElementById("inputtnachnameedit").value =
					item.nachname;

				document.getElementById("inputtnumberedit").value = item.number;

				document.getElementById("inputt-descedit").innerHTML =
					item.description;

				document
					.getElementById("button-updaten")
					.setAttribute("vorname", item.vorname);
				document
					.getElementById("button-updaten")
					.setAttribute("nachname", item.nachname);
			});
		} else if (event.data.type === "OpenEditMenu2") {
			$(".editplayer").hide();
			$(".seeperson").show();
			$.each(msg.item, function (index, item) {
				document.getElementById("name-person").innerHTML =
					item.firstname + " " + item.lastname;
				document.getElementById("Birthdate").innerHTML =
					item.dateofbirth;
			});
			$.each(msg.info, function (index, item) {
				document.getElementById("PersoNummer").innerHTML = item.number;
				document.getElementById("beschreibunghinzufügen").innerHTML =
					item.description;
			});
		} else if (event.data.type === "UpdateAkten") {
			$(".giveakte").hide();
			$(".personsuchen").show();
		} else if (event.data.type === "InsertAktenDetails") {
			$(".showakte").show();
			$(".seeperson").hide();
			$.each(msg.result, function (index, item) {
				document.getElementById("titelofverbrechen").innerHTML =
					item.titel;
				document.getElementById("datumofverbrechen").innerHTML =
					item.datum;
				document.getElementById("officername").innerHTML = item.officer;
				document.getElementById("geldstrafehöhe").innerHTML =
					item.strafe + "$";
				document.getElementById("haftstrafehöhe").innerHTML =
					item.haftstrafe;
				document.getElementById("beschreibungoftat").innerHTML =
					item.description;
			});
		} else if (event.data.type === "ShowAllCars") {
			var versichertext;

			if (msg.versichert == "false") {
				versichertext = "Nicht Versichert";
			} else {
				versichertext = msg.versichert;
			}
			$(".box-container-car").append(
				`
					<div class="container-garage-plate">
					<h1 class="Kennzeichen-liste" id="Kennzeichen-liste">${msg.plate}</h1>
					<h1 class="Kennzeichen-owner">
					     ${msg.name}
					</h1>
					<h1 class="Kennzeichen-Versicherung">
						Versicherungsnummer: ${versichertext}
					</h1>
				</div>
             `
			);
		} else if (event.data.type === "InsertIDLizenzen") {
			$(".container-ipad-linzenzen").append(
				`
				<div class="container-ipad-lizenzen-inhalt">
				<img
					src="src/baseline_person_white_48dp.png"
					alt=""
					class="personwhite"
				/>
				<h1 class="name-lizenzen-inhalt">
				    ${msg.name}
				</h1>
				<h1 class="name-lizenzen-Id">
					Driver.ID: ${msg.driver}
				</h1>
				<img
					src="src/baseline_search_white_48dp.png"
					alt=""
					id = "${msg.id}"
					name = "${msg.name}"
					class="personwhite2"
				/>
			</div>
             `
			);
		} else if (event.data.type === "OpenLizenzenDetails") {
			$(".lizenzendetails").show();
			$(".lizenzenbild").hide();
			document.getElementById("nameoflizenzen").innerHTML = msg.name;
			if (msg.gunlicense == undefined) {
				document.getElementById("waffenlizenz").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("waffenlizenz").innerHTML = "Vorhanden";
			}
			if (msg.driver == "false") {
				document.getElementById("autolizenze").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("autolizenze").innerHTML = "Vorhanden";
			}
			if (msg.fly == "false") {
				document.getElementById("flugzeuglizenze").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("flugzeuglizenze").innerHTML =
					"Vorhanden";
			}
			if (msg.boot == "false") {
				document.getElementById("bootlizenze").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("bootlizenze").innerHTML = "Vorhanden";
			}
			if (msg.lkw == "false") {
				document.getElementById("lkwlizenze").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("lkwlizenze").innerHTML = "Vorhanden";
			}
			if (msg.motor == "false") {
				document.getElementById("motorlizenze").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("motorlizenze").innerHTML = "Vorhanden";
			}
			if (msg.jagd == "false") {
				document.getElementById("jagdlizenze").innerHTML =
					"Nicht Vorhanden";
			} else {
				document.getElementById("jagdlizenze").innerHTML = "Vorhanden";
			}
		} else if (event.data.type === "InserWohnortData") {
			$(".container-ipad-wohnort").html("");
			$.each(msg.result, function (index, item) {
				$(".container-ipad-wohnort").append(
					`
					<div class="container-ipad-wohnort-inhalt">
					<img
						src="src/baseline_person_white_48dp.png"
						alt=""
						class="personwhite"
					/>
					<h1 class="name-wohnort-inhalt">${item.name}</h1>
					<h1 class="name-wohnort-Id">${item.wohnort}</h1>
				</div>
             `
				);
			});
		} else if (event.data.type === "OpenFandungenTaps") {
			var x = 0;
			$(".container-ipad-fahndungen").html("");
			$.each(msg.result, function (index, item) {
				x++;
				document.getElementById("anzahlfandungen").innerHTML =
					"Anzahl der Fahdungen: " + x;
				$(".container-ipad-fahndungen").append(
					`
					<div class="interaktivfahndungen">
								<h1 class="namefandung">
									Name: ${item.name}
								</h1>
								<h1 class="wegenfandung">
									Wegen: ${item.titel}
								</h1>
								<div class="trennungslinie"></div>
								<button
									class="button-deletefahndung"
									id ="button-deletefahndung"
									deleteid = "${item.id}"
								> 
									Fahndung Einstellen
								</button>
							</div>
             `
				);
			});
		} else if (event.data.type === "OpenPC") {
			$(".container-pc").show();
		} else if (event.data.type === "InsertPDData") {
			$(".managenapp").show();
			$(".container-showallpeople").html("");
			$.each(msg.result, function (index, item) {
				$(".container-showallpeople").append(
					`
					<div class="container-allowpeopleshow">
					<img
						src="src/baseline_person_white_48dp.png"
						class="personbild"
						alt=""
					/>
					<h1 class="nametext">id="${item.name}"</h1>
					<h1 class="angestelltedatum">
						${item.datum}
					</h1>
					<h1 class="angestellterang">Rang: Lutenent</h1>
					<button
						class="button-befördern"
						id="button-befördern" 
						ids="${item.id}"
					>
						Befördern
					</button>
					<button
						class="button-feuern"
						id="button-feuern"
						ids="${item.id}"
					>
						Down Ranken
					</button>
				</div>
                `
				);
			});
		} else if (event.data.type === "OpenEssenMenu") {
			$(".esseninteraktionsmenu").show();
			activepfeiltastenessen = true;
			if ($(".selected").length === 0) {
				$(".boxinter2").first().addClass("focus");
				$(".boxinter2 div").first().addClass("selected").focus();
			}
		} else if (event.data.type === "OpenBesucherBild") {
			$(".besucheninteraktionsmenu").show();
			activepfeiltastenbesuchen = true;
			if ($(".selected").length === 0) {
				$(".boxinter3").first().addClass("focus");
				$(".boxinter3 div").first().addClass("selected").focus();
			}
		} else if (event.data.type === "OpenCCTVMenu") {
			MakeCCTV(msg.result);
			$(".cctvinteraktionsmenu").show();
			activepfeiltastencctv = true;
			if ($(".selected").length === 0) {
				$(".boxinter4").first().addClass("focus");
				$(".boxinter4 div").first().addClass("selected").focus();
			}
		} else if (event.data.type === "InsertPlayersPD") {
			$("#chiefofdepartment").html(" ");
			$("#assistanchief").html(" ");
			$("#deputychief").html(" ");
			$("#inspector").html(" ");
			$("#captain").html(" ");
			$("#agent").html(" ");
			$("#leutnant").html(" ");
			$("#sergeant").html(" ");
			$("#detective").html(" ");
			$("#policeofficer").html(" ");
			$("#rekrutofficer").html(" ");
			$("#kadett").html(" ");
			$("#chiefofdepartment").append(
				`
				<h1 class="leistellentext2">
									- Chief of Department
								</h1>
			`
			);
			$("#assistanchief").append(
				`
				<h1 class="leistellentext2">
									- Assistant Chief
								</h1>
			`
			);
			$("#deputychief").append(
				`
				<h1 class="leistellentext2">- Deputy Chief</h1>
			`
			);
			$("#inspector").append(
				`
				<h1 class="leistellentext2">- Inspector</h1>
			`
			);
			$("#captain").append(
				`
				<h1 class="leistellentext2">- Captain</h1>
			`
			);
			$("#agent").append(
				`
				<h1 class="leistellentext2">- Agent</h1>
			`
			);
			$("#leutnant").append(
				`
				<h1 class="leistellentext2">- Leutnant</h1>
			`
			);
			$("#sergeant").append(
				`
				<h1 class="leistellentext2">- Sergeant</h1>
			`
			);
			$("#detective").append(
				`
				<h1 class="leistellentext2">- Detective</h1>
			`
			);
			$("#policeofficer").append(
				`
				<h1 class="leistellentext2">
									- Police Officer
								</h1>
			`
			);
			$("#rekrutofficer").append(
				`
				<h1 class="leistellentext2">
									- Rekrut Officer
								</h1>
			`
			);
			$("#kadett").append(
				`
				<h1 class="leistellentext2">- Kadett</h1>
			`
			);
			$.each(msg.players, function (index, item) {
				if (item.job == "ChiefofDepartment") {
					$("#chiefofdepartment").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "AssistantChief") {
					$("#assistanchief").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "DeputyChief") {
					$("#deputychief").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Inspector") {
					$("#inspector").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Captain") {
					$("#captain").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Agent") {
					$("#agent").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Leutnant") {
					$("#leutnant").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Sergeant") {
					$("#sergeant").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Detective") {
					$("#detective").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "PoliceOfficer") {
					$("#policeofficer").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "RekrutOfficer") {
					$("#rekrutofficer").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				} else if (item.job == "Kadett") {
					$("#kadett").append(
						`
						<h1 class="detailnametext">
							${item.ingamename}
						</h1>
					`
					);
				}
			});
		} else if (event.data.type === "InsterPlayersOfficial") {
			cardfirststreifeexist = false;
			cardzweitestreifeexist = false;
			carddrittestreifeexist = false;
			cardviertestreifeexist = false;
			cardfünftestreifeexist = false;
			cardsechstestreifeexist = false;
			cardsiebtestreifeexist = false;
			cardachtestreifeexist = false;
			cardneuntestreifeexist = false;
			cardzehntestreifeexist = false;
			cardelftetestreifeexist = false;
			$(".box-container-abwesend").html(" ");
			$(".box-container-streifedienst").html(" ");
			$.each(msg.players, function (index, item) {
				if (item.streife === "eingeteilt") {
					$(".box-container-abwesend").append(
						`
						<h1 class="eingeteiltetexte">
							${item.ingamename}
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 1) {
					if (cardfirststreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte" id="erstestreife">
								<h1 class="streifentext">Streife #1</h1>
								<div
									class="box-container-namestreifendienst"
									id="streifeeins"
								></div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="erstestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="erstestreifeopen"
								/>
							</div>
						`
						);
						cardfirststreifeexist = true;
					}
					$("#streifeeins").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 2) {
					if (cardzweitestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="zweitestreife" >
								<h1 class="streifentext">Streife #2</h1>
								<div class="box-container-namestreifendienst" id="streifezweite" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="zweitestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="zweitestreifeopen"
								/>
							</div>
						`
						);
						cardzweitestreifeexist = true;
					}
					$("#streifezweite").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 3) {
					if (carddrittestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="drittestreife" >
								<h1 class="streifentext">Streife #3</h1>
								<div class="box-container-namestreifendienst" id="streifedritte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="drittestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="drittestreifeopen"
								/>
							</div>
						`
						);
						carddrittestreifeexist = true;
					}
					$("#streifedritte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 4) {
					if (cardviertestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="viertestreife" >
								<h1 class="streifentext">Streife #4</h1>
								<div class="box-container-namestreifendienst" id="streifevierte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="viertestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="viertestreifeopen"
								/>
							</div>
						`
						);
						cardviertestreifeexist = true;
					}
					$("#streifevierte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 5) {
					if (cardfünftestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="füfntestreife" >
								<h1 class="streifentext">Streife #5</h1>
								<div class="box-container-namestreifendienst" id="streifefüfnte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="fuenftestreifeclose"
								/>
								<img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="fuenftestreifeopen"
							/>
							</div>
						`
						);
						cardfünftestreifeexist = true;
					}
					$("#streifefüfnte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 6) {
					if (cardsechstestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="sechsstreife" >
								<h1 class="streifentext">Streife #6</h1>
								<div class="box-container-namestreifendienst" id="streifesechs" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="sechstestreifeclose"
								/>
								<img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="sechstestreifeopen"
							/>
							</div>
						`
						);
						cardsechstestreifeexist = true;
					}
					$("#streifesechs").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 7) {
					if (cardsiebtestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="siebenstreife" >
								<h1 class="streifentext">Streife #7</h1>
								<div class="box-container-namestreifendienst" id="streifesieben" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="siebtestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="siebtestreifeopen"
							/>
							</div>
						`
						);
						cardsiebtestreifeexist = true;
					}
					$("#streifesieben").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 8) {
					if (cardachtestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="achtstreife" >
								<h1 class="streifentext">Streife #8</h1>
								<div class="box-container-namestreifendienst" id="streifeacht" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="achtestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="achtestreifeopen"
							/>
							</div>
						`
						);
						cardachtestreifeexist = true;
					}
					$("#streifeacht").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 9) {
					if (cardneuntestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="neuntestreife" >
								<h1 class="streifentext">Streife #9</h1>
								<div class="box-container-namestreifendienst" id="streifeneunte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="neuntestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="neuntestreifeopen"
							/>
							</div>
						`
						);
						cardneuntestreifeexist = true;
					}
					$("#streifeneunte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 10) {
					if (cardzehntestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="zehntestreife" >
								<h1 class="streifentext">Streife #10</h1>
								<div class="box-container-namestreifendienst" id="streifezehnte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="zehntestreifeclose"
								/>
								<img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="zehntestreifeopen"
							/>
							</div>
						`
						);
						cardzehntestreifeexist = true;
					}
					$("#streifezehnte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 11) {
					if (cardelftetestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="elftestreife" >
								<h1 class="streifentext">Streife #11</h1>
								<div class="box-container-namestreifendienst" id="streifeelfte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="elftestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="elftezehntestreifeopen"
							/>
							</div>
						`
						);
						cardelftetestreifeexist = true;
					}
					$("#streifeelfte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				}
			});
		} else if (event.data.type === "UpdateAllPoliceSee") {
			$(".box-container-abwesend").html(" ");
			$(".box-container-streifedienst").html(" ");
			cardfirststreifeexist = false;
			cardzweitestreifeexist = false;
			carddrittestreifeexist = false;
			cardviertestreifeexist = false;
			cardfünftestreifeexist = false;
			cardsechstestreifeexist = false;
			cardsiebtestreifeexist = false;
			cardachtestreifeexist = false;
			cardneuntestreifeexist = false;
			cardzehntestreifeexist = false;
			cardelftetestreifeexist = false;
			$.each(msg.players, function (index, item) {
				if (item.streife === "eingeteilt") {
					$(".box-container-abwesend").append(
						`
						<h1 class="eingeteiltetexte">
							${item.ingamename}
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 1) {
					if (cardfirststreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte" id="erstestreife">
								<h1 class="streifentext">Streife #1</h1>
								<div
									class="box-container-namestreifendienst"
									id="streifeeins"
								></div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="erstestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="erstestreifeopen"
								/>
							</div>
						`
						);
						cardfirststreifeexist = true;
					}
					$("#streifeeins").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 2) {
					if (cardzweitestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="zweitestreife" >
								<h1 class="streifentext">Streife #2</h1>
								<div class="box-container-namestreifendienst" id="streifezweite" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="zweitestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="zweitestreifeopen"
								/>
							</div>
						`
						);
						cardzweitestreifeexist = true;
					}
					$("#streifezweite").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 3) {
					if (carddrittestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="drittestreife" >
								<h1 class="streifentext">Streife #3</h1>
								<div class="box-container-namestreifendienst" id="streifedritte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="drittestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="drittestreifeopen"
								/>
							</div>
						`
						);
						carddrittestreifeexist = true;
					}
					$("#streifedritte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 4) {
					if (cardviertestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="viertestreife" >
								<h1 class="streifentext">Streife #4</h1>
								<div class="box-container-namestreifendienst" id="streifevierte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="viertestreifeclose"
								/>
								<img
									src="src/baseline_person_white_48dp.png"
									alt=""
									class="openstreife"
									id="viertestreifeopen"
								/>
							</div>
						`
						);
						cardviertestreifeexist = true;
					}
					$("#streifevierte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 5) {
					if (cardfünftestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="füfntestreife" >
								<h1 class="streifentext">Streife #5</h1>
								<div class="box-container-namestreifendienst" id="streifefüfnte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="fuenftestreifeclose"
								/>
								<img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="fuenftestreifeopen"
							/>
							</div>
						`
						);
						cardfünftestreifeexist = true;
					}
					$("#streifefüfnte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 6) {
					if (cardsechstestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="sechsstreife" >
								<h1 class="streifentext">Streife #6</h1>
								<div class="box-container-namestreifendienst" id="streifesechs" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="sechstestreifeclose"
								/>
								<img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="sechstestreifeopen"
							/>
							</div>
						`
						);
						cardsechstestreifeexist = true;
					}
					$("#streifesechs").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 7) {
					if (cardsiebtestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="siebenstreife" >
								<h1 class="streifentext">Streife #7</h1>
								<div class="box-container-namestreifendienst" id="streifesieben" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="siebtestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="siebtestreifeopen"
							/>
							</div>
						`
						);
						cardsiebtestreifeexist = true;
					}
					$("#streifesieben").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 8) {
					if (cardachtestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="achtstreife" >
								<h1 class="streifentext">Streife #8</h1>
								<div class="box-container-namestreifendienst" id="streifeacht" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="achtestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="achtestreifeopen"
							/>
							</div>
						`
						);
						cardachtestreifeexist = true;
					}
					$("#streifeacht").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 9) {
					if (cardneuntestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="neuntestreife" >
								<h1 class="streifentext">Streife #9</h1>
								<div class="box-container-namestreifendienst" id="streifeneunte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="neuntestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="neuntestreifeopen"
							/>
							</div>
						`
						);
						cardneuntestreifeexist = true;
					}
					$("#streifeneunte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 10) {
					if (cardzehntestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="zehntestreife" >
								<h1 class="streifentext">Streife #10</h1>
								<div class="box-container-namestreifendienst" id="streifezehnte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="zehntestreifeclose"
								/>
								<img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="zehntestreifeopen"
							/>
							</div>
						`
						);
						cardzehntestreifeexist = true;
					}
					$("#streifezehnte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				} else if (parseInt(item.streife) === 11) {
					if (cardelftetestreifeexist === false) {
						$(".box-container-streifedienst").append(
							`
							<div class="streifenkarte"  id="elftestreife" >
								<h1 class="streifentext">Streife #11</h1>
								<div class="box-container-namestreifendienst" id="streifeelfte" >
									
								</div>
								<img
									src="src/outline_clear_white_48dp.png"
									alt=""
									class="closestreife"
									id="elftestreifeclose"
								/><img
								src="src/baseline_person_white_48dp.png"
								alt=""
								class="openstreife"
								id="elftezehntestreifeopen"
							/>
							</div>
						`
						);
						cardelftetestreifeexist = true;
					}
					$("#streifeelfte").append(
						`
						<h1 class="streifenname">
							${item.ingamename} 
						</h1>
					`
					);
				}
			});
		} else if (event.data.type === "OpenRadar") {
			$(".radar").show();
		} else if (event.data.type === "UpdateRadar") {
			document.getElementById("textfront").innerHTML = msg.vornespeed;
			document.getElementById("textback").innerHTML = msg.backspeed;
			document.getElementById("platetext1").innerHTML = msg.platetext;
			document.getElementById("platetext2").innerHTML = msg.plateback;
		} else if (event.data.type === "RemoveRadar") {
			$(".radar").hide();
		} else if (event.data.type === "OpenMenuHowManyMinutes") {
			$(".inputt-timejail").show();
		} else if (event.data.type === "OpenEvent") {
			$(".Josie-Container2").show();
		} else if (event.data.type === "OpenLoadingbar") {
			$(".KastenLoadingVerarbeiter").show();
			document.getElementById("bar-in").style.width = "0px";
			var inters4 = setInterval(() => {
				var width = $("#bar-in").width();
				document.getElementById("bar-in").style.width =
					width + 5.5 + "px";
				if (width >= 230) {
					$(".KastenLoadingVerarbeiter").hide();
					clearInterval(inters4);
				}
			}, 1400);
		}
	});
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".Josie-Container2").hide();
	$(".container-ipad").hide();
	$(".container-garage-heli").hide();
	$(".mainpage-heli").hide();
	$(".kaufenpageheli").hide();
	$(".garagepageheli").hide();
	$(".container-garage").hide();
	$(".mainpage").hide();
	$(".kaufenpage").hide();
	$(".saveoutifit").hide();
	$(".besucheninteraktionsmenu").hide();
	$(".kleidungsladen").hide();
	$(".outfitpage").hide();
	$(".Josie-Container").hide();
	$(".interaktionsmenu").hide();
	$(".angestellteseite").hide();
	$(".paycheckseite").hide();
	$(".managenapp").hide();
	$(".container-pc").hide();
	$(".esseninteraktionsmenu").hide();
	activestatus = 1;
	document.getElementById("container-ipad-linzenzen").innerHTML = "";
	$.post("https://SevenLife_PD/escape");
	$.post("https://SevenLife_PD/eventsescape");
}

$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_PD/annehmen", JSON.stringify({}));
});

$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_PD/ablehnen", JSON.stringify({}));
});
$(".button-lager").click(function () {
	var endvalue1 = $("#artikelnummer").text();
	var endvalue2 = $("#artikelnummer2").text();
	$(".maskshop").hide();
	$.post(
		"https://SevenLife_PD/BuyProdukt",
		JSON.stringify({ value1: endvalue1, value2: endvalue2 })
	);
});
// Switch to other site

$("#hut").click(function () {
	$(".hut").show();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
});

$("#torso").click(function () {
	$(".hut").hide();
	$(".torso").show();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
});
$("#shirt").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").show();
	$(".pants").hide();
	$(".shoes").hide();
});
$("#hose").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").show();
	$(".shoes").hide();
});
$("#schuhe").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").show();
});
// Anwenden

$("#buttonanwendenhut").click(function () {
	var endvalue1 = $("#artikelnummerhut1").text();
	var endvalue2 = $("#artikelnummerhut2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Kopfbede #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});

$("#buttonanwendentorso").click(function () {
	var endvalue1 = $("#artikelnummertorso1").text();
	var endvalue2 = $("#artikelnummertorso2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Torso #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});

$("#buttonanwendenshirt").click(function () {
	var endvalue1 = $("#artikelnummershirt1").text();
	var endvalue2 = $("#artikelnummershirt2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">T-Shirt #${endvalue1}</h1>
			<h1 class="zahlen">100$</h1>
		</div>
		`
	);
});

$("#buttonanwendenhose").click(function () {
	var endvalue1 = $("#artikelnummerhose1").text();
	var endvalue2 = $("#artikelnummerhose2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Hose #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});

$("#buttonanwendenschuhe").click(function () {
	var endvalue1 = $("#artikelnummerschuhe1").text();
	var endvalue2 = $("#artikelnummerschuhe1").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Schuhe #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});
// Buttons Hut

$("#buttonhutleft1").click(function () {
	var value = $("#artikelnummerhut1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhut1").innerHTML = idhut;
	} else {
		document.getElementById("artikelnummerhut1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhut1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHut1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonhutright1").click(function () {
	var value1 = $("#artikelnummerhut1").text();
	var value2 = parseInt(value1);
	if (value1 > idhut) {
		document.getElementById("artikelnummerhut1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhut1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhut1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHut1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonhutleft2").click(function () {
	var value = $("#artikelnummerhut2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhut2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummerhut2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhut2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHut2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonhutright2").click(function () {
	var value1 = $("#artikelnummerhut2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummerhut2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhut2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhut2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHut2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons Torso

$("#buttontorsoleft1").click(function () {
	var value = $("#artikelnummertorso1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummertorso1").innerHTML = idtorso;
	} else {
		document.getElementById("artikelnummertorso1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummertorso1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleTorso1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttontorsoright1").click(function () {
	var value1 = $("#artikelnummertorso1").text();
	var value2 = parseInt(value1);
	if (value1 > idtorso) {
		document.getElementById("artikelnummertorso1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummertorso1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummertorso1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleTorso1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttontorsoleft2").click(function () {
	var value = $("#artikelnummertorso2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummertorso2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummertorso2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummertorso2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleTorso2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttontorsoright2").click(function () {
	var value1 = $("#artikelnummertorso2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummertorso2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummertorso2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummertorso2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleTorso2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons Shirt

$("#buttonshirtleft1").click(function () {
	var value = $("#artikelnummershirt1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummershirt1").innerHTML = idshirt;
	} else {
		document.getElementById("artikelnummershirt1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummershirt1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleShirt1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonshirtright1").click(function () {
	var value1 = $("#artikelnummershirt1").text();
	var value2 = parseInt(value1);
	if (value1 > idshirt) {
		document.getElementById("artikelnummershirt1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummershirt1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummershirt1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleShirt1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonshirtleft2").click(function () {
	var value = $("#artikelnummershirt2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummershirt2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummershirt2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummershirt2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleShirt2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonshirtright2").click(function () {
	var value1 = $("#artikelnummershirt2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummershirt2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummershirt2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummershirt2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleShirt2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons hose

$("#buttonhoseleft1").click(function () {
	var value = $("#artikelnummerhose1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhose1").innerHTML = idhose;
	} else {
		document.getElementById("artikelnummerhose1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhose1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHose1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonhoseright1").click(function () {
	var value1 = $("#artikelnummerhose1").text();
	var value2 = parseInt(value1);
	if (value1 > idhose) {
		document.getElementById("artikelnummerhose1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhose1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhose1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHose1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonhoseleft2").click(function () {
	var value = $("#artikelnummerhose2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhose2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummerhose2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhose2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHose2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonhoseright2").click(function () {
	var value1 = $("#artikelnummerhose2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummerhose2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhose2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhose2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleHose2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons Schuhe

$("#buttonschuheleft1").click(function () {
	var value = $("#artikelnummerschuhe1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerschuhe1").innerHTML = idschuhe;
	} else {
		document.getElementById("artikelnummerschuhe1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerschuhe1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleSchuhe1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonschuheright1").click(function () {
	var value1 = $("#artikelnummerschuhe1").text();
	var value2 = parseInt(value1);
	if (value1 > idschuhe) {
		document.getElementById("artikelnummerschuhe1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerschuhe1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerschuhe1").text();
	$.post(
		"https://SevenLife_PD/MakeArticleSchuhe1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonschuheleft2").click(function () {
	var value = $("#artikelnummerschuhe2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerschuhe2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummerschuhe2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerschuhe2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleSchuhe2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonschuheright2").click(function () {
	var value1 = $("#artikelnummerschuhe2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummerschuhe2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerschuhe2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerschuhe2").text();
	$.post(
		"https://SevenLife_PD/MakeArticleSchuhe2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});
// Kauf Button

$(".buttonkaufen").click(function () {
	$(".kleidungsladen").hide();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	var preis = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	$(".listofitems").html(" ");
	document.getElementById("preistotal").innerHTML = "$0";
	document.getElementById("preistotal").setAttribute("data-value", "0");
	$.post(
		"https://SevenLife_PD/PayForOutfit",
		JSON.stringify({ preis: preis })
	);
});

// Save Button

$(".buttonspeichern").click(function () {
	$(".saveoutifit").show();
});

$(".buttonabbrechen").click(function () {
	$(".saveoutifit").hide();
	document.getElementById("inputtsoutfit").value = "";
});

$(".buttonspeichern2").click(function () {
	$(".saveoutifit").hide();
	CloseMenu();
	var preis = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	$(".listofitems").html(" ");
	document.getElementById("preistotal").innerHTML = "$0";
	document.getElementById("preistotal").setAttribute("data-value", "0");
	var $inputt = document.getElementById("inputtsoutfit").value;
	var cleanstring = $inputt.replace(/[^a-zA-Z ]/g, "");

	if (isEmpty(cleanstring)) {
		$.post("https://SevenLife_PD/Error", JSON.stringify({}));
	} else {
		$.post(
			"https://SevenLife_PD/SaveOutfitandPay",
			JSON.stringify({ preis: preis, input: cleanstring })
		);
	}
});

function isEmpty(value) {
	return value == null || value.length === 0;
}

$(".buttonoutfits").click(function () {
	$(".mainpage").hide();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	$(".outfitpage").show();
	$.post("https://SevenLife_PD/GetOutfits", JSON.stringify({}));
});

$(".buttonzurück").click(function () {
	$(".mainpage").show();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	$(".outfitpage").hide();
});

function MakeOutfits(items) {
	$(".container-outfit").html("");
	$.each(items, function (index, item) {
		$(".container-outfit").append(
			`
			<div class="container-innerercontainer" name = ${item.outfitname} model = ${item.model} skin = ${item.skin} outfitId = ${item.outfitId}>
			    <h1 class="outfittext">${item.outfitname} </h1>
			    <button
				  type="button"
				  id="buttondelete"
				  class="buttondelete"
			      name = ${item.outfitname} 
				  model = ${item.model} 
				  skin = ${item.skin} 
				  outfitId = ${item.outfitId}
			    >
				<img
					src="src/outline_delete_white_36dp.png"
					class="bildimgage"
					alt=""
				/>
			   </button>
		    </div>
             `
		);
	});
}

$(".outfitpage").on("click", ".buttondelete", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $model = $button.attr("model");
	var $skin = $button.attr("skin");
	var $outfitId = $button.attr("outfitId");
	CloseMenu();
	$.post(
		"https://SevenLife_PD/DeleteOutfit",
		JSON.stringify({
			name: $name,
			model: $model,
			skin: $skin,
			outfitId: $outfitId,
		})
	);
});

$(".outfitpage").on("click", ".container-innerercontainer", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $model = $button.attr("model");
	var $skin = $button.attr("skin");
	var $outfitId = $button.attr("outfitId");
	$.post(
		"https://SevenLife_PD/ShowOutfit",
		JSON.stringify({
			name: $name,
			model: $model,
			skin: $skin,
			outfitId: $outfitId,
		})
	);
});

document.onkeydown = function (e) {
	if (activatepfeiltasten) {
		switch (e.keyCode) {
			case 38:
				moveUpFirstPDInteraktion();
				break;
			case 40:
				moveDownFirstPDInteraktion();
				break;
			case 13:
				$(".interaktionsmenu").hide();
				var box = $(".selected");
				var action = box.attr("typeofaction");

				$.post(
					"https://SevenLife_PD/ActionMake",
					JSON.stringify({ action: action })
				);

				activatepfeiltasten = false;
		}
	} else if (activepfeiltastenessen) {
		switch (e.keyCode) {
			case 38:
				moveUpEssenInteraktion();
				break;
			case 40:
				moveDownEssenInteraktion();
				break;
			case 13:
				$(".esseninteraktionsmenu").hide();
				var box = $(".selected");
				var action = box.attr("typeofaction");

				$.post(
					"https://SevenLife_PD/MakeActionEssen",
					JSON.stringify({ action: action })
				);

				activepfeiltastenessen = false;
		}
	} else if (activepfeiltastenbesuchen) {
		switch (e.keyCode) {
			case 38:
				moveUpBesuchenInteraktion();
				break;
			case 40:
				moveDownBesuchenInteraktion();
				break;
			case 13:
				$(".besucheninteraktionsmenu").hide();
				var box = $(".selected");
				var action = box.attr("typeofaction");

				$.post(
					"https://SevenLife_PD/MakeActionBesuchen",
					JSON.stringify({ action: action })
				);

				activepfeiltastenbesuchen = false;
		}
	} else if (activepfeiltastencctv) {
		document
			.getElementsByClassName("boxcontainer selected")[0]
			.scrollIntoView();
		switch (e.keyCode) {
			case 38:
				moveUpCCTVInteraktion();

				break;
			case 40:
				moveDownCCTVInteraktion();

				break;
			case 13:
				$(".cctvinteraktionsmenu").hide();
				var box = $(".selected");
				var action = box.attr("typeofaction");

				$.post(
					"https://SevenLife_PD/MakeCCTV",
					JSON.stringify({ action: action })
				);

				activepfeiltastencctv = false;
		}
	}
};

function moveUpEssenInteraktion() {
	if ($(".selected").prev("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.prev("div")
			.addClass("selected")
			.focus();
	}
}

function moveDownEssenInteraktion() {
	if ($(".selected").next("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.next("div")
			.addClass("selected")
			.focus();
	}
}
function moveUpBesuchenInteraktion() {
	if ($(".selected").prev("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.prev("div")
			.addClass("selected")
			.focus();
	}
}

function moveDownBesuchenInteraktion() {
	if ($(".selected").next("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.next("div")
			.addClass("selected")
			.focus();
	}
}
function moveUpFirstPDInteraktion() {
	if ($(".selected").prev("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.prev("div")
			.addClass("selected")
			.focus();
	}
}

function moveDownFirstPDInteraktion() {
	if ($(".selected").next("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.next("div")
			.addClass("selected")
			.focus();
	}
}
function moveUpCCTVInteraktion() {
	if ($(".selected").prev("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.prev("div")
			.addClass("selected")
			.focus();
	}
}

function moveDownCCTVInteraktion() {
	if ($(".selected").next("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.next("div")
			.addClass("selected")
			.focus();
	}
}
function MakeWaffenLager(items) {
	var id = 0;
	$(".boxinter").html("");
	$.each(items, function (index, item) {
		id++;
		$(".boxinter").append(
			`
	    <div class="boxcontainer" typeofaction="${id}">
	       <h1 class="text-boxcontainer" label = ${item.label} costs = ${item.costs} value = ${item.value}>${item.name}</h1>
        </div>	
      `
		);
	});
}
function MakeCCTV(items) {
	var id = 0;
	$(".boxinter4").html("");
	$.each(items, function (index, item) {
		id++;
		$(".boxinter4").append(
			`
	    <div class="boxcontainer" typeofaction="${id}">
	       <h1 class="text-boxcontainer">Camera #${id}</h1>
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
function OpenVehicleShop(items) {
	$(".autos-liste").html(" ");

	$.each(items, function (index, item) {
		$(".autos-liste").append(
			`
         <div class="autoteil" name = ${item.lable} preis = ${item.costs} spawnname = ${item.spawnname}>
         <div class="leftautoteil">
            <img src="src/outline_directions_car_filled_white_36dp.png" class="car" alt="">
         </div>
         <h1 class="vehiclename">
             ${item.name} 
         </h1>
         <h1 class="preis">
              ${item.costs}$
         </h1>
        </div>
         `
		);
	});
}
$(".container-garage").on("click", ".autoteil", function () {
	$(".container-garage").hide();
	var $button = $(this);
	var $name = $button.attr("spawnname");
	var $price = $button.attr("preis");
	$.post(
		"https://SevenLife_PD/BuyVehicle",
		JSON.stringify({ car: $name, price: $price })
	);
});

$(".container-garage").on("click", ".autoteils", function () {
	$(".container-garage").hide();
	$(".autos-listes").html("");
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"https://SevenLife_PD/ParkVehicleOut",
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
	$.post("https://SevenLife_PD/GetVehicles", JSON.stringify({}));
});

$(".pacezweiheli").click(function () {
	$(".mainpage-heli").hide();
	$(".kaufenpageheli").fadeIn(50);
});

$(".placeeinsheli").click(function () {
	$(".mainpage-heli").hide();
	$(".garagepageheli").fadeIn(50);
	$.post("https://SevenLife_PD/GetHelis", JSON.stringify({}));
});

function OpeenGarageHeliItem(name, plate) {
	$(".helis-listes").append(
		`
		<div class="heliteils" name = ${plate}>
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
function OpenHeliShop(items) {
	$(".helis-liste").html(" ");

	$.each(items, function (index, item) {
		$(".helis-liste").append(
			`
         <div class="heliteil" name = ${item.lable} preis = ${item.costs} spawnname = ${item.spawnname}>
         <div class="leftautoteil">
            <img src="src/outline_directions_car_filled_white_36dp.png" class="car" alt="">
         </div>
         <h1 class="vehiclename">
             ${item.name} 
         </h1>
         <h1 class="preis">
              ${item.costs}$
         </h1>
        </div>
         `
		);
	});
}

$(".container-garage-heli").on("click", ".heliteil", function () {
	$(".container-garage-heli").hide();
	var $button = $(this);
	var $name = $button.attr("spawnname");
	var $price = $button.attr("preis");
	$.post(
		"https://SevenLife_PD/BuyHeli",
		JSON.stringify({ car: $name, price: $price })
	);
});

$(".container-garage-heli").on("click", ".heliteils", function () {
	$(".container-garage-heli").hide();
	$(".helis-listes").html("");
	var $button = $(this);
	var $name = $button.attr("name");
	$.post(
		"https://SevenLife_PD/ParkHeliOut",
		JSON.stringify({ plate: $name })
	);
});

$("#searchperson").click(function () {
	$(".ipad-loadingpage").fadeIn(300);
	$.post("https://SevenLife_PD/GetPlayerDataSearch", JSON.stringify({}));
});
function InsertPersons(player) {
	$(".container-insertpersons").html("");
	$.each(player, function (index, item) {
		$(".container-insertpersons").append(
			`
			<div class="container-infoperson">
				<img
					src="src/baseline_person_white_48dp.png"
					class="person-container"
					alt=""
				/>
				<h1 class="container-name-person">
					${item.vorname} ${item.nachname} 
			    </h1>
			    <div class="strich-abändern"></div>
				<h1 class="container-name-nummer">
				    ${item.number}
				</h1>
				<img
					src="src/baseline_search_white_48dp.png"
					class="searchplayericon"
					alt=""
					vorname = "${item.vorname}"
					nachname = "${item.nachname}"
				/>
			</div>
             `
		);
	});
}
$(".gohome").click(function () {
	$(".ipad-searchperson").fadeOut(500);
});
$(".button-addplayer").click(function () {
	$(".personsuchen").fadeOut(500);
	$(".personhinzufügen").show();
});
$(".goback").click(function () {
	$(".personsuchen").show();
	$(".personhinzufügen").fadeOut(500);
});
$(".button-abschicken").click(function () {
	var $url = document.getElementById("inputturl").value;
	var $vorname = document.getElementById("inputtvorname").value;
	var $nachname = document.getElementById("inputtnachname").value;
	var $nummer = document.getElementById("inputtnumber").value;
	var $desc = document.getElementById("inputt-desc").value;
	$(".personsuchen").show();
	$(".personhinzufügen").fadeOut(500);
	$.post(
		"https://SevenLife_PD/InsertPlayer",
		JSON.stringify({
			url: $url,
			vorname: $vorname,
			nachname: $nachname,
			nummer: $nummer,
			desc: $desc,
		})
	);
});
$(".goback2").click(function () {
	$(".personsuchen").show();
	$(".seeperson").fadeOut(500);
	document.getElementById("container-ipad-linzenzen").innerHTML = "";
});

$(".ipadbackground").on("click", ".searchplayericon", function () {
	var $button = $(this);
	var $vorname = $button.attr("vorname");
	var $nachname = $button.attr("nachname");
	document
		.getElementById("aktehinzufügen")
		.setAttribute("nameofplayer", $vorname + " " + $nachname);
	$(".personsuchen").fadeOut(500);
	$(".seeperson").show();

	$.post(
		"https://SevenLife_PD/GetAkten",
		JSON.stringify({
			vorname: $vorname,
			nachname: $nachname,
		})
	);
});
function InsertDataPerson(akten, name, info) {
	$.each(name, function (index, item) {
		document.getElementById("name-person").innerHTML =
			item.firstname + " " + item.lastname;
		document.getElementById("Birthdate").innerHTML = item.dateofbirth;
		document
			.getElementById("button-editplayer")
			.setAttribute("vorname", item.firstname);
		document
			.getElementById("button-editplayer")
			.setAttribute("nachname", item.lastname);
	});

	$.each(info, function (index, item) {
		document.getElementById("PersoNummer").innerHTML = item.number;
		document.getElementById("beschreibunghinzufügen").innerHTML =
			item.description;
	});

	$(".container-akten").html("");
	$.each(akten, function (index, item) {
		$(".container-akten").prepend(
			`
			<div class="container-akten-dex">
			<h1 class="Detail-idakten">	#${item.id}</h1>
			<div class="strich-abändern3"></div>
			<h1 class="Detail-titel">
				${item.titel}
			</h1>
			<div class="strich-abändern4"></div>
			<h1 class="Detail-datum">${item.datum}</h1>
			<img
				src="src/baseline_search_white_48dp.png"
				class="giveinfosakten"
				nameofplayer = "${item.name}"
				id = "${item.id}"
				alt=""
			/>
		   </div>
		 `
		);
	});
}

$(".seeperson").on("click", ".button-editplayer", function () {
	var $button = $(this);
	var $nachname = $button.attr("nachname");
	var $vorname = $button.attr("vorname");
	$(".seeperson").fadeOut(500);
	$(".editplayer").show();

	$.post(
		"https://SevenLife_PD/GetPlayerEdit",
		JSON.stringify({
			vorname: $vorname,
			nachname: $nachname,
		})
	);
});

$(".goback3").click(function () {
	$(".seeperson").show();
	$(".editplayer").fadeOut(500);
});
$(".goback4").click(function () {
	$(".seeperson").show();
	$(".giveakte").fadeOut(500);
});
$(".editplayer").on("click", ".button-updaten", function () {
	var $button = $(this);
	var $nachname = $button.attr("nachname");
	var $vorname = $button.attr("vorname");
	var number = document.getElementById("inputtnumberedit").value;
	var desc = document.getElementById("inputt-descedit").value;
	var url = document.getElementById("inputturledit").value;
	$.post(
		"https://SevenLife_PD/EditPlayer",
		JSON.stringify({
			vorname: $vorname,
			nachname: $nachname,
			number: number,
			desc: desc,
			url: url,
		})
	);
});

$(".giveakte").on("click", ".button-Hinzufügen", function () {
	var $button = $(this);
	var $name = $button.attr("name");

	var titel = document.getElementById("inputtitel").value;
	var detail = document.getElementById("inputt-beschreibungakte").value;
	var geldstrafe = document.getElementById("inputtgeldstrafe").value;
	var haftstrafe = document.getElementById("inputthaftstrafe").value;
	var checkedValue = $(".checkbox-type:checked").val();
	$.post(
		"https://SevenLife_PD/GivePlayerAkte",
		JSON.stringify({
			name: $name,
			titel: titel,
			detail: detail,
			geldstrafe: geldstrafe,
			haftstrafe: haftstrafe,
			checkvalue: checkedValue,
		})
	);
});

$(".container-ipad").on("click", ".button-addakte", function () {
	var $button = $(this);
	var $name = $button.attr("nameofplayer");
	$(".seeperson").fadeOut(500);
	$(".giveakte").show();
	document.getElementById("inputtitel").value = "";
	document.getElementById("inputt-beschreibungakte").value = "";
	document.getElementById("inputtgeldstrafe").value = "";
	document.getElementById("inputthaftstrafe").value = "";
	document.getElementById("button-Hinzufügen").setAttribute("name", $name);
});

$(".goback5").click(function () {
	$(".showakte").hide();
	$(".seeperson").show();
});
$(".seeperson").on("click", ".giveinfosakten", function () {
	var $button = $(this);
	var $name = $button.attr("nameofplayer");
	var $id = $button.attr("id");
	$.post(
		"https://SevenLife_PD/GetAktenDetails",
		JSON.stringify({
			name: $name,
			id: $id,
		})
	);
});

$("#searchcar").click(function () {
	$(".loadingpage-garage").show();
	$.post("https://SevenLife_PD/GetCarsAll", JSON.stringify({}));
	setTimeout(function () {
		$(".loadingpage-garage").hide();
		$(".main-garageseepage").show();
	}, 3000);
});

function searchthroughautos() {
	$(".container-garage-plate").hide();
	let input = document.getElementById("inputt-garagesearch").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("container-garage-plate");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".Kennzeichen-liste")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
function searchnames() {
	$(".container-infoperson").hide();
	let input = document.getElementById("inputtsearchplayer").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("container-infoperson");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".container-name-person")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
$(".backtomaingarage").click(function () {
	$(".main-garageseepage").hide();
	document.getElementById("box-container-car").innerHTML = "";
});

// Button Search Player

$("#searchpersonbutton").click(function () {
	$(".personsuchen").show();
	$(".lizenzenbild").hide();
	$(".ipad-wohnortsearch").hide();
	$(".fahndungenausschreiben").hide();
	document.getElementById("container-ipad-linzenzen").innerHTML = "";
	// Inputts
	$(".inputtsearchplayer").show();
	$(".inputtwohnort").hide();
	$(".inputtfahdung").hide();
	$(".inputtlizenzen").hide();
});

$("#searchwohnort").click(function () {
	$(".personsuchen").hide();
	$(".lizenzenbild").hide();
	$(".ipad-wohnortsearch").show();
	$(".fahndungenausschreiben").hide();
	document.getElementById("container-ipad-linzenzen").innerHTML = "";
	// Inputts
	$(".inputtsearchplayer").hide();
	$(".inputtwohnort").show();
	$(".inputtfahdung").hide();
	$(".inputtlizenzen").hide();

	// Post

	$.post("https://SevenLife_PD/GetUserWohnorte", JSON.stringify({}));
});

$("#searchfahdungbutton").click(function () {
	$(".personsuchen").hide();
	$(".lizenzenbild").hide();
	$(".ipad-wohnortsearch").hide();
	$(".fahndungenausschreiben").show();
	document.getElementById("container-ipad-linzenzen").innerHTML = "";
	// Inputts
	$(".inputtsearchplayer").hide();
	$(".inputtwohnort").hide();
	$(".inputtfahdung").show();
	$(".inputtlizenzen").hide();

	$.post("https://SevenLife_PD/GetFahndungenPD", JSON.stringify({}));
});

$("#searchlizenzenbutton").click(function () {
	$(".personsuchen").hide();
	$(".ipad-wohnortsearch").hide();
	$(".lizenzenbild").show();
	$(".fahndungenausschreiben").hide();
	document.getElementById("container-ipad-linzenzen").innerHTML = "";
	// Inputts
	$(".inputtsearchplayer").hide();
	$(".inputtwohnort").hide();
	$(".inputtfahdung").hide();
	$(".inputtlizenzen").show();

	// Post

	$.post("https://SevenLife_PD/GetLizenzenOfPlayer", JSON.stringify({}));
});

$(".lizenzenbild").on("click", ".personwhite2", function () {
	var $button = $(this);
	var $id = $button.attr("id");
	var $name = $button.attr("name");
	$.post(
		"https://SevenLife_PD/GetDetailsAboutLizenzen",
		JSON.stringify({
			name: $name,
			id: $id,
		})
	);
});

$(".goback6").click(function () {
	$(".lizenzendetails").hide();
	$(".lizenzenbild").show();
});
function searchlizenzen() {
	$(".container-ipad-lizenzen-inhalt").hide();
	let input = document.getElementById("inputtlizenzen").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName(
		"container-ipad-lizenzen-inhalt"
	);

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".name-lizenzen-inhalt")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
function searchwohnort() {
	$(".container-ipad-wohnort-inhalt").hide();
	let input = document.getElementById("inputtwohnort").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName(
		"container-ipad-wohnort-inhalt"
	);

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".name-wohnort-inhalt")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
function searchfahndung() {
	$(".interaktivfahndungen").hide();
	let input = document.getElementById("inputtfahdung").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("interaktivfahndungen");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".namefandung")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}

$(".fahndungenausschreiben").on("click", ".button-deletefahndung", function () {
	var $button = $(this);
	var $id = $button.attr("deleteid");
	$button.parent().hide();
	$.post(
		"https://SevenLife_PD/DeleteFahndung",
		JSON.stringify({
			id: $id,
		})
	);
});
$(".backtomainpagefrombusiness").click(function () {
	$(".ipad-business").hide("slow");
});
$(".right-x-symbol-container").click(function () {
	$(".managenapp").hide("slow");
});
$(".apppc1").click(function () {
	$.post("https://SevenLife_PD/GetDetailsAboutMember", JSON.stringify({}));
});
$("#angestellte").click(function () {
	$(".paycheckseite").hide();
	$(".angestellteseite").show();
});
$("#paycheck").click(function () {
	$(".paycheckseite").show();
	$(".angestellteseite").hide();
});

$(".paycheckseite").on("click", ".button-apply", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $lohn = parseFloat($button.parent().find(".inputtmoneyplayer").val());

	$.post(
		"https://SevenLife_PD/SetLohn",
		JSON.stringify({ type: $name, lohn: $lohn })
	);
});
$(".buttonabbrechen1").click(function () {
	$(".inputt-timejail").hide();
	document.getElementById("inputt-zeit").value = "";
});
$(".buttonspeichernjailtime").click(function () {
	$(".inputt-timejail").hide();
	CloseMenu();
	var $inputt = document.getElementById("inputt-zeit").value;

	$.post(
		"https://SevenLife_PD/PutPlayerInJail",
		JSON.stringify({ haftzeit: $inputt })
	);
});
$("#businessid").click(function () {
	$(".ipad-business").show();
	$.post("https://SevenLife_PD/GetStreife", JSON.stringify({}));
});

$("#button-Aktiv").click(function () {
	$(".mainpage-business").hide();
	$(".mainpage-business-seeingpeople").show();
	$.post("https://SevenLife_PD/GetActivPlayersPD", JSON.stringify({}));
});

$("#button-MainPage").click(function () {
	$(".mainpage-business").show();
	$(".mainpage-business-seeingpeople").hide();
});

$(".button-newstreife").click(function () {
	$.post("https://SevenLife_PD/InsertNewStreife", JSON.stringify({}));
});
$(".ipad-business").on("click", "#erstestreifeclose", function () {
	cardfirststreifeexist = false;

	$.post("https://SevenLife_PD/erstestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#zweitestreifeclose", function () {
	cardzweitestreifeexist = false;

	$.post("https://SevenLife_PD/zweitestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#drittestreifeclose", function () {
	carddrittestreifeexist = false;

	$.post("https://SevenLife_PD/drittestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#viertestreifeclose", function () {
	cardviertestreifeexist = false;

	$.post("https://SevenLife_PD/viertestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#fuenftestreifeclose", function () {
	cardfünftestreifeexist = false;

	$.post("https://SevenLife_PD/fuenftestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#sechstestreifeclose", function () {
	cardsechstestreifeexist = false;

	$.post("https://SevenLife_PD/sechstestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#siebtestreifeclose", function () {
	cardsiebtestreifeexist = false;

	$.post("https://SevenLife_PD/siebtestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#achtestreifeclose", function () {
	cardachtestreifeexist = false;

	$.post("https://SevenLife_PD/achtestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#neuntestreifeclose", function () {
	cardneuntestreifeexist = false;

	$.post("https://SevenLife_PD/neuntestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#zehntestreifeclose", function () {
	cardzehntestreifeexist = false;

	$.post("https://SevenLife_PD/zehntestreifeclose", JSON.stringify({}));
});
$(".ipad-business").on("click", "#elftestreifeclose", function () {
	cardelftetestreifeexist = false;

	$.post("https://SevenLife_PD/elftestreifeclose", JSON.stringify({}));
});

$(".ipad-business").on("click", "#erstestreifeopen", function () {
	$.post("https://SevenLife_PD/erstestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#zweitestreifeopen", function () {
	$.post("https://SevenLife_PD/zweitestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#drittestreifeopen", function () {
	$.post("https://SevenLife_PD/drittestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#viertestreifeopen", function () {
	$.post("https://SevenLife_PD/viertestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#fuenftestreifeopen", function () {
	$.post("https://SevenLife_PD/fuenftestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#sechstestreifeopen", function () {
	$.post("https://SevenLife_PD/sechstestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#siebtestreifeopen", function () {
	$.post("https://SevenLife_PD/siebtestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#achtestreifeopen", function () {
	$.post("https://SevenLife_PD/achtestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#neuntestreifeopen", function () {
	$.post("https://SevenLife_PD/neuntestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#zehntestreifeopen", function () {
	$.post("https://SevenLife_PD/zehntestreifeopen", JSON.stringify({}));
});
$(".ipad-business").on("click", "#elftezehntestreifeopen", function () {
	$.post("https://SevenLife_PD/elftezehntestreifeopen", JSON.stringify({}));
});
$(".submitbuttonseedsf2").click(function () {
	$(".Josie-Container2").hide();
	$.post("https://SevenLife_PD/events", JSON.stringify({}));
});
