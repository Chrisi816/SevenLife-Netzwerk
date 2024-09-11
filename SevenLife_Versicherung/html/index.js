$("document").ready(function () {
	$(".container-versicherung").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenVerkeaufer") {
			$(".container-versicherung").show();
		} else if (event.data.type === "UpdateCars") {
			displayavaliblecars(msg.plate, msg.labelname);
		}
	});
});
function displayavaliblecars(plate, model) {
	$(".container-autosauswahl").append(
		`
        <div class="container-impunder-containing">
					<img
						src="src/outline_directions_car_filled_white_48dp.png"
						alt=""
						class="car-picture"
					/>
					<h1 class="carname-impounder">${model}</h1>
					<h1 class="info-impounder">Kennzeichen:</h1>
					<h1 class="info-impounder2" id="kennzeichen">${plate}</h1>
					<button class="button-down" name="${plate}">
						Versicherung Kaufen
					</button>
				</div>
       
         `
	);
}
$(".container-versicherung").on("click", ".button-down", function () {
	var $button = $(this);
	var $plate = $button.attr("name");
	$(".container-versicherung").hide();
	$(".container-autosauswahl").html(" ");
	$.post(
		"http://SevenLife_Versicherung/MakeVersicherung",
		JSON.stringify({ plate: $plate })
	);
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-versicherung").hide();
	$(".container-autosauswahl").html(" ");
	$.post("http://SevenLife_Versicherung/CloseMenu", JSON.stringify({}));
}
