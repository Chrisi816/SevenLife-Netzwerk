var active = false;

$("document").ready(function () {
	//$(".einzahlen-card").hide();
	$(".auszahlen-card").hide();
	$(".überweisen-card").hide();
	$(".normalbank").hide();
	$(".anmeldefenster").hide();
	$(".KarteAuswehlen").hide();
	$(".mainpage-crypto").hide();
	$(".transaktionen-bild").hide();
	$(".hauptseite").hide();
	$(".page-auszahlenbtc").hide();
	$(".page-einzahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".mainbank").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenNormalBank") {
			active = true;
			$(".normalbank").fadeIn(1000);
			document.getElementById("guthaben").innerHTML = msg.bankmoney + "$";
			document.getElementById("iban-nummer").innerHTML = msg.iban;
			document.getElementById("name").innerHTML = msg.firstname;

			if (msg.bankcard === 1) {
				document.getElementById("textsteuern").innerHTML =
					"Transaktions Gebühren: 2%";
				document.getElementById("textsteuern1").innerHTML =
					"Transaktions Gebühren: 2%";
				document.getElementById("bankcard").style.background =
					"linear-gradient(to right, rgb(127, 127, 127) , rgb(56, 56, 56));";
			} else if (msg.bankcard === 2) {
				document.getElementById("textsteuern").innerHTML =
					"Transaktions Gebühren: 1.2%";
				document.getElementById("textsteuern1").innerHTML =
					"Transaktions Gebühren: 1.2%";
				document.getElementById("bankcard").style.background =
					"linear-gradient(to right, rgb(92, 60, 0) , rgb(214, 114, 0));";
			} else if (msg.bankcard === 3) {
				document.getElementById("textsteuern").innerHTML =
					"Transaktions Gebühren: 0.5%";
				document.getElementById("textsteuern1").innerHTML =
					"Transaktions Gebühren: 0.5%";
				document.getElementById("bankcard").style.background =
					"linear-gradient(to right, rgb(114, 105, 0) , rgb(228, 236, 0));";
			}
		} else if (msg.type === "OpenAnmeldeBild") {
			$(".anmeldefenster").fadeIn(2000);
		} else if (msg.type === "OpenMainBank") {
			active = true;
			$(".mainbank").fadeIn(1000);
			document.getElementById("guthaben1").innerHTML =
				msg.bankmoney + "$";
			document.getElementById("iban-nummer1").innerHTML = msg.iban;
			document.getElementById("name1").innerHTML = msg.firstname;

			if (msg.bankcard === 1) {
				document.getElementById("textsteuern2").innerHTML =
					"Transaktions Gebühren: 2%";
				document.getElementById("textsteuern12").innerHTML =
					"Transaktions Gebühren: 2%";
				document.getElementById("sevencard").innerHTML = "Aktiv";
				document.getElementById("bronzecard").innerHTML = "Bestätigen";
				document.getElementById("goldecard").innerHTML = "Bestätigen";
				document.getElementById("bankcard1").style.background =
					"linear-gradient(to right, rgb(127, 127, 127) , rgb(56, 56, 56));";
			} else if (msg.bankcard === 2) {
				document.getElementById("textsteuern2").innerHTML =
					"Transaktions Gebühren: 1.2%";
				document.getElementById("textsteuern12").innerHTML =
					"Transaktions Gebühren: 1.2%";
				document.getElementById("bronzecard").innerHTML = "Aktiv";
				document.getElementById("sevencard").innerHTML = "Bestätigen";
				document.getElementById("goldecard").innerHTML = "Bestätigen";
				document.getElementById("bankcard1").style.background =
					"linear-gradient(to right, rgb(92, 60, 0) , rgb(214, 114, 0));";
			} else if (msg.bankcard === 3) {
				document.getElementById("textsteuern2").innerHTML =
					"Transaktions Gebühren: 0.5%";
				document.getElementById("textsteuern12").innerHTML =
					"Transaktions Gebühren: 0.5%";
				document.getElementById("goldecard").innerHTML = "Aktiv";
				document.getElementById("bronzecard").innerHTML = "Bestätigen";
				document.getElementById("sevencard").innerHTML = "Bestätigen";
				document.getElementById("bankcard1").style.background =
					"linear-gradient(to right, rgb(114, 105, 0) , rgb(228, 236, 0));";
			}
		} else if (msg.type === "OpenTransaktionsmenu") {
			$(".transaktionen-bild").show();
			MakeTransaktions(msg.result);
		} else if (msg.type === "OpenBankCryptoDeashBoard") {
			$(".mainpage-crypto").show();

			InsertData(msg.name, msg.btc, msg.eth, msg.ethwert, msg.btcwert);
		} else if (msg.type === "KaufBTCCrypto") {
			$(".page-einzahlenbtc").show();
			document.getElementById("einzahlenbtc").innerHTML =
				"Willst du Bitcoins bei einem Preis von " +
				msg.btcwert +
				"$ kaufen?";
		}
		if (msg.type === "VerkaufBTCCrypto") {
			$(".page-auszahlenbtc").show();
			document.getElementById("auszahlenbtc").innerHTML =
				"Willst du deine Bitcoins bei einem Preis von pro " +
				msg.btcwert1 +
				"$  umwandeln?";
		}
		if (msg.type === "KaufETHCrypto") {
			$(".page-einzahleneth").show();
			document.getElementById("einzahleneth").innerHTML =
				" Willst du Ethereum bei einem Preis von " +
				msg.ethwert +
				"$ kaufen?";
		}
		if (msg.type === "VerkaufETHCrypto") {
			$(".page-auszahleneth").show();
			document.getElementById("auszahleneth").innerHTML =
				" Willst du deine Ethereum Coins bei einem Preis von pro " +
				msg.ethwert1 +
				"$ $ umwandeln?";
		}
	});
});

