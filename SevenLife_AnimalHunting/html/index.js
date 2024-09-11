$("document").ready(function () {
	$(".container-shop").hide();

	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenJagdShop") {
			$(".container-shop").show("slow");
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".container-shop").hide();
	$.post("https://SevenLife_AnimalHunting/escape");
}

$("#lizenzen").click(function () {
	$("#messer").hide();
	$("#lizenzens").show();
});

$("#alles").click(function () {
	$("#messer").show();
	$("#lizenzens").show();
});

$("#waffen").click(function () {
	$("#messer").show();
	$("#lizenzens").hide();
});

$("#messerkaufen").click(function () {
	CloseMenu();
	$.post("https://SevenLife_AnimalHunting/kaufmesser");
});

$("#lizenzenkauf").click(function () {
	CloseMenu();
	$.post("https://SevenLife_AnimalHunting/lizenzen");
});
