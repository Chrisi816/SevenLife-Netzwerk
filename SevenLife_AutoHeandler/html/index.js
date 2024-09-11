$("document").ready(function () {
	$(".body-container").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "OpenNuiCarShop") {
			$(".body-container").show();
			document.getElementById("textwhichone").innerHTML = msg.name;
			InsertIntoTable(msg.resultcars);
		} else if (event.data.type === "OpenRight") {
			document.getElementById("carname-rechts").innerHTML = msg.name;
			document.getElementById("carpreis-rechts").innerHTML =
				"$" + msg.price;
			document
				.getElementById("Button-Buy")
				.setAttribute("label", msg.label);
			document
				.getElementById("Button-Buy")
				.setAttribute("price", msg.price);
			document
				.getElementById("Button-ProbeFahren")
				.setAttribute("label", msg.label);
			document
				.getElementById("Button-ProbeFahren")
				.setAttribute("price", msg.price);

			$(".container-rand").html("");
			$(".container-rand2").html("");
			$(".container-rand3").html("");
			$(".container-rand4").html("");

			var maxSpeed = msg.maxSpeed;
			var brake = msg.brake;
			var seatplace = msg.seatplace;
			var torque = msg.torque;

			// Max Speed
			if (maxSpeed <= 50) {
				$(".container-rand").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (maxSpeed <= 100) {
				$(".container-rand").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (maxSpeed <= 150) {
				$(".container-rand").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (maxSpeed <= 200) {
				$(".container-rand").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (maxSpeed <= 250) {
				$(".container-rand").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (maxSpeed <= 300) {
				$(".container-rand").append(
					`
				<div class="corner"></div>
				`
				);
			}

			// Brake
			if (brake >= 0.0) {
				$(".container-rand2").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (brake >= 0.2) {
				$(".container-rand2").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (brake >= 0.4) {
				$(".container-rand2").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (brake >= 0.6) {
				$(".container-rand2").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (brake >= 0.8) {
				$(".container-rand2").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (brake >= 1) {
				$(".container-rand2").append(
					`
				<div class="corner"></div>
				`
				);
			}

			// SeatPlace
			if (seatplace == 1) {
				$(".container-rand3").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (seatplace == 2) {
				$(".container-rand3").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (seatplace == 3) {
				$(".container-rand3").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (seatplace == 4) {
				$(".container-rand3").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (seatplace == 5) {
				$(".container-rand3").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (seatplace == 6) {
				$(".container-rand3").append(
					`
				<div class="corner"></div>
				`
				);
			}

			// Torque
			if (torque >= 0) {
				$(".container-rand4").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (torque >= 2.0) {
				$(".container-rand4").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (torque >= 2.2) {
				$(".container-rand4").append(
					`
					<div class="corner"></div>
					`
				);
			}
			if (torque >= 2.5) {
				$(".container-rand4").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (torque >= 2.7) {
				$(".container-rand4").append(
					`
				<div class="corner"></div>
				`
				);
			}
			if (torque >= 3.0) {
				$(".container-rand4").append(
					`
				<div class="corner"></div>
				`
				);
			}
		}
	});
});

function InsertIntoTable(items) {
	$(".insertcars").html("");

	$.each(items, function (index, item) {
		$(".insertcars").append(
			`
			<div class="insertcars-container" name = ${item.name} label = ${item.label} price = ${item.price}>
					<div class="insertcars-container-left">
						<img
							src="design/outline_directions_car_filled_white_48dp.png"
							class="carimg"
							alt=""
						/>
					</div>
					<h1 class="carname-authaus">${item.name}</h1>
					<div class="container-price">
						<h1 class="price-car">$${item.price}</h1>
					</div>
			</div>
			`
		);
	});
}

$(".body-container").on("click", ".insertcars-container", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $label = $button.attr("label");
	var $price = $button.attr("price");

	$.post(
		"https://SevenLife_AutoHeandler/SpawnCar",
		JSON.stringify({ name: $name, label: $label, price: $price })
	);
});

function CloseMenu() {
	$(".body-container").hide();
	$.post("https://SevenLife_AutoHeandler/Raus", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
$(document).keydown(function (e) {
	if (e.key === "d") {
		$.post(
			"https://SevenLife_AutoHeandler/rotationleft",
			JSON.stringify({ value: -5 })
		);
	}
});
$(document).keydown(function (e) {
	if (e.key === "a") {
		$.post(
			"https://SevenLife_AutoHeandler/rotationright",
			JSON.stringify({ value: 5 })
		);
	}
});
$(".body-container").on("click", ".Button-Buy", function () {
	var $button = $(this);
	$(".body-container").hide();
	var $label = $button.attr("label");
	var $price = $button.attr("price");

	$.post(
		"https://SevenLife_AutoHeandler/buyCar",
		JSON.stringify({ label: $label, price: $price })
	);
});
$(".body-container").on("click", ".Button-ProbeFahren", function () {
	var $button = $(this);
	$(".body-container").hide();
	var $label = $button.attr("label");
	var $price = $button.attr("price");

	$.post(
		"https://SevenLife_AutoHeandler/ProbeFahren",
		JSON.stringify({ label: $label, price: $price })
	);
});
