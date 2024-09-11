$("document").ready(function () {
	$(".westen-container").hide();
	$(".westecraften-1").hide();
	$(".farb-craften").hide();
	$(".unten-rechts-linie").hide();
	$(".tasche-craften").hide();

	// Progress Bar

	$(".progress-bar").hide();
	$(".progress-bar-zwei").hide();
	$(".progress-bar-drei").hide();
	$(".progress-bar-vier").hide();

	// Receipt hide()

	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".kleidungtasche").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$(".NormaleFarbe").hide();
	$(".leichtewestereceipt").hide();
	$(".mittlerewestereceipt").hide();
	$(".schwerewestereceipt").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (msg.type === "Opencrafter") {
			$(".westen-container").fadeIn(200);
		} else if (event.data.type === "loadingsand") {
			$(".progress-bar").show();
			const progressBar =
				document.getElementsByClassName("progress-bar")[0];
			progress = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 100);
		} else if (event.data.type === "removeloadingsand") {
			$(".progress-bar").hide();
			clearInterval(progress);

			const progressBar =
				document.getElementsByClassName("progress-bar")[0];
			progressBar.style.removeProperty("--width");
		}
		if (event.data.type === "verarbeiternav") {
			$(".progress-bar-drei").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-drei")[0];
			progresss = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 175);
		} else if (event.data.type === "removeverarbeiternav") {
			$(".progress-bar-drei").hide();
			clearInterval(progresss);

			const progressBar =
				document.getElementsByClassName("progress-bar-drei")[0];
			progressBar.style.removeProperty("--width");
		}
		if (event.data.type === "loadingverarbeitersand") {
			$(".progress-bar-zwei").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-zwei")[0];
			progress = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 100);
		} else if (event.data.type === "removeverarbeiterloadingsand") {
			$(".progress-bar-zwei").hide();
			clearInterval(progress);

			const progressBar =
				document.getElementsByClassName("progress-bar-zwei")[0];
			progressBar.style.removeProperty("--width");
		}
		if (event.data.type === "loadingverkauf") {
			$(".progress-bar-vier").show();
			const progressBar =
				document.getElementsByClassName("progress-bar-vier")[0];
			progressssad = setInterval(() => {
				const computedStyle = getComputedStyle(progressBar);
				const width =
					parseFloat(computedStyle.getPropertyValue("--width")) || 0;
				progressBar.style.setProperty("--width", width + 1.08);
			}, 100);
		} else if (event.data.type === "removeloadingverkauf") {
			$(".progress-bar-vier").hide();
			clearInterval(progressssad);
			const progressBar =
				document.getElementsByClassName("progress-bar-vier")[0];
			progressBar.style.removeProperty("--width");
		}
	});
});

$("#westen").click(function () {
	document.getElementById("westen").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	document.getElementById("tasche").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("farbe").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	$(".westecraften-1").fadeIn(300);
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".tasche-craften").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$(".kleidungtasche").hide();
});
$("#farbe").click(function () {
	document.getElementById("westen").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("tasche").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("farbe").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	$(".farb-craften").fadeIn(300);
	$(".westecraften-1").hide();
	$(".tasche-craften").hide();
	$(".mittlerewestereceipt").hide();
	$(".unten-rechts-linie").hide();
	$(".schwerewestereceipt").hide();
	$(".leichtewestereceipt").hide();
	$(".kleidungtasche").hide();
});
$("#leichteweste").click(function () {
	$(".mittlerewestereceipt").hide();
	$(".unten-rechts-linie").show();
	$(".schwerewestereceipt").hide();
	$(".leichtewestereceipt").fadeIn(300);
});
$("#mittlereweste").click(function () {
	$(".leichtewestereceipt").hide();
	$(".unten-rechts-linie").show();
	$(".schwerewestereceipt").hide();
	$(".mittlerewestereceipt").fadeIn(300);
});
$("#schwereweste").click(function () {
	$(".schwerewestereceipt").fadeIn(300);
	$(".leichtewestereceipt").hide();
	$(".unten-rechts-linie").show();
	$(".mittlerewestereceipt").hide();
});
$("#umhängetasche").click(function () {
	$(".kleidungtasche").fadeIn(300);

	$(".unten-rechts-linie").show();
});
$("#leichte").click(function () {
	$(".westen-container").hide();
	$(".westecraften-1").hide();
	$(".farb-craften").hide();
	$(".leichtewestereceipt").hide();
	$(".mittlerewestereceipt").hide();
	$(".schwerewestereceipt").hide();
	$(".unten-rechts-linie").hide();
	$.post("http://SevenLife_Westen/Leichte", JSON.stringify({}));
});
$("#mittlere").click(function () {
	$(".westen-container").hide();
	$(".westecraften-1").hide();
	$(".farb-craften").hide();
	$(".leichtewestereceipt").hide();
	$(".mittlerewestereceipt").hide();
	$(".schwerewestereceipt").hide();
	$(".unten-rechts-linie").hide();
	$.post("http://SevenLife_Westen/Mittlere", JSON.stringify({}));
});
$("#schwere").click(function () {
	$(".westen-container").hide();
	$(".westecraften-1").hide();
	$(".farb-craften").hide();
	$(".leichtewestereceipt").hide();
	$(".mittlerewestereceipt").hide();
	$(".schwerewestereceipt").hide();
	$(".unten-rechts-linie").hide();
	$.post("http://SevenLife_Westen/Schwere", JSON.stringify({}));
});
$("#kleidungstasche").click(function () {
	$(".westen-container").hide();
	$(".westecraften-1").hide();
	$(".farb-craften").hide();
	$(".leichtewestereceipt").hide();
	$(".mittlerewestereceipt").hide();
	$(".schwerewestereceipt").hide();
	$(".unten-rechts-linie").hide();
	$(".kleidungtasche").hide();
	$.post("http://SevenLife_Westen/kleidungstasche", JSON.stringify({}));
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".westen-container").hide();
	$.post("http://SevenLife_Westen/CloseMenu", JSON.stringify({}));
}

