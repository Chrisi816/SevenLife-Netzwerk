// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Start Script------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------

$("document").ready(function () {
	$(".garage-einparken").hide();
	$(".garage-container").hide();
	$(".garage-ausparken").hide();
	$(".ausparken-container").hide();
	$(".garagen-container-real").hide();
	$(".inputt2").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "opengarage") {
			$(".inputt2").hide();
			$(".garagen-container-real").show("slow");
		} else if (event.data.type === "removegarage") {
			$(".inputt2").hide();
			$(".garagen-container-real").hide("slow");
		} else if (event.data.action == "addgarage") {
			$(".inputt2").hide();
			AddCar(event.data.plate, event.data.model, event.data.fuel);
		} else if (event.data.action == "addausparken") {
			$(".inputt2").hide();
			Displayauspark(event.data.plate, event.data.model, event.data.fuel);
		}
	});
});

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Button Script-----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
$("#einparkenbutton").click(function () {
	$(".einlager-container").show("slow");
	$(".ausparken-container").hide();

	$(".container-showcarsauslager").html("");
	$(".container-showcarseinlager").html("");
	$.post("http://SevenLife_Garagen/make-parkin");
});

$("#ausparkenbutton").click(function () {
	$(".einlager-container").hide();
	$(".ausparken-container").show("slow");
	$(".container-showcarsauslager").html("");
	$(".container-showcarseinlager").html("");
	$.post("http://SevenLife_Garagen/enable-parkout");
});

function CloseMenu() {
	$(".garagen-container-real").hide();
	$.post("http://SevenLife_Garagen/escape");
	$(".container-showcarsauslager").html("");
	$(".container-showcarseinlager").html("");
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

$(".garagen-container-real").on("click", ".submiteinparken", function () {
	var $button = $(this);
	var $plate = $button.attr("name");
	var $fuel = $button.attr("names");

	$.post(
		"http://SevenLife_Garagen/park-in",
		JSON.stringify({ plate: $plate, fuel: $fuel })
	);
	$(".container-showcarsauslager").html("");
	$(".container-showcarseinlager").html("");
	$(".garage-list").html("");
	$(".garagen-container-real").hide();
});

$(".garagen-container-real").on("click", ".submitausparken", function () {
	var $button = $(this);
	var $plate = $button.attr("name");
	var $fuel = $button.attr("names");

	$.post(
		"http://SevenLife_Garagen/park-out",
		JSON.stringify({ plate: $plate, fuel: $fuel })
	);
	$(".garagen-container-real").hide();
	$(".container-showcarsauslager").html("");
	$(".container-showcarseinlager").html("");
});

// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Show Car ein------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
function AddCar(plate, model, fuel) {
	$(".container-showcarseinlager").append(
		`
		 <div class="container-car" name ="${plate}">
			<h1 class="carnames">${model}</h1>
			<img src="src/car.png" class="carbild" alt="" />
			<h2 class="literzahl">Liter: ${fuel}</h2>
			<h2 class="kennzeichens">${plate}</h2>
			<button type="button" id="submit" class="submiteinparken" name ="${plate}">
				Bestätigen
			</button>
		 </div>
         `
	);
}
// --------------------------------------------------------------------------------------------------------------
// --------------------------------------------Show Car aus------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------
function Displayauspark(plate, model, fuel) {
	$(".container-showcarsauslager").append(
		`
		<div class="container-car">
						<h1 class="carnames">${model}</h1>
						<img src="src/car.png" class="carbild" alt="" />
						<img
							src="src/outline_drive_file_rename_outline_white_48dp.png"
							class="rename"
							plate="${plate}"
							alt=""
						/>
						<h2 class="literzahl">Liter : ${fuel}</h2>
						<h2 class="kennzeichens">${plate}</h2>
						<button
							type="button"
							id="submit"
							class="submitausparken"
							name="${plate}"
							names="${fuel}"
						>
							Bestätigen
						</button>
					</div>
         `
	);
}

function searchanimeinlagern() {
	$(".container-car").hide();
	let input = document.getElementById("inputts").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("container-car");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".carnames")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}

function searchanimasauslager() {
	$(".container-car").hide();
	let input = document.getElementById("inputts").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("container-car");

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".carnames")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}
$(".garagen-container-real").on("click", ".rename", function () {
	var $button = $(this);
	var $plate = $button.attr("plate");
	$(".inputt2").show();
	document.getElementById("inputts2").setAttribute("plate", $plate);
});
$(document).ready(function () {
	$("#inputts2").keypress(function (e) {
		if (e.which === 13) {
			$(".inputt2").hide();
			var inputting = document.getElementById("inputts2").value;
			var plate = document
				.getElementById("inputts2")
				.getAttribute("plate");
			$(".container-showcarsauslager").html("");
			$(".container-showcarseinlager").html("");
			$.post(
				"http://SevenLife_Garagen/updatename",
				JSON.stringify({ inputting: inputting, plate: plate })
			);
		}
	});
});
