var anzahl = 0;

var price;
$(".orange").each(function () {
	$(this).data({
		originalLeft: $(this).css("left"),
		origionalTop: $(this).css("top"),
	});
});

$("document").ready(function () {
	$(".orangenpflücken").hide();
	$(".orangenverarbeiter").hide();
	$(".KastenLoadingVerarbeiter").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenOrange") {
			anzahl = 0;
			$(".orangenpflücken").show();

			$(".orange").each(function () {
				$(".orange").draggable("enable");
				$(this).css({
					left: $(this).data("originalLeft"),
					top: $(this).data("origionalTop"),
				});
			});
		} else if (event.data.type === "OpenOrangeVerarbeiter") {
			$(".orangenverarbeiter").show();
		} else if (event.data.type === "OpenVerarbeiterNUI") {
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
		}
	});
});

$(".orange").each(function () {
	$(this).draggable({
		appendTo: ".orangenpflücken",
	});
});

$(".Basket")
	.off()
	.droppable({
		drop: function (event, ui) {
			var items = ui.draggable.attr("name");
			$("#" + items).draggable("disable");
			anzahl = anzahl + 1;

			if (anzahl == 5) {
				$(".orangenpflücken").hide();
				$.post(
					"https://SevenLife_Orangen/GiveOrange",
					JSON.stringify({})
				);
			}
		},
	});

function CloseMenu() {
	$(".orangenverarbeiter").hide();
	$.post("http://SevenLife_Orangen/CloseMenu", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
$(".button-down").click(function () {
	$(".orangenverarbeiter").hide();
	$.post("http://SevenLife_Orangen/MakeVerarbeiten", JSON.stringify({}));
});
