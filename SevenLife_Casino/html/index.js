var price;

$("document").ready(function () {
	$(".startmatch").hide();
	$(".startmatch2").hide();
	$(".container-shop").hide();
	$(".container-hilfe").hide();
	$(".startmatch3").hide();
	$(".container-slots").hide();
	$(".container-hilfe2Fold").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenChipsMenu") {
			$(".startmatch").show();
			price = msg.price;
			document.getElementById("inputts").value = 0;
		} else if (event.data.type === "OpenShop") {
			$(".container-shop").show();
			document.getElementById("shopnamepers").innerHTML =
				"Laden #" + msg.id;
			document.getElementById("warenkorb-2").innerHTML = "0" + "$";
		} else if (event.data.type === "GetBetInputt") {
			$(".startmatch3").show();
		} else if (event.data.type === "OpenInfoPoker") {
			$(".container-hilfe").show();
			document.getElementById("chipswetten").innerHTML =
				msg.coins + " Chips";
		} else if (event.data.type === "RemoveInfoPoker") {
			$(".container-hilfe").hide();
		} else if (event.data.type === "OpenContainerSlots") {
			$(".container-slots").show();
		} else if (event.data.type === "UpdateContainerSlots") {
			document.getElementById("chipswetten2").innerHTML =
				msg.coins + "Chips";
		} else if (event.data.type === "CloseNUISlots") {
			$(".container-slots").hide();
		} else if (event.data.type === "UpdateNUI") {
			document.getElementById("CurrentZeit").innerHTML = msg.time;
		} else if (event.data.type === "OpenSecondHilfe") {
			$(".container-hilfe2Fold").show();
		} else if (event.data.type === "HideSecondHilfe") {
			$(".container-hilfe2Fold").hide();
		} else if (event.data.type === "UpdateSecondHilfe") {
			document.getElementById("CurrentZeit2").innerHTML = msg.time;
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".startmatch").hide();
	$(".startmatch2").hide();
	$(".container-shop").hide();
	$(".startmatch3").hide();
	$.post("https://SevenLife_Casino/escape");

	$.post("http://SevenLife_Casino/close", JSON.stringify({}));
}

$(".buttonkaufenchips").click(function () {
	CloseMenu();
	var inputt = document.getElementById("inputts").value;
	$.post(
		"https://SevenLife_Casino/KaufChips",
		JSON.stringify({ inputt: inputt })
	);
});

$(".buttonverkaufenchips").click(function () {
	CloseMenu();
	var inputt = document.getElementById("inputtse").value;
	$.post(
		"https://SevenLife_Casino/VerkaufChips",
		JSON.stringify({ inputt: inputt })
	);
});

$(".buttonabbrechen1").click(function () {
	$(".startmatch2").show();
	$(".startmatch").hide();
});
$(".buttonkaufen").click(function () {
	$(".startmatch2").hide();
	$(".startmatch").show();
});
var list = {};
$(".container-shop").on("click", ".Button-addtocard", function () {
	var $button = $(this);

	var $name = $button.attr("name");
	var $item = $button.attr("item");
	var $src = $button.attr("src");
	var $count = parseFloat($button.parent().find(".Inputt-Shop").val());

	if ($count) {
		var $vorhandencount = $button.attr("count");
		var $price = parseFloat($button.attr("names"));
		var $realprice = $price * $count;
		var $realprices = 1.02 * $realprice;
		var $oldprice = document
			.getElementById("warenkorb-2")
			.getAttribute("data-value");
		var price = parseInt($realprices);
		var oldprice = parseInt($oldprice);
		var $newprice = oldprice + price;
		document
			.getElementById("warenkorb-2")
			.setAttribute("data-value", $newprice);
		document.getElementById("warenkorb-2").innerHTML = $newprice + "$";

		if ($vorhandencount >= $count) {
			list += $name;
			$(".warenkorb-shop").append(
				`
			<div class="container-container-warnekorb" item = "${$item}" name ="${$name}" names ="${$count}" preis = "${price}">
				<img
					src="src/${$src}.png"
					class="img-warenkorb"
					alt=""
				/>
				<div class="line-unter8"></div>
				<h1 class="name-warenkorb">${$name}</h1>
				<h1 class="name-preis">${price}$</h1>
				<h1 class="name-anzahl">${$count}Stk.</h1>
			</div>
        `
			);
		}
	}
});
$(".container-shop").on("click", ".Button-Buy-Shop", function () {
	var value = document.getElementsByClassName(
		"container-container-warnekorb"
	);
	for (var i = 0; i < value.length; i++) {
		console.log(value.length);
		console.log(i);
		var item = value[i].getAttribute("item");
		var countofitem = value[i].getAttribute("names");
		var preis = value[i].getAttribute("preis");
		$(".container-shop").fadeOut(500);
		$.post("http://SevenLife_Casino/close", JSON.stringify({}));
		$.post(
			"http://SevenLife_Casino/BuyItems",
			JSON.stringify({ Count: countofitem, Item: item, preis: preis })
		);
	}
	$(".warenkorb-shop").html(" ");
	document.getElementById("warenkorb-2").setAttribute("data-value", "0");
	document.getElementById("warenkorb-2").innerHTML = "0" + "$";
});

$(".buttonabbrechen2").click(function () {
	CloseMenu();
});
$(".buttonsetzenchips").click(function () {
	CloseMenu();
	var inputt = document.getElementById("inputtssetzen").value;
	$.post(
		"http://SevenLife_Casino/SetBetPoker",
		JSON.stringify({ inputt: inputt })
	);
});