$("#normalefarbe").click(function () {
	$(".unten-rechts-linie").show();
	$(".NormaleFarbe").fadeIn(200);
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
});
$("#grün").click(function () {
	$(".unten-rechts-linie").show();
	$(".GrüneFarbe").fadeIn(200);
	$(".NormaleFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
});
$("#gold").click(function () {
	$(".unten-rechts-linie").show();
	$(".GoldeneFarbe").fadeIn(200);
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
});
$("#pink").click(function () {
	$(".unten-rechts-linie").show();
	$(".PinkeeFarbe").fadeIn(200);
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
});
$("#orange").click(function () {
	$(".unten-rechts-linie").show();
	$(".OrangeFarbe").fadeIn(200);
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".PlatinFarbe").hide();
});
$("#platin").click(function () {
	$(".unten-rechts-linie").show();
	$(".PlatinFarbe").fadeIn(200);
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".OrangeFarbe").hide();
});

$("#NormaleFarbe").click(function () {
	$(".westen-container").hide();
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$.post("http://SevenLife_Westen/NormaleFarbe", JSON.stringify({}));
});
$("#GrüneFarbe").click(function () {
	$(".westen-container").hide();
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$.post("http://SevenLife_Westen/GrueneFarbe", JSON.stringify({}));
});
$("#GoldeneFarbe").click(function () {
	$(".westen-container").hide();
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$.post("http://SevenLife_Westen/GoldeneFarbe", JSON.stringify({}));
});
$("#PinkeeFarbe").click(function () {
	$(".westen-container").hide();
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$.post("http://SevenLife_Westen/PinkeFarbe", JSON.stringify({}));
});
$("#OrangeFarbe").click(function () {
	$(".westen-container").hide();
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$.post("http://SevenLife_Westen/OrangeFarbe", JSON.stringify({}));
});
$("#PlatinFarbe").click(function () {
	$(".westen-container").hide();
	$(".farb-craften").hide();
	$(".NormaleFarbe").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
	$.post("http://SevenLife_Westen/Platinium", JSON.stringify({}));
});
$("#tasche").click(function () {
	document.getElementById("westen").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("farbe").style.backgroundColor =
		"rgba(7, 7, 7, 0.096)";
	document.getElementById("tasche").style.backgroundColor =
		"rgba(255, 255, 255, 0.268)";
	$(".tasche-craften").fadeIn(300);
	$(".farb-craften").hide();
	$(".westecraften-1").hide();
	$(".mittlerewestereceipt").hide();
	$(".unten-rechts-linie").hide();
	$(".schwerewestereceipt").hide();
	$(".leichtewestereceipt").hide();
	$(".kleidungtasche").hide();
	$(".GrüneFarbe").hide();
	$(".PinkeeFarbe").hide();
	$(".GoldeneFarbe").hide();
	$(".unten-rechts-linie").hide();
	$(".OrangeFarbe").hide();
	$(".PlatinFarbe").hide();
});