function InsertData(name, btc, eth, ethwert, btcwert) {
	document.getElementById("name-crypto").innerHTML = name;
	document.getElementById("bitcoin").innerHTML = btc;
	document.getElementById("ether").innerHTML = eth;
	document.getElementById("ethverkauf").innerHTML = "V:" + ethwert + "$";
	document.getElementById("btcverkauf").innerHTML = "V:" + btcwert + "$";
	btwerts = btcwert;
	ethwerts = ethwert;
	ethwert1 = parseInt(ethwert);
	btcwert1 = parseInt(btcwert);
	ethwert12 = 10 + ethwert1;
	btcwert12 = 10 + btcwert1;
	document.getElementById("ethkauf").innerHTML = "K:" + ethwert12 + "$";
	document.getElementById("btckauf").innerHTML = "K:" + btcwert12 + "$";
}
document.addEventListener("DOMContentLoaded", function () {
	const slider = document.querySelector(".sliders");
	const firstElement = slider.querySelector(".element:first-of-type");

	if (slider === undefined || firstElement === undefined) {
		return;
	}

	document
		.querySelector(".arrows.left")
		.addEventListener("click", function () {
			slider.scrollLeft -= firstElement.clientWidth;
		});
	document
		.querySelector(".arrows.right")
		.addEventListener("click", function () {
			slider.scrollLeft += firstElement.clientWidth;
		});
});
$(".mainpage-crypto").hide();
$(".einzahlen").click(function () {
	$(".einzahlen-card").show();
	$(".auszahlen-card").hide();
	$(".überweisen-card").hide();
	$(".KarteAuswehlen").hide();
	$(".transaktionen-bild").hide();
	$(".hauptseite").hide();
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".mainpage-crypto").hide();
});
$(".auszahlen").click(function () {
	$(".einzahlen-card").hide();
	$(".auszahlen-card").show();
	$(".überweisen-card").hide();
	$(".KarteAuswehlen").hide();
	$(".transaktionen-bild").hide();
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".hauptseite").hide();
	$(".mainpage-crypto").hide();
});

