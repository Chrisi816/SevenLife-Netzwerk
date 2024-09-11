$("document").ready(function () {
	$("#links").hide();
	$("#rechts").hide();
	$("#anschnall").hide();
	$("#tempomat").hide();
	$("#motor").hide();
	$("#manualgear").hide();
	$(".hud-container").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openhud") {
			$(".hud-container").show();
			showtimetNotification(
				msg.kmh,
				msg.gears,
				msg.liter,
				msg.streetnames
			);
		} else if (event.data.type === "removehud") {
			$("#links").hide();
			$("#rechts").hide();
			$("#anschnall").hide();
			$("#tempomat").hide();
			$("#motor").hide();
			$(".hud-container").hide();
		} else if (event.data.type === "updatehud") {
			showtimetNotification(
				msg.kmh,
				msg.gears,
				msg.liter,
				msg.streetnames
			);
		} else if (event.data.type === "updatelinks") {
			$("#links").show();
		} else if (event.data.type === "updaterechts") {
			$("#rechts").show();
		} else if (event.data.type === "updateanschnall") {
			$("#anschnall").show();
		} else if (event.data.type === "updatetempomat") {
			$("#tempomat").show();
		} else if (event.data.type === "updatemotor") {
			$("#motor").show();
		} else if (event.data.type === "removelinks") {
			$("#links").hide();
		} else if (event.data.type === "removerechts") {
			$("#rechts").hide();
		} else if (event.data.type === "removeanschnall") {
			$("#anschnall").hide();
		} else if (event.data.type === "removetempomat") {
			$("#tempomat").hide();
		} else if (event.data.type === "removemotor") {
			$("#motor").hide();
		} else if (event.data.type === "updategearmanuell") {
			$("#manualgear").show();
		} else if (event.data.type === "removegearmanuell") {
			$("#manualgear").hide();
		}
	});
});
function showtimetNotification(kmh, gear, liter, straßenname) {
	document.getElementById("kmhs").innerHTML = kmh;
	document.getElementById("gearanzahl").innerHTML = gear;
	document.getElementById("literanzahl").innerHTML = liter;
	document.getElementById("streetname").innerHTML = straßenname;
}
var Lefton = false;
var Righton = false;
var allon = false;
$(document).keyup(function (e) {
	if (e.key === "ArrowLeft") {
		if (Lefton === false) {
			$.post("http://SevenLife_VehicleHUD/Lefton", JSON.stringify({}));
		} else if (Lefton === true) {
			$.post("http://SevenLife_VehicleHUD/Leftoff", JSON.stringify({}));
		}
	}
});

$(document).keyup(function (e) {
	if (e.key === "ArrowRight") {
		if (Righton === false) {
			$.post("http://SevenLife_VehicleHUD/RightOn", JSON.stringify({}));
		} else if (Righton === true) {
			$.post("http://SevenLife_VehicleHUD/Rightoff", JSON.stringify({}));
		}
	}
});
$(document).keyup(function (e) {
	if (e.key === "ArrowUp") {
		console.log("Hey");
		if (allon === false) {
			$.post("http://SevenLife_VehicleHUD/AllOn", JSON.stringify({}));
		} else if (allon === true) {
			$.post("http://SevenLife_VehicleHUD/AllOff", JSON.stringify({}));
		}
	}
});
