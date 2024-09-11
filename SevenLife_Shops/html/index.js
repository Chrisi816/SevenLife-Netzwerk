$("document").ready(function () {
	$(".container-shop").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		id = msg.id;
		preis = msg.preis;
		if (event.data.type === "openshopnui") {
			$(".container-shop").show();
			InersertShopData(msg.result);
			document.getElementById("shopnamepers").innerHTML =
				"Laden #" + msg.id;
			document.getElementById("warenkorb-2").innerHTML = "0" + "$";
		} else if (event.data.type === "removeshopnui") {
			$(".container-shop").fadeOut(300);
		}
	});
});

function InersertShopData(items) {
	$(".insert-container-shop").html("");

	$.each(items, function (index, item) {
		count = item.count;
		$(".insert-container-shop").append(
			`
			<div class="container-item">
			<div class="container-bild-waren">
				<img src="src/${item.src}.png" class="img-ware" alt="" />
			</div>
			
			<h1 class="steuern2">Stück:</h1>
			<h1 class="steuern-nummer2">${count} Stk.</h1>
			<div class="line-unter9"></div>
			<h1 class="preis2">Preis:</h1>
			<h1 class="preis-nummer2" id="preis-nummer2">${item.preis}$</h1>
			<div class="untens">
			   <input
			class="Inputt-Shop"
			id="Inputt-Shop"
			placeholder="0"
		/>
			    <button class="Button-addtocard" name= "${item.label}" item= "${item.item}" names= "${item.preis}"  count= "${count}" src = "${item.src}">Hinzufügen</button>
			</div>
		
		</div>
         `
		);
	});
}

var list = {};
$(".container-shop").on("click", ".Button-addtocard", function () {
	var $button = $(this);

	var $name = $button.attr("name");
	var $item = $button.attr("item");
	var $src = $button.attr("src");
	var $count = parseFloat($button.parent().find(".Inputt-Shop").val());
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
	console.log($count);
	console.log($vorhandencount);
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
});

$(".container-shop").on("click", ".Button-Buy-Shop", function () {
	var value = document.getElementsByClassName(
		"container-container-warnekorb"
	);
	for (i = 0; i < value.length; i++) {
		var item = value[i].getAttribute("item");
		var countofitem = value[i].getAttribute("names");
		var preis = value[i].getAttribute("preis");
		$(".container-shop").fadeOut(500);

		$.post("http://SevenLife_Shops/close", JSON.stringify({}));
		$.post(
			"http://SevenLife_Shops/BuyItems",
			JSON.stringify({ Count: countofitem, Item: item, preis: preis })
		);
	}
	$(".warenkorb-shop").html(" ");
	document.getElementById("warenkorb-2").setAttribute("data-value", "0");
	document.getElementById("warenkorb-2").innerHTML = "0" + "$";
});

$(".bild").click(function () {
	$(".main-container").fadeOut(500);
	$.post("http://SevenLife_Shops/close", JSON.stringify({}));
});
$("document").ready(function () {
	$(".kaufen").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		id = msg.id;
		if (event.data.type === "OpenShopBuy") {
			$(".kaufen").fadeIn(400);
			OpenShopBuying(msg.result);
		}
	});
});

function OpenShopBuying(items) {
	$(".container-info").html("");

	$.each(items, function (index, item) {
		$(".container-info").append(
			`
			<div class="container-information">
			<h1 class="Item-Name-Logistik2">Shop ID: ${item.ShopNumber}</h1>
			<img
				src="src/outline_house_siding_white_48dp.png"
				class="img-shopbuy"
				alt=""
			/>
			<h1 class="preistxt">Preis:</h1>
			<h1 class="preistxt2">${item.ShopValue}$</h1>
			<h1 class="locationtxt">Location Markieren:</h1>
			<img
				src="src/Screenshot_174.png"
				class="img-location"
				name = ${item.ShopNumber}
				alt=""
			/>
			<button class="Button-BuyShop" name = ${item.ShopNumber}>Shop Kaufen</button>
		</div>
         `
		);
	});
}

$(".kaufen").on("click", ".img-location", function () {
	var $bild = $(this);
	var $id = $bild.attr("name");
	$(".kaufen").hide();
	$.post("http://SevenLife_Shops/location", JSON.stringify({ id: $id }));
});

$(".kaufen").on("click", ".Button-BuyShop", function () {
	var $button = $(this);
	var $id = $button.attr("name");
	$(".kaufen").hide();
	$.post("http://SevenLife_Shops/buyshop", JSON.stringify({ id: $id }));
});

// Logistik
var LebensMittel, BaustellenTeile, Elektronik, Mechaniker;
$("document").ready(function () {
	$(".logistik").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openlogistikmarkt") {
			$(".logistik").show();
			LebensMittel = msg.resulteins;
			BaustellenTeile = msg.resultzwei;
			Elektronik = msg.resultdrei;
			Mechaniker = msg.resultvier;
			InsertIntoTable(LebensMittel);
		} else if (event.data.type === "openlogistikmarkt") {
			$(".logistik").hide();
		}
	});
});
$("#Lebensmittel").click(function () {
	InsertIntoTable(LebensMittel);
});
$("#Baustellen").click(function () {
	InsertIntoTable(BaustellenTeile);
});
$("#Elektronik").click(function () {
	InsertIntoTable(Elektronik);
});
$("#Mechaniker").click(function () {
	InsertIntoTable(Mechaniker);
});
$(".closingse").click(function () {
	$(".logistik").hide("slow");
	$.post("http://SevenLife_Shops/rauses", JSON.stringify({}));
});

function InsertIntoTable(items) {
	$(".insert-container").html("");

	$.each(items, function (index, item) {
		$(".insert-container").append(
			`
			<div class="insert-container-result">
			<h1 class="Item-Name-Logistik">${item.label}</h1>
				<img
					src="src/baseline_category_white_48dp.png"
					class="Item-Picture"
					alt=""
				/>
				<img src="src/${item.label}.png" class="bilds" alt="" />
			<div class="container-informationen">
				<h1 class="Info-Logistik">Preis pro:</h1>
				<h1 class="Info-Logistik">I.Kosten:</h1>
				<h1 class="Info-Logistik2" id="kennzeichen">${item.price}$</h1>
				<h1 class="Info-Logistik2" id="benzin">7$</h1>
			</div>
			<input
				class="Inputt-Logistik"
				id="Inputt-Logistik"
				placeholder="Anzahl"
			/>
			<button class="Button-Buy" name = "${item.label}"  names = "${item.price}">Kaufen</button>
			</div>
			`
		);
	});
}

$(".logistik").on("click", ".Button-Buy", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $count = parseFloat($button.parent().find(".Inputt-Logistik").val());
	var $price = parseFloat($button.attr("names"));
	$(".logistik").hide();
	$.post(
		"http://SevenLife_Shops/makejob",
		JSON.stringify({ name: $name, count: $count, price: $price })
	);
});
function CloseMenu() {
	$(".logistik").hide();
	$(".warenkorb-shop").html(" ");
	$(".kaufen").hide();
	document.getElementById("warenkorb-2").innerHTML = "0" + "$";
	$(".container-shop").hide();
	document.getElementById("warenkorb-2").setAttribute("data-value", "0");
	$.post("http://SevenLife_Shops/rauses", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