$(".überweisungen").click(function () {
	$(".einzahlen-card").hide();
	$(".auszahlen-card").hide();
	$(".überweisen-card").show();
	$(".KarteAuswehlen").hide();
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".transaktionen-bild").hide();
	$(".mainpage-crypto").hide();
	$(".hauptseite").hide();
});
$(".kartenauswahl").click(function () {
	$(".einzahlen-card").hide();
	$(".auszahlen-card").hide();
	$(".überweisen-card").hide();
	$(".KarteAuswehlen").show();
	$(".transaktionen-bild").hide();
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".hauptseite").hide();
	$(".mainpage-crypto").hide();
});
$(".cryptonicauswahl").click(function () {
	$(".einzahlen-card").hide();
	$(".auszahlen-card").hide();
	$(".überweisen-card").hide();
	$(".KarteAuswehlen").hide();
	$(".transaktionen-bild").hide();
	$(".hauptseite").show();
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".mainpage-crypto").hide();
});
$(".transaktionen").click(function () {
	$(".einzahlen-card").hide();
	$(".auszahlen-card").hide();
	$(".überweisen-card").hide();
	$(".KarteAuswehlen").hide();
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".hauptseite").hide();
	$(".mainpage-crypto").hide();

	$.post("http://SevenLife_Bank/GetTransaktionsData", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		if (active) {
			$(".normalbank").fadeOut(300);
			$(".mainbank").fadeOut(300);
			$.post("http://SevenLife_Bank/CloseBank", JSON.stringify({}));
		}
	}
});
$(".einzahlenbutton").click(function () {
	$(".normalbank").fadeOut(300);
	$(".mainbank").fadeOut(300);
	var geldeinzahl = document.getElementById("einzahlengeldinputt").value;
	$.post(
		"http://SevenLife_Bank/transaktion",
		JSON.stringify({ type: "einzahlennormal", geld: geldeinzahl })
	);
});
$(".auszahlbutton").click(function () {
	$(".normalbank").fadeOut(300);
	$(".mainbank").fadeOut(300);
	var geldeinzahl = document.getElementById("auszahlinputt").value;
	$.post(
		"http://SevenLife_Bank/transaktion",
		JSON.stringify({ type: "auszahlennormal", geld: geldeinzahl })
	);
});
$(".submitbuttonsees").click(function () {
	$(".normalbank").fadeOut(300);
	$(".mainbank").fadeOut(300);
	var IbanID = document.getElementById("IbanID").value;
	var Money = document.getElementById("Money").value;
	$.post(
		"http://SevenLife_Bank/transaktion",
		JSON.stringify({ type: "überweisen", IbanID: IbanID, Money: Money })
	);
});
$(".einzahlenbutton1").click(function () {
	$(".normalbank").fadeOut(300);
	$(".mainbank").fadeOut(300);
	var geldeinzahl = document.getElementById("einzahlengeldinputt1").value;
	$.post(
		"http://SevenLife_Bank/transaktion",
		JSON.stringify({ type: "einzahlen", geld: geldeinzahl })
	);
});
$(".auszahlbutton1").click(function () {
	$(".normalbank").fadeOut(300);
	$(".mainbank").fadeOut(300);
	var geldeinzahl = document.getElementById("auszahlinputt1").value;
	$.post(
		"http://SevenLife_Bank/transaktion",
		JSON.stringify({ type: "auszahlen", geld: geldeinzahl })
	);
});
$(".submitbuttonsees1").click(function () {
	$(".normalbank").fadeOut(300);
	$(".mainbank").fadeOut(300);
	var IbanID = document.getElementById("IbanID1").value;
	var Money = document.getElementById("Money1").value;
	$.post(
		"http://SevenLife_Bank/transaktion",
		JSON.stringify({ type: "überweisen", IbanID: IbanID, Money: Money })
	);
});
$(".kontoanmeldebutton").click(function () {
	$(".anmeldefenster").hide();
	$.post("http://SevenLife_Bank/Kontoereffnet", JSON.stringify({}));
});

