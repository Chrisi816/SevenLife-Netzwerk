var paid = 0;
var notpaid = 0;
var overdue = 0;
var background;
var pushe;
var ziel;
var anim;
$("document").ready(function () {
	$(".businesscode").hide();
	document.getElementById("container-phone").style.display = "none";
	$(".phonecontainer").hide();
	//$(".phone-hauptseite").hide();
	$(".funkapps").hide();
	$(".VideoCallStarter").hide();
	//$(".containerauswahl").hide();
	$(".funkapp").hide();
	$(".textsearch").hide();
	$(".schreibenseite").hide();
	$(".imgauswahl2").hide();
	$(".chatapp").hide();
	$(".container-mitglieder").hide();
	//$(".chatseite").hide();
	$(".showstory").hide();
	//$(".containerübersichtoben").hide();
	$(".moredetails").hide();
	$(".imgauswahl").hide();
	$(".statusseite").hide();
	$(".container-chatbusinnes").hide();
	$(".top-liveinvader").hide();
	$(".werbungschalten").hide();
	$(".wlans").hide();
	$(".galerieapp").hide();
	$(".businnessapp").hide();
	$(".allappsdownload").hide();
	$(".größerpage").hide();
	//$(".mainpagegalerie").hide();
	$(".installedapps").hide();
	$(".hauptscreen").hide();
	$(".appstore").hide();
	$(".firstscreen").hide();
	$(".cryptos").hide();
	document.getElementById("writeadispatch").style.display = "none";
	$(".fraktionen-seite").hide();
	$(".dispatchapp").hide();
	$(".cameraapp").hide();
	// Apps
	$(".garage").hide();
	$(".crypto").hide();
	$(".lifeinvader").hide();
	$(".notizen").hide();
	$(".notizenapp").hide();
	$(".anmeldeleiste").hide();
	document.getElementById("removeeinspeichern").style.display = "none";
	$(".appsymbols").hide();
	$(".zweiteseite").hide();
	$(".Lifeinvader").hide();
	$(".bankapp").hide();
	$(".einstellungsapp").hide();
	document.getElementById("einstellungsapp").style.display = "none";
	document.getElementById("appgarage").style.display = "none";
	document.getElementById("secondsite").style.display = "none";
	document.getElementById("container-talephoto").style.display = "none";
	$(".allgeimeins").hide();
	$(".hintergrundapp").hide();
	$(".wifi").hide();
	$(".air").hide();
	$(".letztese").hide();
	$(".gps").hide();
	$(".callapp").hide();
	$(".seitecall").hide();

	$(".spannig").hide();
	$(".anzeiges").hide();
	$(".spannige").hide();
	$(".kontaktes").hide();
	toggle4.classList.toggle("active");
	$(".credits").hide();
	$(".bill-app").hide();
	//$(".galerieapp").hide();
	$(".informations").hide();
	$(".spannigese").hide();
	$(".spanniges").hide();
	$(".nachrichtens").hide();
	$(".check").hide();
	activewifi = false;
	//$(".chatseite").hide();
	$(".Addchat").hide();
	$(".businessapp").hide();

	//$(".loginseite").hide();
	//$(".registerseite").hide();
	//$(".loadingsitecrypto").hide();
	//$(".youdonthaveanaccount").hide();
	//$(".walletdidntexists").hide();
	//$(".zuwenigmoney").hide();
	//$(".erfolg").hide();
	//$(".youhaveannacccount").hide();
	//$(".transseven").hide();
	//$(".transbtc").hide();
	//$(".transeth").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		activehandy = false;
		var audio = null;
		if (msg.type === "openhandy") {
			$(".phonecontainer").fadeIn();
			$(".phone-container").fadeIn();

			// Time
			document.getElementById("phone-zeit").innerHTML =
				msg.time.hour + ":" + msg.time.minute;
			setTimeout(function () {
				activehandy = true;
			}, 1600);
			$.each(msg.result, function (index, result) {
				if (result.name === "Twitter" && result.download === "true") {
				} else {
				}
				if (result.name === "Garage" && result.download === "true") {
					$(".garage").show();
				} else if (typeof msg.name === undefined) {
					$(".garage").hide();
				}
				if (result.name === "Funk" && result.download === "true") {
					$(".funkapps").show();
				} else if (typeof msg.name === undefined) {
					$(".funkapps").hide();
				}
				if (result.name === "Crypto" && result.download === "true") {
					$(".crypto").show();
				} else if (typeof msg.name === undefined) {
					$(".crypto").hide();
				}
				if (
					result.name === "LiveInvader" &&
					result.download === "true"
				) {
					$(".lifeinvader").show();
				} else if (typeof msg.name === undefined) {
					$(".lifeinvader").hide();
				}
				if (result.name === "Notizen" && result.download === "true") {
					$(".notizen").show();
				} else if (typeof msg.name === undefined) {
					$(".notizen").hide();
				}
				if (result.name === "Business" && result.download === "true") {
					$(".businessapp").show();
				} else if (typeof msg.name === undefined) {
					$(".businessapp").hide();
				}
			});
		} else if (msg.type === "lifeinvaderwerbung") {
			displaywerbung(msg.result);
		} else if (msg.type === "UpdateTime") {
			document.getElementById("phone-zeit").innerHTML =
				msg.time.hour + ":" + msg.time.minute;
		} else if (msg.type === "update") {
			var Default =
				"https://cdn.discordapp.com/attachments/954476483651461120/954477111429726218/back001.jpg";
			var itemse = msg.result;
			pushe = itemse.push;
			if (itemse.wallpaper != null) {
				if (itemse.wallpaper != Default) {
					background = msg.result;
					$(".phonebackground").css(
						"background-image",
						"url(" + itemse.wallpaper + ")"
					);
				}
			}
			document.getElementById("nummers").innerHTML = msg.nummer;
			document
				.getElementById("nummers")
				.setAttribute("number", msg.nummer);

			if (itemse.flugmodus === 2) {
				let toggle = document.querySelector(".toggle");
				toggle.classList.toggle("active");
				if (toggle.classList.contains("active")) {
					$(".wifi").hide();
					$(".air").show();
				} else {
					if (activewifi) {
						$(".wifi").show();
					}
					$(".air").hide();
				}
			}
			if (itemse.gps === 2) {
				let toggle2 = document.querySelector(".toggle-gps");
				toggle2.classList.toggle("active");
				if (toggle2.classList.contains("active")) {
					$(".gps").show();
				} else {
					$(".gps").hide();
				}
			}
			document;
			if (itemse.linksrechts != null) {
				document.querySelector(".spannig").value = itemse.linksrechts;
				document.querySelector(".inputig").value = itemse.linksrechts;
				let result = parseInt(itemse.linksrechts) * 15;
				let customresult = parseInt(itemse.linksrechts) * 15 + 8;
				$(".handy-rahmen").css("left", `${result}px`);
				$(".phone-container").css("left", `${customresult}px`);
			}
			if (itemse.oben != null) {
				document.querySelector(".spannige").value = itemse.oben;
				document.querySelector(".inputige").value = itemse.oben;
				let result = parseInt(itemse.oben) * 3;
				let customresult = parseInt(itemse.oben) * 3 + 18;
				$(".handy-rahmen").css("top", `${result}px`);
				$(".phone-container").css("top", `${customresult}px`);
			}

			if (itemse.gresse != null) {
				document.querySelector(".spanniges").value = itemse.gresse;
				document.querySelector(".inputiges").value = itemse.gresse;
				let result = itemse.gresse / 100;
				if (result > 0.49) {
					$(".handy-rahmen").css(
						"transform",
						"scale(" +
							itemse.gresse / 100 +
							"," +
							itemse.gresse / 100 +
							")"
					);

					$(".phone-container").css(
						"transform",
						"scale(" +
							itemse.gresse / 100 +
							"," +
							itemse.gresse / 100 +
							")"
					);
				}
			}
			if (itemse.onlykontakte === 2) {
				let toggle1 = document.querySelector(".toggle-kontakte");
				toggle1.classList.toggle("active");
			}
			if (itemse.wlan === 2) {
				let toggle3 = document.querySelector(".toggle-wlan");
				toggle3.classList.toggle("active");
				if (toggle3.classList.contains("active")) {
					$(".wifi").show();
					$.post(
						"http://SevenLife_Phone/wifi",
						JSON.stringify({ wifi: 2 })
					);
				}
			}
		} else if (msg.type === "updatenummer") {
			document.getElementById("nummers").innerHTML = msg.nummer;
			document
				.getElementById("nummers")
				.setAttribute("number", msg.nummer);
		} else if (msg.type === "OpenRegister") {
			$(".normaleleiste").hide();
			$(".anmeldeleiste").fadeIn(200);
		} else if (msg.type === "openbankapp") {
			$(".bankapp").show();
			$(".phone-hauptseite").hide();
			document.getElementById("guthabenon").innerHTML = msg.cash + "$";
		} else if (msg.type === "Messageincoming") {
			if (parseInt(pushe) === 2) {
				if (audio != null) {
					audio.pause();
				}
				audio = new Howl({ src: ["../src/sounds/message.ogg"] });
				audio.volume(0.5);
				audio.play();
				const content = $(
					`
					<div class="message-container">
						<img src=${msg.pictureurl} class="image-message" alt="">
						<h1 class="nachricht-message">
							${msg.titel}
						</h1>
						<div class="beschreibungs-container">
							<h1 class="beschreibung-message">
							   ${msg.beschreibung}
							 </h1>
						</div>
						
					</div>
					`
				);

				$(".message").prepend(content);
				setTimeout(() => {
					content.hide(2000);
				}, 7000);
			}
		} else if (msg.type === "OpenBill") {
			paid = 0;
			overdue = 0;
			notpaid = 0;
			$(".bill-app").show();
			MakeBills(msg.data);
		} else if (msg.type === "UpdateBill") {
			paid = 0;
			overdue = 0;
			notpaid = 0;

			MakeBills(msg.data);
		} else if (msg.type === "OpenEinspeicherMenu") {
			$(".einspeichern").show();
		} else if (msg.type === "MakeGarage") {
			makeGarage(msg.garage, msg.fuel, msg.labelname);
		} else if (msg.type === "OpenAppStore") {
			$(".appstore").show();
			$(".hauptscreen").show();
			MakeApps(msg.apps);
			if (typeof msg.resultapp !== undefined) {
				MakeDownloadedApps(msg.resultapp);
			}
		} else if (msg.type === "FirstTimeOpenAppStore") {
			$(".appstore").show();
			$(".firstscreen").show();
			MakeApps(msg.apps);
		} else if (msg.type === "OpenDispatchApp") {
			$(".dispatchapp").show();
			$(".frontpage-alldispatches").show();
			$(".writeadispatch").hide();
			$(".fraktionen-seite").hide();
			MakeDipatches(msg.result);
		} else if (msg.type === "updatepush") {
			pushe = msg.result;
		} else if (msg.type === "OpenNotizenApp") {
			$(".notizenapp").show();
			MakeNotizen(msg.result);
		} else if (msg.type === "UpdateNotiz") {
			MakeNotizen(msg.result);
		} else if (msg.type === "MakePhoto") {
			document.getElementById("camerabild").style.backgroundImage =
				"url(" + msg.url + ")";
		} else if (msg.type === "OpenGalerie") {
			InsertDataGalerie(msg.result);
		} else if (msg.type === "OpenDetail") {
			$(".größerpage").show();
			document.getElementById("datum-galerie").innerHTML = msg.datum;
			$(".img-container-mgrößer").html(" ");
			$(".container-löschen").attr("src", msg.src);
			$(".container-teilen").attr("src", msg.src);
			$(".img-container-mgrößer").append(
				`
				<img
					src="${msg.src}"
					alt=""
					class="img-fullview"
				/>
				`
			);
		} else if (msg.type === "OpenSevenDropIMG") {
			$(".sevendrop-image").append(`
			     <div class="hoverbackground">
						<div class="centraldrop">
							<h1 class="sevendrop">SevenDrop</h1>
							<h1 class="sevendrop2">
								Jemand möchte ein Foto mit dir teilen
							</h1>
							<img
								src="${msg.src}"
								class="img-sevendrop"
								alt=""
							/>
							<h1 class="annehmen-accept">Annehmen</h1>
							<h1 class="ablehnennon">Ablehnen</h1>
							<div class="container-annehmen" src= "${msg.src}"></div>
							<div class="container-ablehenen"></div>
						</div>
					</div>
			`);
		} else if (msg.type === "InsertKontakte") {
			InsertContacts(msg.result);
		} else if (msg.type === "OpenDropMenu") {
			$(".sevendrop-kontakte").append(`
			<div class="hoverbackground">
			<div class="centraldropkontakte">
				<h1 class="sevendrop">SevenDrop</h1>
				<h1 class="sevendrop2">
					Jemand möchte eine Nummer mit dir teilen
				</h1>
				<h1 class="annehmen-accept">Annehmen</h1>
				<h1 class="ablehnennon">Ablehnen</h1>
				<div
					class="container-annehmen1"
					nummer="${msg.nummer}"
					name="${msg.name}"
				></div>
				<div class="container-ablehenen"></div>
			</div>
		</div>
   `);
		} else if (event.data.type === "UpdateKontaktList") {
			InsertChatKontakte(msg.result);
		} else if (event.data.type === "OpenMessagingSiteFirst") {
			$(".Addchat").hide();
			$(".containerübersichtoben").hide();
			$(".schreibenseite").show();
			InsertChat(msg.result, msg.identifier);
			document.getElementById("chatname").innerHTML = msg.name;
			document.getElementById("profilbildchat").src = msg.src;
			document.querySelector(".inputt-chat").setAttribute("id", msg.id);
			document
				.querySelector(".videocall")
				.setAttribute("nummer", msg.nummer);
			document.querySelector(".inputt-chat").value = "";
			document.querySelector(".makephoto").setAttribute("id", msg.id);
			scrollToBottom("containerscrollnachrichtennachunte");
		} else if (event.data.type === "UpdateMessageFirst") {
			InsertChat(msg.result, msg.identifier);
			scrollToBottom("containerscrollnachrichtennachunte");
		} else if (event.data.type === "InsertChatsLike") {
			InsertChatsIntoList(msg.result);
		} else if (event.data.type === "UpdateChatLike") {
			InsertChatsIntoList(msg.result);
		} else if (event.data.type === "OpenChatsMaking") {
			$(".chatseite").hide();
			$(".containerübersichtoben").hide();
			$(".schreibenseite").show("fast");
			InsertChat(msg.result, msg.identifier);
			document.getElementById("chatname").innerHTML = msg.name;
			document
				.querySelector(".videocall")
				.setAttribute("nummer", msg.nummer);
			document.getElementById("profilbildchat").src = msg.src;

			document.querySelector(".inputt-chat").setAttribute("id", msg.id);
			document.querySelector(".inputt-chat").value = "";
			document.querySelector(".makephoto").setAttribute("id", msg.id);
			scrollToBottom("containerscrollnachrichtennachunte");
		} else if (event.data.type === "InsertSendList") {
			InsertAll(msg.result);
		} else if (event.data.type === "UpdateStorys") {
			document.getElementById("nameofmyself").innerHTML = msg.name;

			InsertStorys(msg.result);
		} else if (event.data.type === "InsertSendList2") {
			InsertAll2(msg.result);
		} else if (event.data.type === "OpenStory") {
			$(".KastenLoadingVerarbeiter3").show();
			$(".showstory").show();
			$(".statusseite").hide();
			document.getElementById("bar-in3").style.width = "0px";
			document.getElementById("insertimgstory").src = msg.src;
		} else if (event.data.type === "UpdateBar") {
			var width = $("#bar-in3").width();
			document.getElementById("bar-in3").style.width = width + 20 + "px";
		} else if (event.data.type === "RemoveStory") {
			$(".showstory").hide();
			$(".statusseite").show();
		} else if (event.data.type === "OpenAnsichtSelber") {
			$(".VideoCallStarter").show("fast");
			const canvas = document.getElementById("container-yourself");
			MainRender.renderToTarget(canvas);
		} else if (event.data.type === "UpdateChannel") {
			UpdateChannel(msg.result);
		} else if (event.data.type === "OpenAppFunk") {
			$(".phone-hauptseite").hide();
			$(".funkapp").show();
			UpdateChannel(msg.funk);
		} else if (event.data.type === "OpenBusinessNoBusiness") {
			$(".businnessapp").show();
			$(".businesscode").show();
			$(".businessmainpage").hide();
			$(".phone-hauptseite").hide();
		} else if (event.data.type === "OpenBusinessMenuMain") {
			$(".businnessapp").show();
			$(".businessmainpage").show();
			$(".businesscode").hide();
			$(".phone-hauptseite").hide();
			$(".container-mitglieder").show();
			$(".container-chatbusinnes").hide();
			document
				.getElementById("logoutbusiness")
				.setAttribute("ids", msg.id);
			document.getElementById("codevonchat").innerHTML = "C." + msg.code;
			document
				.getElementById("rightsidebusiness")
				.setAttribute("ids", msg.code);

			MakeMitglieder(msg.infos, msg.yourselfadmin);
		} else if (event.data.type === "OpenBusinessMenuMainUpdate") {
			$(".businessmainpage").show();
			$(".businesscode").hide();
			$(".phone-hauptseite").hide();
			$(".container-mitglieder").show();
			$(".container-chatbusinnes").hide();
			document
				.getElementById("logoutbusiness")
				.setAttribute("ids", msg.id);
			document.getElementById("codevonchat").innerHTML = "C." + msg.code;

			MakeMitglieder(msg.infos, msg.yourselfadmin);
		} else if (event.data.type === "InsertChatVerlauf") {
			$(".container-mitglieder").hide();
			$(".container-chatbusinnes").show();
			InsertChatsIntoListBusinnes(msg.chat, msg.identifier);
		}
		$(document).keyup(function (e) {
			if (activehandy) {
				if (e.key === "F1") {
					activehandy = false;
					$(".phonecontainer").fadeOut(300);
					$.post(
						"http://SevenLife_Phone/ClosePhone",
						JSON.stringify({})
					);
				}
			}
		});
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		$(".phonecontainer").fadeOut(300);
		$.post("http://SevenLife_Phone/ClosePhone", JSON.stringify({}));
	}
});

