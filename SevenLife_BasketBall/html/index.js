$("document").ready(function () {
	$(".cancelmatch").hide();
	$(".container-hilfe").hide();
	$(".startmatch").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenuStartMatch") {
			$(".startmatch").show();
		} else if (event.data.type === "OpenMenuCancelMatch") {
			$(".cancelmatch").show();
		} else if (event.data.type === "OpenHelpButtons") {
			$(".container-hilfe").show();
		} else if (event.data.type === "RemoveHelpButtons") {
			$(".container-hilfe").hide();
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".cancelmatch").hide();
	$(".startmatch").hide();
	$(".container-hilfe").hide();
	$.post("https://SevenLife_BasketBall/escape");
}

$("#cancelmatchteil").click(function () {
	CloseMenu();
});
$("#cancelstart").click(function () {
	CloseMenu();
});

$("#startmatch").click(function () {
	CloseMenu();
	$.post("https://SevenLife_BasketBall/StartMatchBaskeball");
});
$("#startmatch").click(function () {
	CloseMenu();
	$.post("https://SevenLife_BasketBall/StartMatchBaskeball");
});
