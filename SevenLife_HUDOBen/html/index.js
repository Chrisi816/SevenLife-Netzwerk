$("document").ready(function () {
	$(".hud-container").hide();

	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "openallhud") {
			$(".hud-container").show();
			showtimetNotification(
				msg.cash,
				msg.onlinePlayers,
				msg.data,
				msg.deutschzeit
			);
		} else if (event.data.type === "removeallhud") {
			$(".rechts").hide();
			$(".hud-container").hide();
		} else if (event.data.type === "refreshallhud") {
			$(".hud-container").show();
			showtimetNotification(
				msg.cash,
				msg.onlinePlayers,
				msg.data,
				msg.deutschzeit
			);
		} else if (event.data.type === "updatehungerfirst") {
			setProgress(event.data.hunger, ".showprogrssessen");
			setProgress(event.data.thirst, ".showprogresstrinken");
			$(".hud-container").show();
		} else if (event.data.type === "OpenNuiInfo") {
			$(".rechts").show();
		} else if (event.data.type === "removeNUiInfo") {
			$(".rechts").hide();
		} else if (event.data.type === "ActivateAllHUD") {
			$(".rechts").show();
			$(".hud-container").show();
		}
	});
});
function showtimetNotification(geld, online, date, deutschzeit) {
	document.getElementById("geld").innerHTML = geld;
	document.getElementById("playercount").innerHTML = online + " / 10";
	document.getElementById("date").innerHTML = date + ". " + deutschzeit;
}
function setProgress(percent, element) {
	$(element).height(percent);
}