$(".zweiterpunkt").click(function () {
	document.getElementsByClassName("ersterpunk")[0].style.backgroundColor =
		"rgba(255, 255, 255, 0.212)";
	document.getElementsByClassName("zweiterpunkt")[0].style.backgroundColor =
		"rgb(255, 255, 255)";
	$(".ersteseite").fadeOut(300);
	$(".zweiteseite").fadeIn(300);
});
$(".ersterpunk").click(function () {
	document.getElementsByClassName("zweiterpunkt")[0].style.backgroundColor =
		"rgba(255, 255, 255, 0.212)";
	document.getElementsByClassName("ersterpunk")[0].style.backgroundColor =
		"rgb(255, 255, 255)";
	$(".zweiteseite").fadeOut(300);
	$(".ersteseite").fadeIn(300);
});
$(".einstellungen").click(function () {
	$(".einstellungsapp").show();
	$(".phone-hauptseite").hide();
});
$(".linieunten").click(function () {
	$(".einstellungsapp").hide();
	$(".phone-hauptseite").show();
});
$(".hintergrund").click(function () {
	$(".einstellungsapp").hide();
	$(".hintergrundapp").fadeIn(200);
});
$(".backhintergrund").click(function () {
	$(".einstellungsapp").fadeIn(200);
	$(".hintergrundapp").hide();
});
$(".backnachricht").click(function () {
	$(".einstellungsapp").fadeIn(200);
	$(".nachrichtens").hide();
});
$(".backcred").click(function () {
	$(".einstellungsapp").fadeIn(200);
	$(".credits").hide();
});
$(".backinformation").click(function () {
	$(".einstellungsapp").fadeIn(200);
	$(".informations").hide();
});
$(".first").click(function () {
	$(".phonebackground").css(
		"background-image",
		"url( https://cdn.discordapp.com/attachments/954476483651461120/955120987328876604/images_2.jpg )"
	);

	$.post(
		"http://SevenLife_Phone/wallpaper",
		JSON.stringify({
			wallpaper:
				"https://cdn.discordapp.com/attachments/954476483651461120/955120987328876604/images_2.jpg",
		})
	);
});
$(".second").click(function () {
	$(".phonebackground").css(
		"background-image",
		"url( https://cdn.discordapp.com/attachments/954476483651461120/955121169609158726/5f847ab817e9334a7beecf4feb1dad54.jpg )"
	);

	$.post(
		"http://SevenLife_Phone/wallpaper",
		JSON.stringify({
			wallpaper:
				" https://cdn.discordapp.com/attachments/954476483651461120/955121169609158726/5f847ab817e9334a7beecf4feb1dad54.jpg",
		})
	);
});
$(".dritte").click(function () {
	$(".phonebackground").css(
		"background-image",
		"url( https://cdn.discordapp.com/attachments/954476483651461120/955120928453427271/screen-2.jpg )"
	);

	$.post(
		"http://SevenLife_Phone/wallpaper",
		JSON.stringify({
			wallpaper:
				"https://cdn.discordapp.com/attachments/954476483651461120/955120928453427271/screen-2.jpg",
		})
	);
});
$(".vierte").click(function () {
	$(".phonebackground").css(
		"background-image",
		"url( https://cdn.discordapp.com/attachments/954476483651461120/955120876024635494/screen-4.jpg )"
	);

	$.post(
		"http://SevenLife_Phone/wallpaper",
		JSON.stringify({
			wallpaper:
				"https://cdn.discordapp.com/attachments/954476483651461120/955120876024635494/screen-4.jpg",
		})
	);
});
$(".fünfte").click(function () {
	$(".phonebackground").css(
		"background-image",
		"url( https://cdn.discordapp.com/attachments/954476483651461120/955120783825444934/wp2550668.jpg )"
	);

	$.post(
		"http://SevenLife_Phone/wallpaper",
		JSON.stringify({
			wallpaper:
				"https://cdn.discordapp.com/attachments/954476483651461120/955120783825444934/wp2550668.jpg",
		})
	);
});
$(".hintergrundapp").on("click", ".submitbuttonsees", function () {
	var backgroundURL = document.getElementById("inputts").value;
	$(".phonebackground").css(
		"background-image",
		"url(" + backgroundURL + " )"
	);
	$.post(
		"http://SevenLife_Phone/wallpaper",
		JSON.stringify({ wallpaper: backgroundURL })
	);
});
$(".allgemein").click(function () {
	$(".einstellungsapp").hide();
	$(".allgeimeins").fadeIn(200);
});
$(".wlan").click(function () {
	$(".einstellungsapp").hide();
	$(".wlans").fadeIn(200);
});
$(".information").click(function () {
	$(".einstellungsapp").hide();
	$(".informations").fadeIn(200);
});

