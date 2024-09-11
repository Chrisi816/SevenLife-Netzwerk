$("document").ready(function () {
	$(".container-rental").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "openrental") {
			$(".container-rental").slideToggle();
			MakeNuis(msg.result);
		} else if (event.data.type === "removerental") {
			$(".container-rental").hide("slow");
		}
	});
});

function MakeNuis(items) {
	$(".contaiener-middle").html(" ");

	$.each(items, function (index, item) {
		$(".contaiener-middle").append(
			`
            <div class="container-middle-fahrzeuglist">
                <img class="img-container" src="src/${item.name}.webp" alt="" />
                <h1 class="carname">${item.name}</h1>
                <h1 class="carpreis">${item.preisprominute}$ pro Minute</h1>
                <input class="inputt" id="inputts" placeholder="Minuten" />
                <button class="button-down" name = "${item.label}" preis = "${item.preisprominute}">Kaufen</button>
            </div>
            `
		);
	});
}

function CloseMenu() {
	$(".container-rental").hide();
	$.post("http://SevenLife_Rental/CloseMenu", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

$(".container-rental").on("click", ".button-down", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $preis = $button.attr("preis");
	var $count = parseFloat($button.parent().find(".inputt").val());
	CloseMenu();
	if (typeof $count !== undefined) {
		$.post(
			"http://SevenLife_Rental/GiveCar",
			JSON.stringify({ name: $name, count: $count, preis: $preis })
		);
	} else {
		$.post("http://SevenLife_Rental/Fehler", JSON.stringify({}));
	}
});
