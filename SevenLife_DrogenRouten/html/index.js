$("document").ready(function () {
	$(".KastenLoadingVerarbeiter").hide();
	$(".Josie-Container").hide();
	$(".KastenLoadingSammeln").hide();
	$(".KastenLoadinVerarbeiten").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenBar") {
			$(".KastenLoadingVerarbeiter").show();
			document.getElementById("bar-in").style.width = "0px";
			var inter = setInterval(() => {
				var width = $("#bar-in").width();
				document.getElementById("bar-in").style.width =
					width + 21 + "px";
				if (width >= 210) {
					$(".KastenLoadingVerarbeiter").hide();
					clearInterval(inter);
				}
			}, 1000);
		} else if (event.data.type === "OpenBarDrogenSelling") {
			$(".KastenLoadingVerarbeiter").show();
			document.getElementById("bar-in").style.width = "0px";
			var inter = setInterval(() => {
				var width = $("#bar-in").width();
				document.getElementById("bar-in").style.width =
					width + 11 + "px";
				if (width >= 210) {
					$(".KastenLoadingVerarbeiter").hide();
					clearInterval(inter);
				}
			}, 1000);
		} else if (event.data.type === "OpenInterMenu") {
			$(".Josie-Container").show();
		} else if (event.data.type === "OpenBarDrogen") {
			$(".KastenLoadingSammeln").show();
			document.getElementById("bar-in2").style.width = "0px";
			var inter = setInterval(() => {
				var width = $("#bar-in2").width();
				document.getElementById("bar-in2").style.width =
					width + 21 + "px";
				if (width >= 210) {
					$(".KastenLoadingSammeln").hide();
					clearInterval(inter);
				}
			}, 1000);
		} else if (event.data.type === "OpenBarVerarbeiten") {
			$(".KastenLoadinVerarbeiten").show();
			document.getElementById("bar-in3").style.width = "0px";
			var inter = setInterval(() => {
				var width = $("#bar-in3").width();
				document.getElementById("bar-in3").style.width =
					width + 21 + "px";
				if (width >= 210) {
					$(".KastenLoadinVerarbeiten").hide();
					clearInterval(inter);
				}
			}, 1000);
		} else if (event.data.type === "OpenBarVerarbeitenManuell") {
			$(".KastenLoadinVerarbeiten").show();
			document.getElementById("bar-in3").style.width = "0px";
		} else if (event.data.type === "OpenBarVerarbeitenManuellUpdate") {
			var width = $("#bar-in3").width();
			document.getElementById("bar-in3").style.width = width + 10 + "px";

			if (width >= 210) {
				$(".KastenLoadinVerarbeiten").hide();
				$.post(
					"https://SevenLife_DrogenRouten/GiveWeedStrecken",
					JSON.stringify({})
				);
			}
		} else if (event.data.type === "OpenBarVerarbeitenManuellUpdateMeth") {
			var width = $("#bar-in3").width();
			document.getElementById("bar-in3").style.width = width + 10 + "px";

			if (width >= 210) {
				$(".KastenLoadinVerarbeiten").hide();
				$.post(
					"https://SevenLife_DrogenRouten/GiveMethStrecken",
					JSON.stringify({})
				);
			}
		} else if (event.data.type === "OpenBarVerarbeitenManuellUpdateKoks") {
			var width = $("#bar-in3").width();
			document.getElementById("bar-in3").style.width = width + 10 + "px";

			if (width >= 210) {
				$(".KastenLoadinVerarbeiten").hide();
				$.post(
					"https://SevenLife_DrogenRouten/GiveKoksStrecken",
					JSON.stringify({})
				);
			}
		}
	});
});
$(".submitbuttonseedsf").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_DrogenRouten/annehmen", JSON.stringify({}));
});
$(".submitbuttonseeds").click(function () {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_DrogenRouten/closes", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
function CloseMenu() {
	$(".Josie-Container").hide();
	$.post("https://SevenLife_DrogenRouten/closes", JSON.stringify({}));
}
