$("document").ready(function () {
	$(".Josie-Container").hide();
	$(".seveninfo1").hide();
	$(".seveninfo").hide();
	$(".Josie-Container1").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenuJosie") {
			$(".Josie-Container").fadeIn(1000);
		} else if (event.data.type === "OpenInfo") {
			$(".seveninfo").show();
		} else if (event.data.type === "OpenInfoEntführung") {
			$(".seveninfo1").show();
		} else if (event.data.type === "OpenMenuJosie1") {
			$(".Josie-Container1").fadeIn(1000);
		}
	});
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".havehotel").hide();

	$(".gointohotel").hide();
	$.post("https://SevenLife_HotelStarter/escape");
}

$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_IlligaleEinreise/annehmen", JSON.stringify({}));
});

$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_IlligaleEinreise/ablehnen", JSON.stringify({}));
});

$("#verlassen").click(function () {
	$(".seveninfo").hide();
	$.post("https://SevenLife_IlligaleEinreise/removepaper");
});

$("#verlassen1").click(function () {
	$(".seveninfo1").hide();
	$.post("https://SevenLife_IlligaleEinreise/removepaper");
});
$(".submitbuttonseedsf1").click(function () {
	$(".Josie-Container1").hide();
	$.post("https://SevenLife_IlligaleEinreise/annehmen1", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
function CloseMenu() {
	$(".Josie-Container1").hide();
	$.post("https://SevenLife_IlligaleEinreise/closes", JSON.stringify({}));
}
