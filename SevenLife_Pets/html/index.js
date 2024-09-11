$("document").ready(function () {
	$(".nuifocus").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		id = msg.id;
		preis = msg.preis;
		if (event.data.type === "OpenPetMenu") {
			$(".nuifocus").fadeIn(400);
		} else if (event.data.type === "removeshopnui") {
			$(".nuifocus").fadeOut(300);
		}
	});
});

var list = {};
$(".nuifocus").on("click", ".container-buyanimal", function () {
	var $button = $(this);

	var $types = $button.attr("types");
	var $name = $button.attr("name");
	var $price = parseFloat($button.attr("zahle"));
	var $oldprice = document
		.getElementById("text-zahlense")
		.getAttribute("data-value");
	var $oldprice = parseInt($oldprice);
	var $newprice = $oldprice + $price;
	document
		.getElementById("text-zahlense")
		.setAttribute("data-value", $newprice);
	document.getElementById("text-zahlense").innerHTML = $newprice + "$";
	list += $types;
	$(".warenkorb-container").append(
		`
        <div class="container-warenkorb1" name = ${$name} types = ${$types} price = ${$price}>
						<div class="inside-container-warenkorb">
							<img
								src="items/A_C_Retriever.png"
								class="emoji-warenkorb"
								alt=""
							/>
						</div>
						<h1 class="text-warnekorb">${$name}</h1>
						<h1 class="text-stückanzahl">Stk. 1</h1>
					</div>
        `
	);
});
$(".nuifocus").on("click", ".submitbutton", function () {
	var value = document.getElementsByClassName("container-warenkorb1");
	$(".nuifocus").fadeOut(500);
	console.log(value);
	for (i = 0; i < value.length; i++) {
		var item = value[i].getAttribute("name");
		var types = value[i].getAttribute("types");
		var price = value[i].getAttribute("price");
		console.log(types);

		$.post(
			"https://SevenLife_Pets/BuyPets",
			JSON.stringify({ types: types, item: item, price: price })
		);
	}

	CloseAll();
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".nuifocus").hide();
	list = {};
	$(".warenkorb-container").html("");
	document.getElementById("text-zahlense").innerHTML = "0$";
	document.getElementById("text-zahlense").setAttribute("data-value", "0");
	$.post("https://SevenLife_Pets/CloseMenu", JSON.stringify({}));
}