let toggle = document.querySelector(".toggle");
let toggle1 = document.querySelector(".toggle-kontakte");
let toggle2 = document.querySelector(".toggle-gps");
let toggle3 = document.querySelector(".toggle-wlan");
let toggle4 = document.querySelector(".toggle-push");
$(".toggle-button").click(function () {
	toggle.classList.toggle("active");
	if (toggle.classList.contains("active")) {
		$(".wifi").hide();
		$(".air").show();
		$.post(
			"http://SevenLife_Phone/flugmodus",
			JSON.stringify({ flugmodus: 2 })
		);
	} else {
		if (activewifi) {
			$(".wifi").show();
		}
		$(".air").hide();
		$.post(
			"http://SevenLife_Phone/flugmodus",
			JSON.stringify({ flugmodus: 1 })
		);
	}
});
$(".container-kontakte").click(function () {
	toggle1.classList.toggle("active");
	if (toggle1.classList.contains("active")) {
		$.post(
			"http://SevenLife_Phone/kontakte",
			JSON.stringify({ kontakte: 2 })
		);
	} else {
		$.post(
			"http://SevenLife_Phone/kontakte",
			JSON.stringify({ kontakte: 1 })
		);
	}
});

$(".container-gps").click(function () {
	toggle2.classList.toggle("active");
	if (toggle2.classList.contains("active")) {
		$(".gps").show();
		$.post("http://SevenLife_Phone/gps", JSON.stringify({ gps: 2 }));
	} else {
		$(".gps").hide();
		$.post("http://SevenLife_Phone/gps", JSON.stringify({ gps: 1 }));
	}
});
$(".container-push").click(function () {
	toggle4.classList.toggle("active");
	if (toggle4.classList.contains("active")) {
		$.post(
			"http://SevenLife_Phone/pushnachricht",
			JSON.stringify({ push: 2 })
		);
	} else {
		$.post(
			"http://SevenLife_Phone/pushnachricht",
			JSON.stringify({ push: 1 })
		);
	}
});
$(".container-wlan").click(function () {
	toggle3.classList.toggle("active");
	if (toggle3.classList.contains("active")) {
		$(".wifi").show();
		$.post("http://SevenLife_Phone/wifi", JSON.stringify({ wifi: 2 }));
	} else {
		$(".wifi").hide();
		$.post("http://SevenLife_Phone/wifi", JSON.stringify({ wifi: 1 }));
	}
});
$(".backallgemein ").click(function () {
	$(".allgeimeins").hide();
	$(".einstellungsapp").fadeIn(200);
});
$(".backwlan").click(function () {
	$(".wlans").hide();
	$(".einstellungsapp").fadeIn(200);
});
$(".backanzeige").click(function () {
	$(".anzeiges").hide();
	$(".einstellungsapp").fadeIn(200);
});
$(".anzeige").click(function () {
	$(".einstellungsapp").hide();
	$(".anzeiges").fadeIn(200);
});
$(".credit").click(function () {
	$(".einstellungsapp").hide();
	$(".credits").fadeIn(200);
});
$(".nachrichten").click(function () {
	$(".einstellungsapp").hide();
	$(".nachrichtens").fadeIn(200);
});

const slideValue = document.querySelector(".spannig");
const inputSlider = document.querySelector(".inputig");
const slideValues = document.querySelector(".spannige");
const inputSliders = document.querySelector(".inputige");
const slideValuese = document.querySelector(".spanniges");
const inputSliderse = document.querySelector(".inputiges");
const slideValueses = document.querySelector(".spannigese");
const inputSliderses = document.querySelector(".inputigese");

