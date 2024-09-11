$("document").ready(function () {
	$(".container-schlosser").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenVerkeaufer") {
			$(".container-schlosser").show();
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
						Schlüssel Ändern
					</button>
				</div>
       
         `
	);
}
$(".container-schlosser").on("click", ".button-down", function () {
	var $button = $(this);
	var $plate = $button.attr("name");
	$(".container-schlosser").hide();
	$(".container-autosauswahl").html(" ");
	$.post(
		"http://SevenLife_Schluessel/makenewschluessel",
		JSON.stringify({ plate: $plate })
	);
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-schlosser").hide();
	$(".container-autosauswahl").html(" ");
	$.post("http://SevenLife_Schluessel/CloseMenu", JSON.stringify({}));
}
