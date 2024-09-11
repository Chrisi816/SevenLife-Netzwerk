$("document").ready(function () {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seiteauto").style.display = "none";
	document.getElementById("seiteitems").style.display = "none";
	document.getElementById("seitemunition").style.display = "none";
	document.getElementById("seitewaffen").style.display = "none";
	document.getElementById("seitebomben").style.display = "none";

	//Container
	document.getElementById("bufallocontainer").style.display = "none";
	document.getElementById("laptopcontainer").style.display = "none";
	document.getElementById("muntion19container").style.display = "none";
	document.getElementById("munition36container").style.display = "none";
	document.getElementById("c4container").style.display = "none";
	document.getElementById("mc4container").style.display = "none";
	document.getElementById("minic4container").style.display = "none";
	document.getElementById("taucheranzugcontainer").style.display = "none";

	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenSchwarzMarkt") {
			document
				.getElementById("container-zweiterschwarzmarkt")
				.style.removeProperty("display");
			document.getElementById("money").innerHTML = msg.money;
			document.getElementById("moneys").innerHTML = msg.money;
			document.getElementById("moneyss").innerHTML = msg.money;
			document.getElementById("moneysss").innerHTML = msg.money;
			document.getElementById("moneyssss").innerHTML = msg.money;
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seiteauto").style.display = "none";
	document.getElementById("seiteitems").style.display = "none";
	document.getElementById("seitemunition").style.display = "none";
	document.getElementById("seitewaffen").style.display = "none";
	document.getElementById("seitebomben").style.display = "none";
	$.post("https://SevenLife_ZweiterSchwarzMarkt/Escape");
}

$(".linksoben").click(function () {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seiteauto").style.removeProperty("display");
});

$(".rechtsobenerste").click(function () {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seiteitems").style.removeProperty("display");
});

$(".rechtsobenzweite").click(function () {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seitemunition").style.removeProperty("display");
});

$(".rechtsutenerste").click(function () {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seitewaffen").style.removeProperty("display");
});

$(".rechtsutenzweite").click(function () {
	document.getElementById("container-zweiterschwarzmarkt").style.display =
		"none";
	document.getElementById("seitebomben").style.removeProperty("display");
});

$(".exit").click(function () {
	document.getElementById("seiteauto").style.display = "none";
	document.getElementById("seiteitems").style.display = "none";
	document.getElementById("seitemunition").style.display = "none";
	document.getElementById("seitewaffen").style.display = "none";
	document.getElementById("seitebomben").style.display = "none";
	$.post("https://SevenLife_ZweiterSchwarzMarkt/Escape");
});
$(".return").click(function () {
	document.getElementById("seiteauto").style.display = "none";
	document.getElementById("seiteitems").style.display = "none";
	document.getElementById("seitemunition").style.display = "none";
	document.getElementById("seitewaffen").style.display = "none";
	document.getElementById("seitebomben").style.display = "none";
	document
		.getElementById("container-zweiterschwarzmarkt")
		.style.removeProperty("display");
});

$("#bufallo").click(function () {
	document.getElementById("bufallocontainer").style.removeProperty("display");
});

$("#leptopses").click(function () {
	document.getElementById("laptopcontainer").style.removeProperty("display");
	document.getElementById("taucheranzugcontainer").style.display = "none";
});

$("#munition19").click(function () {
	document
		.getElementById("muntion19container")
		.style.removeProperty("display");
	document.getElementById("munition36container").style.display = "none";
});

$("#munition39").click(function () {
	document
		.getElementById("munition36container")
		.style.removeProperty("display");
	document.getElementById("muntion19container").style.display = "none";
});

$("#c4").click(function () {
	document.getElementById("c4container").style.removeProperty("display");
	document.getElementById("mc4container").style.display = "none";
	document.getElementById("minic4container").style.display = "none";
});

$("#mc4").click(function () {
	document.getElementById("mc4container").style.removeProperty("display");
	document.getElementById("c4container").style.display = "none";
	document.getElementById("minic4container").style.display = "none";
});

$("#minic4").click(function () {
	document.getElementById("minic4container").style.removeProperty("display");
	document.getElementById("c4container").style.display = "none";
	document.getElementById("mc4container").style.display = "none";
});

$(".allcontainers").on("click", ".buttonbuy", function () {
	var $button = $(this);
	var $preis = $button.attr("preis");
	var $name = $button.attr("name");
	var $itemtype = $button.attr("type");
	var $anzahl = document.getElementById($name).value;

	$.post(
		"https://SevenLife_ZweiterSchwarzMarkt/MakeItem",
		JSON.stringify({
			anzahl: $anzahl,
			name: $name,
			preis: $preis,
			itemtype: $itemtype,
		})
	);
	CloseMenu();
});

$(".allcontainers").on("click", "#buttonbuybufello", function () {
	var $button = $(this);
	var $preis = $button.attr("preis");
	var $name = $button.attr("name");
	var $itemtype = $button.attr("type");
	var $anzahl = document.getElementById("buffalo").value;
	$.post(
		"https://SevenLife_ZweiterSchwarzMarkt/MakeItem",
		JSON.stringify({
			anzahl: $anzahl,
			name: $name,
			preis: $preis,
			itemtype: $itemtype,
		})
	);
	CloseMenu();
});

$("#taucheranzugese").click(function () {
	document
		.getElementById("taucheranzugcontainer")
		.style.removeProperty("display");
	document.getElementById("laptopcontainer").style.display = "none";
});
