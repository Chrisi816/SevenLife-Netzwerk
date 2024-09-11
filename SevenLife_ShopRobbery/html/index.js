var closeactive = false;

$("document").ready(function () {
	$(".Josie-Container").hide();
	$(".seveninfo").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenDialogueMenu") {
			$(".Josie-Container").fadeIn(1000);
		} else if (event.data.type === "OpenInfoKatalog") {
			closeactive = true;
			$(".seveninfo").show();
			var endmoney = parseInt(msg.money) + 150;
			document.getElementById(
				"text1"
			).innerHTML = `		Hey, Tom, hier sind meine monatlichen Informationen
			über mein Geschäft. Es leuft Okay, die Inflation die
			in den letzten Monaten immer gestiegen ist, macht
			mir einen Problem. Da die Kunden immer weniger
			bereit sind zu bezahlen, ausserdem sieht es momentan
			nach einer Stagnation aus. Naja mal gucken was die
			Regierung dagegen tut. Hier sind ein paar Daten:
			Geld im Laden: ${msg.money} $ Kassierer: ~ 150$, Plus minus
			Rechne ich mit ${endmoney}$ die im Safe am Abend landen!`;
		}
	});
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		if (!closeactive) {
			CloseMenu();
		}
	}
});

function CloseMenu() {
	$(".Josie-Container").hide();

	$.post("https://SevenLife_ShopRobbery/escape");
}

$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_ShopRobbery/annehmen", JSON.stringify({}));
});

$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_ShopRobbery/ablehnen", JSON.stringify({}));
});
$(".btn").click(function () {
	$(".seveninfo").hide();
	closeactive = false;
	$.post("https://SevenLife_ShopRobbery/NextStep", JSON.stringify({}));
});
