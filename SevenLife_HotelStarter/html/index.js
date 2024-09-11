$("document").ready(function () {
	$(".havehotel").hide();
	$(".gointohotel").hide();
	$(".seveninfo").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenHotelOpenMenu") {
			$(".havehotel").fadeIn(200);
			document.getElementById("name").innerHTML = msg.name;
		} else if (event.data.type === "OpenHotelGetIn") {
			$(".gointohotel").fadeIn(200);
		} else if (event.data.type === "OpenInfo") {
			$(".seveninfo").show();
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

$(".button-betreten1").click(function () {
	$(".gointohotel").hide();
	$.post("https://SevenLife_HotelStarter/getMotel");
});
$(".button-betreten").click(function () {
	$(".havehotel").hide();
	$.post("https://SevenLife_HotelStarter/rausMotel");
});

$("#verlassen").click(function () {
	$(".seveninfo").hide();
	$.post("https://SevenLife_HotelStarter/removepaper");
});
