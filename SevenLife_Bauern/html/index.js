$("document").ready(function () {
	$(".container-bauern").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "OpenBauer") {
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
			$(".container-bauern").show();
			MakeNuis(msg.items);
		} else if (event.data.type === "UpdateMoney") {
			document.getElementById("moneytext").innerHTML = "$" + msg.money;
		}
	});
});

function MakeNuis(items) {
	$(".boxbuying").html(" ");

	$.each(items, function (index, item) {
		$(".boxbuying").append(
			`
            <div class="container-item">
					<h1 class="Bauer-Item">${item.name}</h1>
					<div class="strich-item"></div>
					<div class="container-item-preis">
						<h1 class="Preis-Bauern">${item.preis}$</h1>
					</div>
					<div class="img-container">
						<img src="src/${item.src}.png" class="imgbild" alt="" />
					</div>
					<button class="button-down" label = ${item.label} preis = ${item.preis}>Kaufen</button>
				</div>
            `
		);
	});
}

$(".container-bauern").on("click", ".button-down", function () {
	var $button = $(this);
	var $label = $button.attr("label");
	var $preis = $button.attr("preis");

	$.post(
		"https://SevenLife_Bauern/BuyBauer",
		JSON.stringify({ name: $label, preis: $preis })
	);
});

function CloseMenu() {
	$(".container-bauern").hide();
	$.post("https://SevenLife_Bauern/CloseMenu", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