$(".anzeiges").on("click", ".submitbuttonseese", function () {
	inputSlider.oninput = () => {
		let value = inputSlider.value;
		slideValue.textContent = value;
	};
	$.post(
		"http://SevenLife_Phone/linksrechts",
		JSON.stringify({ linksrechts: slideValue.textContent })
	);

	let valuese = inputSlider.value;

	let result = parseInt(valuese) * 15;
	let customresult = parseInt(valuese) * 15 + 8;
	$(".handy-rahmen").css("left", `${result}px`);
	$(".phone-container").css("left", `${customresult}px`);
});
$(".anzeiges").on("click", ".submitbuttonseeses", function () {
	inputSliders.oninput = () => {
		let values = inputSliders.value;
		slideValues.textContent = values;
	};
	$.post(
		"http://SevenLife_Phone/obenunten",
		JSON.stringify({ obenunten: slideValues.textContent })
	);
	let valuese = inputSliders.value;

	let result = parseInt(valuese) * 3;
	let customresult = parseInt(valuese) * 3 + 18;
	$(".handy-rahmen").css("top", `${result}px`);
	$(".phone-container").css("top", `${customresult}px`);
});
$(".anzeiges").on("click", ".submitbuttonseesese", function () {
	inputSliderse.oninput = () => {
		let valuese = inputSliderse.value;
		slideValuese.textContent = valuese;
	};
	$.post(
		"http://SevenLife_Phone/gresse",
		JSON.stringify({ gresse: slideValuese.textContent })
	);

	let result = inputSliderse.value / 100;
	if (result > 0.49) {
		$(".handy-rahmen").css(
			"transform",
			"scale(" +
				inputSliderse.value / 100 +
				"," +
				inputSliderse.value / 100 +
				")"
		);

		$(".phone-container").css(
			"transform",
			"scale(" +
				inputSliderse.value / 100 +
				"," +
				inputSliderse.value / 100 +
				")"
		);
	}
});
$(".nachrichtens").on("click", ".submitbuttonseeseses", function () {
	inputSliderse.oninput = () => {
		let valuesee = inputSliderse.value;
		slideValuese.textContent = valuesee;
	};
});
$(".1sound").click(function () {
	$(".1check").show();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").hide();
});
$(".2sound").click(function () {
	$(".1check").hide();
	$(".2check").show();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").hide();
});
$(".3sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").show();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").hide();
});
$(".4sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").show();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").hide();
});
$(".5sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").show();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").hide();
});
$(".6sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").show();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").hide();
});
$(".7sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").show();
	$(".8check").hide();
	$(".9check").hide();
});
$(".8sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").show();
	$(".9check").hide();
});
$(".9sound").click(function () {
	$(".1check").hide();
	$(".2check").hide();
	$(".3check").hide();
	$(".4check").hide();
	$(".5check").hide();
	$(".6check").hide();
	$(".7check").hide();
	$(".8check").hide();
	$(".9check").show();
});
$(".call").click(function () {
	$(".phone-hauptseite").hide();
	$(".callapp").show();
	document.getElementsByClassName("telefon")[0].style.color = "green";
	document.getElementsByClassName("telefon")[0].style.borderBottom =
		"2px solid green";
});
$(".calloutunten").click(function () {
	$(".phone-hauptseite").show();
	$(".callapp").hide();
});
$("#1ziffer").click(function () {
	addOperation(1);
});
$("#2ziffer").click(function () {
	addOperation(2);
});
$("#3ziffer").click(function () {
	addOperation(3);
});
$("#4ziffer").click(function () {
	addOperation(4);
});
$("#5ziffer").click(function () {
	addOperation(5);
});
$("#6ziffer").click(function () {
	addOperation(6);
});
$("#7ziffer").click(function () {
	addOperation(7);
});
$("#8ziffer").click(function () {
	addOperation(8);
});
$("#9ziffer").click(function () {
	addOperation(9);
});
$("#0ziffer").click(function () {
	addOperation(0);
});
$("#outziffer").click(function () {
	addOperation("#");
});
$("#doutziffer").click(function () {
	addOperation("*");
});
$("#last").click(function () {
	let container = document.getElementById("nummer");
	container.innerHTML = container.innerHTML.slice(0, -1);
});
$("#bin").click(function () {
	let container = document.getElementById("nummer");
	container.innerHTML = container.innerHTML.slice(
		0,
		-10000000000000000000000000000000000000
	);
});
function addOperation(operration) {
	document.getElementById("nummer").innerHTML += operration;
}
$(".kontakte").click(function () {
	$(".phone-hauptseite").hide();
	$(".kontaktes").show();
	$.post("http://SevenLife_Phone/GetKontakte", JSON.stringify({}));
	document.getElementsByClassName("kontaktese")[0].style.color = "green";
	document.getElementsByClassName("kontaktese")[0].style.borderBottom =
		"2px solid green";
});

$(".chatapps").click(function () {
	$(".phone-hauptseite").hide();
	$(".chatapp").show();
	$(".scroll-chats").html(" ");
	$.post("http://SevenLife_Phone/GetChats", JSON.stringify({}));
});
$(".kontakteses").click(function () {
	$(".callapp").hide();
	$(".kontaktes").show();
	$(".letztese").hide();
	$.post("http://SevenLife_Phone/GetKontakte", JSON.stringify({}));
	document.getElementsByClassName("kontaktese")[0].style.color = "green";
	document.getElementsByClassName("kontaktese")[0].style.borderBottom =
		"2px solid green";
});
$(".calloutuntens").click(function () {
	$(".phone-hauptseite").show();
	$(".kontaktes").hide();
});
$(".telefon").click(function () {
	$(".kontaktes").hide();
	$(".callapp").show();
	$(".letztese").hide();
	document.getElementsByClassName("telefon")[0].style.color = "green";
	document.getElementsByClassName("telefon")[0].style.borderBottom =
		"2px solid green";
});
$(".letzte").click(function () {
	$(".kontaktes").hide();
	$(".callapp").hide();
	$(".letztese").show();
	document.getElementsByClassName("letztes")[0].style.color = "green";
	document.getElementsByClassName("letztes")[0].style.borderBottom =
		"2px solid green";
});
$(".calloutuntense").click(function () {
	$(".phone-hauptseite").show();
	$(".letztese").hide();
});
$(".lifeinvader").click(function () {
	$(".phone-hauptseite").hide();
	$.post("http://SevenLife_Phone/getlifeinvaderwerbung", JSON.stringify({}));
	$(".Lifeinvader").show();
});
$(".logoaccount").click(function () {
	$.post(
		"http://SevenLife_Phone/haveplayeranlifeinvaderaccount",
		JSON.stringify({})
	);
});
$(".submitbuttonseesesess").click(function () {
	$(".normaleleiste").fadeIn(200);
	$(".anmeldeleiste").hide();
	var $icon = document.getElementById("icon").value;
	var $benutzer = document.getElementById("benutzer").value;
	var $passwort = document.getElementById("passwort").value;
	$.post(
		"http://SevenLife_Phone/lifeinvaderaccountcreate",
		JSON.stringify({
			icon: $icon,
			benutzer: $benutzer,
			passwort: $passwort,
		})
	);
});
$(".backs").click(function () {
	$(".normaleleiste").fadeIn(200);
	$(".anmeldeleiste").hide();
});
$(".calloutuntensess").click(function () {
	$(".phone-hauptseite").show();
	$(".cryptos").hide();
});
$(".calloutuntenses").click(function () {
	$(".phone-hauptseite").show();
	$(".Lifeinvader").hide();
});
$("#submit-btns").click(function () {
	$(".firstsseite").show();
	$(".top-liveinvader").hide();
	$(".werbungschalten").hide();
});
$("#submit-btne").click(function () {
	$(".firstsseite").hide();
	$(".top-liveinvader").show();
	$(".werbungschalten").hide();
});
$("#submit-btnd").click(function () {
	$(".werbungschalten").show();
	$(".firstsseite").hide();
	$(".top-liveinvader").hide();
});
function displaywerbung(werbung) {
	$(".firstseite").html("");
	$(".liveinvadertop").html("");
	$.each(werbung, function (index, werbung) {
		if (werbung.premiumornot === 1) {
			$(".firstseite").prepend(
				`
                <div class="normalewerbung">
                <h1 class="titelwerbung">
                   ${werbung.titel}
                </h1>
                <span class="nachrichtwerbung">
                     ${werbung.nachricht}
                </span>
                <h2 class="nachrichtensender">
                    Geschaltet von ${werbung.benutzername}
                </h2>
                </div>
                `
			);
		} else if (werbung.premiumornot === 2) {
			$(".liveinvadertop").prepend(
				`
                <div class="normalewerbung">
                <h1 class="titelwerbung">
                   ${werbung.titel}
                </h1>
                <span class="nachrichtwerbung">
                     ${werbung.nachricht}
                </span>
                <h2 class="nachrichtensender">
                   Premium Werbung von ${werbung.benutzername}
                </h2>
                </div>
                `
			);
		}
	});
}
var statuse = 1;

