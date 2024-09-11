$("document").ready(function () {
	$(".container-warnung").hide();
	$(".container-auftrag").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenWarnung") {
			$(".container-warnung").show();
		} else if (event.data.type === "OpenMainMenuFischer") {
			$(".container-auftrag").show();
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-warnung").hide();
	$(".container-auftrag").hide();
	$.post("http://SevenLife_Fischer/CloseMenu", JSON.stringify({}));
	$.post("http://SevenLife_Fischer/ClosePostal", JSON.stringify({}));
}

$("#abbrechen").click(function () {
	$(".container-warnung").hide();
	$.post("http://SevenLife_Fischer/ClosePostal", JSON.stringify({}));
});
$("#weiter").click(function () {
	$(".container-warnung").hide();
	$.post("http://SevenLife_Fischer/GivePedJob", JSON.stringify({}));
});
$("#loslegen").click(function () {
	$(".container-warnung").hide();
	$(".container-auftrag").hide();

	$.post("http://SevenLife_Fischer/LetsStartJob", JSON.stringify({}));
});
