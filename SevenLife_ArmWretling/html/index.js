$("document").ready(function () {
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenDialogueMenu") {
			$(".container-hilfe").show();
		} else if (event.data.type === "RemoveDialogueMenu") {
			$(".container-hilfe").hide();
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "x") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".container-hilfe").hide();
}