$("#eoffentlich").click(function () {
	statuse = 1;
});
$("#anonym").click(function () {
	statuse = 2;
});

$(".submitbuttonseesesesse").click(function () {
	var $nachricht = document.getElementById("inputtwasdses").value;
	var $titel = document.getElementById("inputtwasdsese").value;
	$.post(
		"http://SevenLife_Phone/sendnachricht",
		JSON.stringify({
			inachrichtcon: $nachricht,
			status: statuse,
			titel: $titel,
		})
	);
	document.getElementById("inputtwasdses").value = "";
	document.getElementById("inputtwasdsese").value = "";
	$(".phone-hauptseite").show();
	$(".Lifeinvader").hide();
});

// Bank

$(".bank").click(function () {
	$.post("http://SevenLife_Phone/GetPhoneBankData", JSON.stringify({}));
});
$(".baruntens").click(function () {
	$(".phone-hauptseite").show();
	$(".bankapp").hide();
});
$(".bankapp").on("click", ".submit-ueberweisung", function () {
	$(".phone-hauptseite").show();
	$(".bankapp").hide();
	var anzahl = document.getElementById("geldanzahl").value;
	var iban = document.getElementById("iban").value;
	$.post(
		"http://SevenLife_Phone/transfer",
		JSON.stringify({ anzahl: anzahl, iban: iban })
	);
	document.getElementById("geldanzahl").value = "";
	document.getElementById("iban").value = "";
});

// Bill
$(".bill").click(function () {
	$.post("http://SevenLife_Phone/GetBilldata", JSON.stringify({}));
	$(".phone-hauptseite").hide();
	$(".bill-app").show();
});

