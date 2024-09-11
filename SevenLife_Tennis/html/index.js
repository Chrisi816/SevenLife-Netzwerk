$("document").ready(function () {
	$(".container-hilfe").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenHelpMenu") {
			$(".container-hilfe").show();
		} else if (event.data.type === "CloseHelpMenu") {
			$(".container-hilfe").show();
		}
	});
});