$(".goldecard").click(function () {
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/kartekauf",
		JSON.stringify({ type: 3, preis: 60000 })
	);
});
$(".bronzecard").click(function () {
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/kartekauf",
		JSON.stringify({ type: 2, preis: 20000 })
	);
});
$(".sevencard").click(function () {
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/kartekauf",
		JSON.stringify({ type: 1, preis: 0 })
	);
});
function MakeTransaktions(items) {
	$(".container-frame").html("");
	$.each(items, function (index, item) {
		$(".container-frame").append(
			`
         <div class="transferapteil">
                                      <img src="src/${item.typ}.png" class="bilde" alt="">
                                      <h1 class="geldfluss">${item.geld}</h1>
                                      <img src="src/bankAmerica.png" class="banklogos" alt="">
                                      <h1 class="ibanfluss">${item.who}</h1>
                                  </div>
         `
		);
	});
}

$(".SubmitbuttonLoginCrypto").click(function () {
	$(".hauptseite").hide();
	var $benutzer = document.getElementById("inputbenutzer").value;
	var $passwort = document.getElementById("inputps").value;
	$.post(
		"http://SevenLife_Bank/AccountCryptoAnmelde",
		JSON.stringify({ benutzer: $benutzer, passwort: $passwort })
	);
});
$(".kaufen.bitcoin").click(function () {
	$.post(
		"http://SevenLife_Bank/GetDataCrypto",
		JSON.stringify({ typ: 1, btcwert: btcwert12 })
	);
	$(".mainpage-crypto").hide();
});
$(".verkaufen.bitcoin").click(function () {
	$.post(
		"http://SevenLife_Bank/GetDataCrypto",
		JSON.stringify({ typ: 2, btcwert1: btwerts })
	);
	$(".mainpage-crypto").hide();
});
$(".kaufen.ether").click(function () {
	$.post(
		"http://SevenLife_Bank/GetDataCrypto",
		JSON.stringify({ typ: 3, ethwert: ethwert12 })
	);
	$(".mainpage-crypto").hide();
});
$(".verkaufen.ether").click(function () {
	$.post(
		"http://SevenLife_Bank/GetDataCrypto",
		JSON.stringify({ typ: 4, ethwert1: ethwerts })
	);
	$(".mainpage-crypto").hide();
});
/* vfgfdgfdg */
$(".submitbuttonse.auszahlenbtcs").click(function () {
	var $coins = document.getElementById("auszahlenbtcse").value;
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/TransferCrypto",
		JSON.stringify({ typ: 1, btcwert1: btwerts, coinsverkaufen: $coins })
	);
});
$(".submitbuttonse.einzahlenbtcs").click(function () {
	var $coins = document.getElementById("einzahlenbtcse").value;
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/TransferCrypto",
		JSON.stringify({ typ: 2, btcwert: btcwert12, coinskaufen: $coins })
	);
});
$(".submitbuttonse.auszahleneths").click(function () {
	var $coins = document.getElementById("auszahlenethese").value;
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/TransferCrypto",
		JSON.stringify({ typ: 3, ethwert1: ethwerts, coinsverkaufen1: $coins })
	);
});
$(".submitbuttonse.einzahleeths").click(function () {
	var $coins = document.getElementById("einzahleneth").value;
	$(".page-auszahlenbtc").hide();
	$(".page-auszahleneth").hide();
	$(".page-einzahleneth").hide();
	$(".page-einzahlenbtc").hide();
	$(".mainbank").fadeOut(300);
	$.post(
		"http://SevenLife_Bank/TransferCrypto",
		JSON.stringify({ typ: 4, ethwert: ethwert12, coinskaufen1: $coins })
	);
});