function MakeBills(items) {
	$(".untenbills").html("");
	$.each(items, function (index, item) {
		if (item.stand === "paid") {
			paid++;
			document.getElementById("paidnummber").innerHTML = paid;
		} else if (item.stand === "notpaid") {
			notpaid++;
			document.getElementById("notpaid").innerHTML = notpaid;
			$(".untenbills").append(
				`
            <div class="container-bill-app" name = ${item.id} type = ${item.stand}>
            <img src="../src/appsymbols/bill.png" class="imgscript" alt="">
            <h1 class="resoun-bill ">
                ${item.title}
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
		} else if (item.stand === "overdue") {
			overdue++;
			document.getElementById("overdue").innerHTML = overdue;
			$(".untenbills").append(
				`
            <div class="container-bill-app" name = ${item.id} type = ${item.stand}>
            <img src="../src/appsymbols/bill.png" class="imgscript" alt="">
            <h1 class="resoun-bill ">
                ${item.title}
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
		}
	});
}

$(".bardown").click(function () {
	$(".phone-hauptseite").show();
	$(".bill-app").hide();
});

$(".bill-app").on("click", ".container-bill-app", function () {
	var $button = $(this);
	$button.hide("slow");
	var $stand = $button.attr("type");
	if ($stand == "notpaid") {
		notpaid = parseInt(notpaid) - 1;
	} else if ($stand == "overdue") {
		overdue = parseInt(overdue) - 1;
	}

	if (notpaid < 0) {
		notpaid = 0;
	}
	if (overdue < 0) {
		overdue = 0;
	}
	document.getElementById("notpaid").innerHTML = notpaid;
	document.getElementById("overdue").innerHTML = overdue;
	var $id = $button.attr("name");
	$.post("http://SevenLife_Phone/PayBillID", JSON.stringify({ id: $id }));
});

$(".callapp").on("click", "#calls", function () {
	$(".callapp").hide();
	$(".seitecall").show();
	var $button = $(this);

	var $number = document.getElementById("nummer").value;
	$.post(
		"http://SevenLife_Phone/MakeAnfruf",
		JSON.stringify({ number: $number })
	);
});
// 7Drop
$(".dropair").click(function () {
	var $number = document.getElementById("nummers").getAttribute("number");

	$.post(
		"https://SevenLife_Phone/MakeSevenDrop",
		JSON.stringify({ number: $number })
	);
});

// Einspeichern
$(".add").click(function () {
	document.getElementById("removeeinspeichern").style.animation =
		"fadeInRight 1s ";
	document
		.getElementById("removeeinspeichern")
		.style.removeProperty("display");
});

$(".backtomain").click(function () {
	document.getElementById("removeeinspeichern").style.animation =
		"fadeOutRight 1s  ";
	setTimeout(function () {
		document.getElementById("removeeinspeichern").style.display = "none";
		document.getElementById("removeeinspeichern").style.animation = "";
	}, 900);
});
$(".profilbildcall").click(function () {
	document
		.getElementById("container-talephoto")
		.style.removeProperty("display");
});

$(".garage").click(function () {
	document.getElementById("appgarage").style.removeProperty("display");

	document.getElementById("firstsitecar").style.removeProperty("display");
	document.getElementById("appgarage").style.animation = "fadeInBottom 1s ";
	$.post("http://SevenLife_Phone/GetCarsAndLocation", JSON.stringify({}));

	setTimeout(function () {
		document.getElementById("firstsitecar").style.animation = "fadeOut 1s";
	}, 3000);

	setTimeout(function () {
		document.getElementById("firstsitecar").style.display = "none";
		document.getElementById("firstsitecar").style.animation = "none";
		document.getElementById("secondsite").style.removeProperty("display");
	}, 3300);
});

$(".baruntencar").click(function () {
	document.getElementById("appgarage").style.animation = "fadeOutBottom 1s ";
	setTimeout(function () {
		document.getElementById("appgarage").style.display = "none";
		document.getElementById("secondsite").style.display = "none";
		document.getElementById("appgarage").style.animation = " ";
	}, 900);
	$(".scroller").html(" ");
});

$(".appgarage").on("click", ".park", function () {
	var $button = $(this);
	var $garage = $button.attr("garage");

	$.post(
		"http://SevenLife_Phone/GarageMakeRoute",
		JSON.stringify({ garage: $garage })
	);
});

function makeGarage(garage, fuel, name) {
	$(".scroller").append(
		`
			<div class="container-car">
								<h1 class="autotext">${name}</h1>
								<img
									src="../src/tools/outline_local_parking_white_24dp.png"
									alt=""
									class="park"
									garage= ${garage}
								/>
								<div class="strichuntenname"></div>
								<h1 class="garages">Garage: ${garage}</h1>
								<img
									src="../src/tools/outline_local_gas_station_white_24dp.png"
									alt=""
									class="gasstation"
								/>
				<h1 class="liter">${fuel}L</h1>
			</div>
         `
	);
}

$(".backtomainzwei").click(function () {
	document.getElementById("container-talephoto").style.display = "none";
});
$(".einspeichern").on("click", ".SubmitNummer", function () {
	var $button = $(this);
	var $name = document.getElementById("nameeinste").value;
	var $nummer = document.getElementById("telefonnummer").value;
	var $bio = document.getElementById("Inputtfieldall").value;
	var $url = document.getElementById("inputturl").value;
	$(".callapp").hide();
	$(".phone-hauptseite").show();
	$(".einspeichern").hide();
	$(".kontaktes").hide();
	$.post(
		"http://SevenLife_Phone/MakeContakt",
		JSON.stringify({ name: $name, nummer: $nummer, bio: $bio, url: $url })
	);
});

$(".SubmitURL").click(function () {
	$(".container-talephoto").hide();
});

function MakeApps(items) {
	$(".container-appdownload").html("");
	$.each(items, function (index, item) {
		$(".container-appdownload").append(
			`
			<div class="container-appcontainerdownload">
			    <h1 class="twitter-container-text">
				   ${item.name}
			    </h1>
			    <img
				   src="../src/appsymbols/${item.name}.png"
				   class="logo-container-app"
				   alt=""
			    />
			    <div class="container-downloadbutton" name = "${item.name}">
				  <img
					src="../src/tools/baseline_download_done_white_48dp.png"
					class="download-img"
					alt=""
				   />
			    </div>
			    <img
				   src="../src/tools/outline_sync_white_48dp.png"
				   alt=""
				    class="sync"
			    />
		    </div>
			`
		);
	});
}
function MakeDownloadedApps(items) {
	$(".container-appdownload2").html("");
	$.each(items, function (index, item) {
		if (item.name !== "appstore") {
			$(".container-appdownload2").append(
				`
				<div class="container-appcontainerdownload2">
				<h1 class="twitter-container-text1">
				${item.name}
				</h1>
				<img
					src="../src/appsymbols/${item.name}.png"
					class="logo-container-app1"
					alt=""
				/>
				<div class="container-downloadbutton1" name = "${item.name}">
					<img
						src="../src/tools/outline_clear_white_48dp.png"
						class="download-img1"
						alt=""
					/>
				</div>
				<img
					src="../src/tools/outline_sync_white_48dp.png"
					alt=""
					class="sync"
				/>
			</div>
			`
			);
		}
	});
}
function MakeDipatches(items) {
	$(".scroll-dispatch").html("");
	$.each(items, function (index, item) {
		$(".scroll-dispatch").prepend(
			`
				<div class="container-dispatchstatus">
					<div class="box-container-info">
						<img
						src="../src/tools/info.png"
						class="infozeichen"
						alt=""
						/>
					</div>
					<h1 class="text-dispach">${item.titel}</h1>
					<h1 class="infotextdispatch">
					    ${item.description}
					</h1>
					<h1 class="statustext2">${item.anngenommen}</h1>
					<h1 class="InfoFraktion">${item.fraktion}</h1>
				</div>
			`
		);
	});
}
function searchanimApps() {
	$(".hauptseitenhaupt").hide();
	$(".allappsdownload").show();
	$(".installedapps").hide();
	$(".container-appcontainerdownload").hide();
	let input = document.getElementById("inputts-searchapp").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName(
		"container-appcontainerdownload"
	);

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".twitter-container-text")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
$(".phonecontainer").on("click", ".message-container", function () {
	var $box = $(this);
	$box.hide("slow");
});

$(".notizen").click(function () {
	$(".phone-hauptseite").hide();
	$.post("http://SevenLife_Phone/GetNotizen", JSON.stringify({}));
});

function MakeNotizen(items) {
	$(".container-notizen").html("");
	$.each(items, function (index, item) {
		$(".container-notizen").prepend(
			`
			<div class="container-notizen-root">
			<div class="container-notizen-root-oben">
				<input
					class="inputttitel-notizen"
					maxlength="20"
					value="${item.titel}"
					id="inputttitel-notizen"
					placeholder="Titel"	
					
					name = "${item.id}"
				/>
				<textarea
					maxlength="700"
					autofocus
					id="inputt-beschreibung"
					class="inputt-beschreibung"
					
					name = "${item.id}"
					
					placeholder="Beschreibung deiner Notiz"
				>${item.beschreibung}</textarea>
				<img
					src="../src/tools/bin.png"
					class="binnotizen"
					name = "${item.id}"
					alt=""
				/>
				<img
										src="../src/tools/outline_save_white_48dp.png"
										class="savenotizen"
										alt=""
										name = "${item.id}"
									/>
			</div>
		</div>
			`
		);
	});
}
$(".phonecontainer").on("click", ".binnotizen", function () {
	var $box = $(this);
	var id = $box.attr("name");
	$box.parent().parent().hide("slow");
	$.post("http://SevenLife_Phone/DeletNotizen", JSON.stringify({ id: id }));
});
$(".phonecontainer").on("click", ".toolsaddnotizen", function () {
	var $box = $(this);
	$.post("http://SevenLife_Phone/NewNotiz", JSON.stringify({}));
});
$(".notizenappunten").click(function () {
	$(".notizenapp").hide();
	$(".phone-hauptseite").show();
});
$(".phonecontainer").on("click", ".savenotizen", function () {
	var $box = $(this);
	var id = $box.attr("name");
	var titel = $box.parent().find(".inputttitel-notizen").val();
	var beschreibung = $box.parent().find(".inputt-beschreibung").val();
	$.post(
		"http://SevenLife_Phone/SaveList",
		JSON.stringify({ id: id, titel: titel, beschreibung: beschreibung })
	);
});
$(".photo").click(function () {
	$(".phone-hauptseite").hide();
	$(".cameraapp").show();
	const canvas = document.getElementById("camerabild2");

	MainRender.renderToTarget(canvas);
});
$(".cameraappraus").click(function () {
	$(".cameraapp").hide();
	$(".phone-hauptseite").show();
});
$(".photo_flip").click(function () {
	$(".cameraapp").hide();
	$(".galerieapp").show();
	$.post("http://SevenLife_Phone/GalerieOpen", JSON.stringify({}));
});
$(".photo_lightbulp").click(function () {
	$.post("http://SevenLife_Phone/MakeLight", JSON.stringify({}));
});
$(".circle_takepicture").click(function () {
	activehandy = false;

	$.post("http://SevenLife_Phone/TakePhoto", JSON.stringify({}));
});
$(".galerieappraus").click(function () {
	$(".galerieapp").hide();
	$(".phone-hauptseite").show();
});

function InsertDataGalerie(items) {
	$(".scrollcontainergalerie").html("");
	$.each(items, function (index, item) {
		$(".scrollcontainergalerie").prepend(
			`
			<div class="picturesquere" src="${item.image}"
			datum = "${item.date}">
		    	<img
			        src="${item.image}"
					datum = "${item.date}"
				    class="img-pictue"
			    />
		    </div>
			`
		);
	});
}

$(".galerie").click(function () {
	$(".galerieapp").show();
	$(".phone-hauptseite").hide();
	$.post("http://SevenLife_Phone/GalerieOpen", JSON.stringify({}));
});
$(".galerieapp").on("click", ".picturesquere", function () {
	var $box = $(this);
	var src = $box.attr("src");
	var datum = $box.attr("datum");

	$.post(
		"http://SevenLife_Phone/MakeItBigger",
		JSON.stringify({ datum: datum, src: src })
	);
});

$(".information-back").click(function () {
	$(".größerpage").hide();
});

$(".galerieapp").on("click", ".container-löschen", function () {
	var $box = $(this);
	var src = $box.attr("src");
	$(".größerpage").hide();
	$.post("http://SevenLife_Phone/DeleteIMG", JSON.stringify({ src: src }));
});
$(".galerieapp").on("click", ".container-teilen", function () {
	var $box = $(this);
	var src = $box.attr("src");

	$.post("http://SevenLife_Phone/SevenDropIMG", JSON.stringify({ src: src }));
});

$(".phonecontainer").on("click", ".container-ablehenen", function () {
	var $box = $(this);
	$(".sevendrop-image").html(" ");
});

$(".sevendrop-image").on("click", ".container-annehmen", function () {
	var $box = $(this);
	var src = $box.attr("src");

	$.post("http://SevenLife_Phone/InsertIMG", JSON.stringify({ src: src }));
	$(".sevendrop-image").html(" ");
});

$(".sevendrop-kontakte").on("click", ".container-annehmen1", function () {
	var $box = $(this);
	var nummer = $box.attr("nummer");
	var name = $box.attr("name");

	$.post(
		"http://SevenLife_Phone/InsertKontakt",
		JSON.stringify({ nummer: nummer, name: name })
	);
	$(".sevendrop-image").html(" ");
});
function InsertContacts(items) {
	$(".vipcontainerall").html("");
	$(".kontakteall").html("");
	var vipnumber = 0;
	var kontaktenumber = 0;
	$.each(items, function (index, item) {
		if (item.premiumornot === "true") {
			vipnumber = vipnumber + 1;
			$(".vipcontainerall").prepend(
				`
				<div class="vipkasten" nummer = ${item.number}>
				<div class="vipcontainer">
					<img
						src="../src/appsymbols/contacts1.png"
						class="contactbild"
						alt=""
					/>
					<h2 class="vipkontakttext">${item.name}</h2>
				</div>
			</div>
			`
			);
		} else {
			kontaktenumber = kontaktenumber + 1;
			$(".kontakteall").prepend(
				`
				<div class="kontaktcontainer" nummer = ${item.number}>
				<img
					src="../src/appsymbols/contacts1.png"
					class="contactbild"
					alt=""
				/>
				<h2
					class="kontaktname"
					id="kontaktname"
				>
				   ${item.name}
				</h2>
			    </div>
			`
			);
		}
	});
	document.getElementById("vipanzahl").innerHTML = vipnumber;
	document.getElementById("kontaktanzahl").innerHTML = kontaktenumber;
}
$(".containerauswahl").on("click", ".auswahl1", function () {
	var element = document.getElementById("auswahl1");
	var elementrest = document.getElementById("auswahl2");

	element.classList.add("active");
	$(".chatseite").show("fast");
	$(".statusseite").hide();
	elementrest.classList.remove("active");
});
$(".containerauswahl").on("click", ".auswahl2", function () {
	var element = document.getElementById("auswahl2");
	var elementrest = document.getElementById("auswahl1");

	element.classList.add("active");
	elementrest.classList.remove("active");

	$(".chatseite").hide();
	$(".statusseite").show("fast");
	$.post("http://SevenLife_Phone/GetDataForStory", JSON.stringify({}));
});

$(".chatappraus").click(function () {
	$(".chatapp").hide();
	$(".phone-hauptseite").show();
	$(".statusseite").hide();
});
$(".funkappraus").click(function () {
	$(".phone-hauptseite").show();
	$(".funkapp").hide();
});
$(".backtofrontchat").click(function () {
	$(".Addchat").hide();
	$(".chatseite").show();
});
$(".addcontact").click(function () {
	$(".chatseite").hide();
	$(".Addchat").show();
	$(".addkontektescoll").html(" ");
	$.post("http://SevenLife_Phone/GetKontakteForAdd", JSON.stringify({}));
});
function InsertChatKontakte(items) {
	$.each(items, function (index, item) {
		if (
			!item.profilbild ||
			item.profilbild === "" ||
			item.profilbild === " "
		) {
			$(".addkontektescoll").prepend(
				`
				<div class="container-chat-scroll addkontakt" id= "${item.id}">
								<div class="profilbild">
								<img
								src="../src/tools/13547334191038217.png"
								class="imgprofil"
								alt=""
							/>
								</div>
								<h1 class="eingespeichertername">
									${item.name}
								</h1>
								<h1 class="letztenachricht">
									Hey there! I'm playing on SevenLife RP
								</h1>
							</div>
			`
			);
		} else {
			$(".addkontektescoll").prepend(
				`
				<div class="container-chat-scroll addkontakt" id= "${item.id}" >
								<div class="profilbild">
									<img
										src="${item.profilbild}"
										class="imgprofil"
										alt=""
									/> 
								</div>
								<h1 class="eingespeichertername">
								   ${item.name}
								</h1>
								<h1 class="letztenachricht">
									Hey there! I'm playing on SevenLife RP
								</h1>
							</div>
			`
			);
		}
	});
}
$(".addkontektescoll").on("click", ".addkontakt", function () {
	var button = $(this);
	var id = button.attr("id");
	$.post("http://SevenLife_Phone/InsertNewChat", JSON.stringify({ id: id }));
});

function InsertChat(items, identifier) {
	$(".container-scroll-nachrichten").html(" ");

	$.each(items, function (index, item) {
		if (item.firstnachricht === 1 || item.firstnachricht === "1") {
			$(".container-scroll-nachrichten").prepend(
				`
				<div class="startnachricht">
					<h1 class="starttextchat">
						${item.message}
					</h1>
				</div>
			`
			);
		} else {
			if (item.types === undefined) {
				if (item.identifier === identifier) {
					$(".container-scroll-nachrichten").append(
						`
						<div class="meinenachricht">
							<div class="nachrichtchat">
								${item.message}
							</div>
						</div>
					`
					);
				} else {
					$(".container-scroll-nachrichten").append(
						`
						<div class="seinenachricht">
							<div class="nachrichtchat">
								${item.message}
							</div>
						</div>
					`
					);
				}
			} else if (item.types === "1") {
				if (item.identifier === identifier) {
					$(".container-scroll-nachrichten").append(
						`
						<div class="meinenachrichtimg">
						<img src="${item.message}" class="imginnen" alt="">
					</div>
				`
					);
				} else {
					$(".container-scroll-nachrichten").append(
						`
						<div class="seinenachrichtimg">
								<img src="${item.message}" class="imginnen" alt="">
							</div>
			
					
				`
					);
				}
			}
		}
	});
}

$(".inputt-chat").on("keyup", function (e) {
	if (e.key === "Enter" || e.keyCode === 13) {
		var chat = document.querySelector(".inputt-chat").value;
		var id = document.querySelector(".inputt-chat").getAttribute("id");
		document.querySelector(".inputt-chat").value = "";
		$.post(
			"http://SevenLife_Phone/InsertNewNachricht",
			JSON.stringify({ id: id, chat: chat })
		);
	}
});
$(".gobackfromchat").click(function () {
	$(".schreibenseite").hide();
	$(".containerübersichtoben").show();
	$(".chatseite").show();
});
function InsertChatsIntoList(items) {
	$(".scroll-chats").html(" ");

	$.each(items, function (index, item) {
		if (item.profilbild !== undefined) {
			$(".scroll-chats").prepend(
				`
			<div class="container-chat-scroll openchat" id = "${item.idchat}">
			    <div class="profilbild">
				    <img
					    src="../src/tools/13547334191038217.png"
					    class="imgprofil"
					    alt=""
			  	    />
			    </div>
			    <h1 class="eingespeichertername">
				     ${item.name}
			    </h1>
			    <h1 class="letztenachricht">
				    Hey Chrisi, wie gehts dir? Lange nichts mehr
			     	von dir gehört!
			    </h1>
		    </div>
				`
			);
		} else {
			$(".scroll-chats").prepend(
				`
			<div class="container-chat-scroll openchat" id = "${item.idchat}">
			    <div class="profilbild">
				    <img
					    src="${item.profilbild}"
					    class="imgprofil"
					    alt=""
			  	    />
			    </div>
			    <h1 class="eingespeichertername">
				     ${item.name}
			    </h1>
			    <h1 class="letztenachricht">
				    Hey Chrisi, wie gehts dir? Lange nichts mehr
			     	von dir gehört!
			    </h1>
		    </div>
				`
			);
		}
	});
}
$(".scroll-chats").on("click", ".openchat", function () {
	var button = $(this);
	var id = button.attr("id");
	$.post("http://SevenLife_Phone/OpenChat", JSON.stringify({ id: id }));
});
var debounce;
$(document).ready(function () {
	$(".micinit").mouseenter(function () {
		$(".moredetails").slideDown("fast");
		clearTimeout(debounce);
	});

	$(".moredetails, .micinit").mouseleave(function () {
		debounce = setTimeout(closeMenu, 1000);
	});
});

var closeMenu = function () {
	$(".moredetails").slideUp("fast");
	clearTimeout(debounce);
};
var activemarker = false;
var lastbutton;
var url = "";
$(".chatapp").on("click", ".picturesquere2", function () {
	var button = $(this);
	const conntent = `
	<div class="hackenblue">
		<img
			src="../src/tools/outline_done_white_48dp.png"
			class="acceptimage"
			alt=""
			/>
		</div>
	`;

	if (lastbutton !== button) {
		if (activemarker === false) {
			activemarker = true;
			lastbutton = button;
			url = button.attr("url");
			button.append(conntent);
		} else {
			activemarker = true;
			$(".hackenblue").hide();
			lastbutton = button;
			url = button.attr("url");
			button.append(conntent);
		}
	} else {
		if (activemarker === false) {
			activemarker = true;
			lastbutton = button;
			url = button.attr("url");
			button.append(conntent);
		} else {
			activemarker = false;

			lastbutton = button;
			$(".hackenblue").hide();
		}
	}
});

$(".backtochat").click(function () {
	$(".schreibenseite").show();
	$(".imgauswahl").hide("fast");
});
$(".backtochat2").click(function () {
	$(".statusseite").show();
	$(".containerübersichtoben").show();
	$(".imgauswahl2").hide("fast");
});
$(".acceptimagessend").click(function () {
	if (url !== "") {
		$(".imgauswahl").hide("fast");
		$(".schreibenseite").show();
		var id = document.querySelector(".makephoto").getAttribute("id");
		$.post(
			"http://SevenLife_Phone/SendImage",
			JSON.stringify({ url: url, id: id })
		);
	}
});
$(".makephoto").click(function () {
	$(".schreibenseite").hide();
	$(".imgauswahl").show();
	$.post("http://SevenLife_Phone/InsertImages", JSON.stringify({}));
});
function InsertAll(items) {
	$(".scrollcontainergalerie2").html("");
	$.each(items, function (index, item) {
		$(".scrollcontainergalerie2").prepend(
			`
			<div class="picturesquere2" url ="${item.image}">
									<img
									src="${item.image}"
									datum = "${item.date}"
								
										class="img-pictue2"
									/>
								</div>
			`
		);
	});
}
function InsertAll2(items) {
	$(".scrollcontainergalerie3").html("");
	$.each(items, function (index, item) {
		$(".scrollcontainergalerie3").prepend(
			`
			<div class="picturesquere2" url ="${item.image}">
									<img
									src="${item.image}"
									datum = "${item.date}"
								
										class="img-pictue2"
									/>
								</div>
			`
		);
	});
}

const scrollToBottom = (id) => {
	const element = document.getElementById(id);
	element.scrollTop = element.scrollHeight;
};
var activesearch = false;
$(".searchplayer").click(function () {
	if (activesearch == false) {
		activesearch = true;
		$(".containerauswahl").hide();
		$(".textsearch").show("fast");
	} else {
		activesearch = false;
		$(".containerauswahl").show("fast");
		$(".textsearch").hide();
	}
});

function searchanimasauslager() {
	console.log("hey");
	$(".container-chat-scroll").hide();
	let input = document.getElementById("textsearch").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("openchat");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".eingespeichertername")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}

