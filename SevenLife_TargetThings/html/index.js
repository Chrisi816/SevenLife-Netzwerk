var start;
$("document").ready(function () {
	window.addEventListener("message", function (event) {
		let msg = event.data;

		if (msg.type == "OpenTarget") {
			$(".Target-Container").show();
			$.each(msg.data, function (index, item) {
				$(".img-eye1").data("TargetData", item.event);
			});
		} else if (msg.type == "OpenTarget2") {
			$(".Target-Container1").show();
		} else if (msg.type == "DeleteMann") {
			$(".Target-Container1").hide();
			start = false;
		} else if (msg.type == "DeleteMann2") {
			start = false;
			$(".Target-Container").hide();
		} else if (msg.type == "Valid") {
			let TargetData = $(".img-eye1").data("TargetData");
			$.post(
				"https://SevenLife_TargetThings/selectTarget",
				JSON.stringify({
					event: TargetData,
				})
			);
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		$(".Target-Container").hide();
		$.post(
			"https://SevenLife_TargetThings/CloseTarget",
			JSON.stringify({})
		);
	}
});
