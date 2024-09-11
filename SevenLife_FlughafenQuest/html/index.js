$("document").ready(function () {
	$(".Josie-Container").hide();
	$(".container-quests").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenuJosie") {
			$(".Josie-Container").fadeIn(1000);
		} else if (event.data.type === "OpenNoobQuests") {
			$(".container-quests").fadeIn();
			document.getElementById("Meilenstein").innerHTML = msg.meilenstein;
			document.getElementById("DescText").innerHTML = msg.Desctext;
			document.getElementById("Zahlindex").innerHTML = msg.ZahlIndex;
		}
	});
});
$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_FlughafenQuest/annehmen", JSON.stringify({}));
});
$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_FlughafenQuest/ablehnen", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
function CloseMenu() {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_FlughafenQuest/closes", JSON.stringify({}));
}