function InsertStorys(items, src) {
	$(".scroll-status").html("");

	$.each(items, function (index, item) {
		var data = formatDate(item.currentime);
		$(".scroll-status").prepend(
			`
			<div class="containerownstory2" src = "${item.img}">
			    <div class="container-addstatusfremder">
				    <img src="${item.img}" class="imgspieler" alt="">
		    	</div>
			    <h1 class="nameofmyself">${item.name}</h1>
			    <h1 class="infotextstory">${data}</h1>
	        </div>
			`
		);
	});
}
function formatDate(value) {
	if (value) {
		Number.prototype.padLeft = function (base, chr) {
			var len = String(base || 10).length - String(this).length + 1;
			return len > 0 ? new Array(len).join(chr || "0") + this : this;
		};
		var d = new Date(value),
			dformat =
				[
					(d.getMonth() + 1).padLeft(),
					d.getDate().padLeft(),
					d.getFullYear(),
				].join("/") +
				" " +
				[
					d.getHours().padLeft(),
					d.getMinutes().padLeft(),
					d.getSeconds().padLeft(),
				].join(":");
		return dformat;
	}
}
$(".acceptimagessend2").click(function () {
	if (url !== "") {
		$(".imgauswahl2").hide("fast");
		$(".containerübersichtoben").show();
		$(".statusseite").show();

		var id = document.querySelector(".makephoto").getAttribute("id");
		$.post(
			"http://SevenLife_Phone/SendImageIntoStory",
			JSON.stringify({ url: url, id: id })
		);
	}
});
$(".containerownstory").click(function () {
	$(".statusseite").hide();
	$(".imgauswahl2").show();
	$(".containerübersichtoben").hide();

	$.post("http://SevenLife_Phone/GetPhotosForApp", JSON.stringify({}));
});
$(".chatapp").on("click", ".containerownstory2", function () {
	var button = $(this);
	var src = button.attr("src");
	$.post("http://SevenLife_Phone/OpenStatus", JSON.stringify({ src: src }));
});
$(".videocall").click(function () {
	var button = $(this);
	var nummer = button.attr("nummer");
	$.post(
		"http://SevenLife_Phone/StartCall",
		JSON.stringify({ nummer: nummer })
	);
});
$(".großkreismittecall2").click(function () {
	MainRender.stop();
	$(".VideoCallStarter").hide();
	$.post("http://SevenLife_Phone/StopCall", JSON.stringify({}));
});
$(".closevideo").click(function () {
	MainRender.stop();
	$.post("http://SevenLife_Phone/StopVideo", JSON.stringify({}));
});
$(".mutecall").click(function () {});

$(".sumbmitfunk").click(function () {
	var radioid = document.getElementById("inputt-funkid").value;
	$.post(
		"http://SevenLife_Phone/JoinFunk",
		JSON.stringify({ radioid: radioid })
	);
});
function UpdateChannel(items) {
	$(".container-history").html("");

	$.each(items, function (index, item) {
		var data = formatDate(item.currentime);
		$(".container-history").prepend(
			`
			<div class="container-historyzusammengefasst" id = "${item.funkid}">
			<h1 class="funknachricht">Funk Kanal: ${item.funkid}</h1>
			<h1 class="textwann">${data}</h1>
		</div>
		`
		);
	});
}
$(".funkapps").click(function () {
	$(".funkapp").show();
	$(".phone-hauptseite").hide();
	$.post("http://SevenLife_Phone/GetDataForRadio", JSON.stringify({}));
});
$(".container-histor").on(
	"click",
	".container-historyzusammengefasst",
	function () {
		var button = $(this);
		var id = button.attr("id");
		$.post(
			"http://SevenLife_Phone/JoinFunk",
			JSON.stringify({ radioid: radioid })
		);
	}
);
$(".businessappraus").click(function () {
	$(".phone-hauptseite").show();
	$(".businnessapp").hide();
});

$(".businessapp").click(function () {
	$.post(
		"http://SevenLife_Phone/GetIfPlayerIsInBusiness",
		JSON.stringify({})
	);
});

$(".logoutbusiness").click(function () {
	var button = $(this);
	var id = button.attr("ids");
	CloseBusinessApp();
	$.post(
		"http://SevenLife_Phone/RemovePlayerFromBusiness",
		JSON.stringify({ id: id })
	);
});
function CloseBusinessApp() {
	$(".businnessapp").hide();
	$(".businessmainpage").hide();
	$(".businesscode").hide();
	$(".phone-hauptseite").show();
	$(".container-mitglieder").hide();
	$(".container-chatbusinnes").hide();
}
$(".container-mitglieder").on("click", ".deletefromchat", function () {
	var button = $(this);
	var id = button.attr("ids");
	CloseBusinessApp();
	$.post(
		"http://SevenLife_Phone/RemovePlayerFromBusiness",
		JSON.stringify({ id: id })
	);
});
function MakeMitglieder(infos, yourselfadmin) {
	$(".mitglieder-scroll").html(" ");
	if (yourselfadmin) {
		$.each(infos, function (index, item) {
			if (parseInt(item.admin) !== 1) {
				$(".mitglieder-scroll").prepend(
					`
				<div class="container-mitgliederinsight">
				<img
					src="../src/tools/baseline_admin_panel_settings_white_48dp.png"
					class="seeifadmin"
					alt=""
				/>
				<h1 class="nameofinsgith">
					${item.name}
				</h1>
				<h1 class="nummerofinsight">
				    ${item.nummer}
				</h1>
				<img
				src="../src/tools/baseline_exit_to_app_white_48dp.png"
				class="deletefromchat"
				ids = "${item.id}"
				alt=""
			/>
			</div>
			`
				);
			} else {
				$(".mitglieder-scroll").append(
					`
				<div class="container-mitgliederinsight">
				<img
					src="../src/tools/baseline_person_white_48dp.png"
					class="seeifadmin"
					alt=""
				/>
				<h1 class="nameofinsgith">
				${item.name}
				</h1>
				<h1 class="nummerofinsight">
				${item.nummer}
				</h1>
				<img
				src="../src/tools/baseline_exit_to_app_white_48dp.png"
				class="deletefromchat"
				ids = "${item.id}"
				alt=""
			/>
			</div>
			`
				);
			}
		});
	} else {
		$.each(infos, function (index, item) {
			if (parseInt(item.admin) !== 1) {
				$(".mitglieder-scroll").prepend(
					`
			<div class="container-mitgliederinsight">
			<img
				src="../src/tools/baseline_admin_panel_settings_white_48dp.png"
				class="seeifadmin"
				alt=""
			/>
			<h1 class="nameofinsgith">
				${item.name}
			</h1>
			<h1 class="nummerofinsight">
				${item.nummer}
			</h1>
		</div>
		`
				);
			} else {
				$(".mitglieder-scroll").append(
					`
			<div class="container-mitgliederinsight">
			<img
				src="../src/tools/baseline_person_white_48dp.png"
				class="seeifadmin"
				alt=""
			/>
			<h1 class="nameofinsgith">
			${item.name}
			</h1>
			<h1 class="nummerofinsight">
			${item.nummer}
			</h1>
		</div>
		`
				);
			}
		});
	}
}

$(".submitbusiness").click(function () {
	var id = document.getElementById("inputt-business").value;
	$.post(
		"http://SevenLife_Phone/InsertPlayerIntoBusiness",
		JSON.stringify({ id: id })
	);
});

$(".leftsidebusiness").click(function () {
	var button = $(this);
	var id = button.attr("ids");
	$(".textmitglieder2").removeClass("activebusiness");
	$(".textmitglieder").addClass("activebusiness");
	$.post("http://SevenLife_Phone/AskForUpdate", JSON.stringify({ id: id }));
});
$(".rightsidebusiness").click(function () {
	var button = $(this);
	var id = button.attr("ids");
	$(".textmitglieder").removeClass("activebusiness");
	$(".textmitglieder2").addClass("activebusiness");
	document.getElementById("inputtbusinesschat").setAttribute("ids", id);
	$.post(
		"http://SevenLife_Phone/AskForUpdateChat",
		JSON.stringify({ id: id })
	);
});
function InsertChatsIntoListBusinnes(items, identifier) {
	$(".mitglieder-scrollbusiness").html(" ");
	$(".mitglieder-scrollbusiness").prepend(
		`
		<div class="startnachrichtbusinnes">
			<h1 class="starttextchatbusinnes">
				Das hier ist der beginnt des Chats.
				Chats sind Ende zu Ende Verschlüsselt.
			</h1>
		</div>
	`
	);

	$.each(items, function (index, item) {
		if (item.identifier === identifier) {
			$(".mitglieder-scrollbusiness").append(
				`
						<div class="meinenachrichtbusinnes">
							<div class="nachrichtchat">
								${item.message}
							</div>
						</div>
					`
			);
		} else {
			$(".mitglieder-scrollbusiness").append(
				`
						<div class="seinenachrichtbusinnes">
							<div class="nachrichtchat">
								${item.message}
							</div>
						</div>
					`
			);
		}
	});
}
$(".inputt-chatbussiness").on("keyup", function (e) {
	if (e.key === "Enter" || e.keyCode === 13) {
		var chat = document.querySelector(".inputt-chatbussiness").value;
		var id = document
			.getElementById("inputtbusinesschat")
			.getAttribute("ids");
		document.querySelector(".inputt-chatbussiness").value = "";
		$.post(
			"http://SevenLife_Phone/InsertNewNachrichtBusiness",
			JSON.stringify({ id: id, chat: chat })
		);
	}
});
