var maxval;
var colorid;
var idhut;
var idtorso;
var idshirt;
var idhose;
var idschuhe;
var idarme;
$("document").ready(function () {
	$(".maskshop").hide();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".arme").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	//$(".mainpage").hide();
	$(".kleidungsladen").hide();
	$(".outfitpage").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMaskenMenu") {
			$(".maskshop").fadeIn();
			document.getElementById("artikelnummer").innerHTML = 0;
			document.getElementById("artikelnummer2").innerHTML = 0;

			maxval = msg.mAccessory;
			colorid = msg.colorid;
		} else if (event.data.type === "ColorId") {
			colorid = msg.colorid;
		} else if (event.data.type === "OpenKleidungsladenMenu") {
			idhut = msg.idhut;
			idtorso = msg.idtorso;
			idshirt = msg.idshirt;
			idhose = msg.idhose;
			idschuhe = msg.idarme;
			idarme = msg.irarme;
			$(".kleidungsladen").fadeIn();
			$(".mainpage").show();
		} else if (event.data.type === "MakeOutfits") {
			MakeOutfits(msg.result);
		}
	});
});

$(".button-lagerleft1").click(function () {
	var value = $("#artikelnummer").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummer").innerHTML = maxval;
	} else {
		document.getElementById("artikelnummer").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummer").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticle",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$(".button-lagerright1").click(function () {
	var value1 = $("#artikelnummer").text();
	var value2 = parseInt(value1);
	if (value1 > maxval) {
		document.getElementById("artikelnummer").innerHTML = 0;
	} else {
		document.getElementById("artikelnummer").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummer").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticle",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$(".button-lagerleft2").click(function () {
	var value = $("#artikelnummer2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummer2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummer2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummer2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticle2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$(".button-lagerright2").click(function () {
	var value1 = $("#artikelnummer2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummer2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummer2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummer2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticle2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".maskshop").hide();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	$(".kleidungsladen").hide();
	$(".outfitpage").hide();
	$.post("http://SevenLife_KleidungsLaden/CloseMenu", JSON.stringify({}));
}

$(".button-lager").click(function () {
	var endvalue1 = $("#artikelnummer").text();
	var endvalue2 = $("#artikelnummer2").text();
	$(".maskshop").hide();
	$.post(
		"http://SevenLife_KleidungsLaden/BuyProdukt",
		JSON.stringify({ value1: endvalue1, value2: endvalue2 })
	);
});
// Switch to other site

$("#hut").click(function () {
	$(".hut").show();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".arme").hide();
});

$("#torso").click(function () {
	$(".hut").hide();
	$(".torso").show();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".arme").hide();
});
$("#shirt").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").show();
	$(".pants").hide();
	$(".shoes").hide();
	$(".arme").hide();
});
$("#hose").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").show();
	$(".shoes").hide();
	$(".arme").hide();
});
$("#schuhe").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").show();
	$(".arme").hide();
});
$("#arme").click(function () {
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".arme").show();
});
// Anwenden

$("#buttonanwendenhut").click(function () {
	var endvalue1 = $("#artikelnummerhut1").text();
	var endvalue2 = $("#artikelnummerhut2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Kopfbede #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});

$("#buttonanwendentorso").click(function () {
	var endvalue1 = $("#artikelnummertorso1").text();
	var endvalue2 = $("#artikelnummertorso2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Torso #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});

$("#buttonanwendenshirt").click(function () {
	var endvalue1 = $("#artikelnummershirt1").text();
	var endvalue2 = $("#artikelnummershirt2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">T-Shirt #${endvalue1}</h1>
			<h1 class="zahlen">100$</h1>
		</div>
		`
	);
});

$("#buttonanwendenhose").click(function () {
	var endvalue1 = $("#artikelnummerhose1").text();
	var endvalue2 = $("#artikelnummerhose2").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Hose #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});

$("#buttonanwendenschuhe").click(function () {
	var endvalue1 = $("#artikelnummerschuhe1").text();
	var endvalue2 = $("#artikelnummerschuhe1").text();
	var costs = 100;
	var $price = parseFloat(costs);
	var $realprice = $price;
	var $realprices = 1.07 * $realprice;
	var $oldprice = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	var price = parseInt($realprices);
	var oldprice = parseInt($oldprice);
	var $newprice = oldprice + price;
	document.getElementById("preistotal").setAttribute("data-value", $newprice);
	document.getElementById("preistotal").innerHTML = "$" + $newprice;
	$(".listofitems").append(
		`
		<div class="container-item" value1 = ${endvalue1} value2 = ${endvalue2} costs = ${costs}>
			<h1 class="kleidungid">Schuhe #${endvalue1}</h1>
			<h1 class="zahlen">${$realprices}$</h1>
		</div>
		`
	);
});
// Buttons Hut

$("#buttonhutleft1").click(function () {
	var value = $("#artikelnummerhut1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhut1").innerHTML = idhut;
	} else {
		document.getElementById("artikelnummerhut1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhut1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHut1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonhutright1").click(function () {
	var value1 = $("#artikelnummerhut1").text();
	var value2 = parseInt(value1);
	if (value1 > idhut) {
		document.getElementById("artikelnummerhut1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhut1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhut1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHut1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonhutleft2").click(function () {
	var value = $("#artikelnummerhut2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhut2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummerhut2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhut2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHut2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonhutright2").click(function () {
	var value1 = $("#artikelnummerhut2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummerhut2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhut2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhut2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHut2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons Torso

$("#buttontorsoleft1").click(function () {
	var value = $("#artikelnummertorso1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummertorso1").innerHTML = idtorso;
	} else {
		document.getElementById("artikelnummertorso1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummertorso1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleTorso1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttontorsoright1").click(function () {
	var value1 = $("#artikelnummertorso1").text();
	var value2 = parseInt(value1);
	if (value1 > idtorso) {
		document.getElementById("artikelnummertorso1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummertorso1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummertorso1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleTorso1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttontorsoleft2").click(function () {
	var value = $("#artikelnummertorso2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummertorso2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummertorso2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummertorso2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleTorso2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttontorsoright2").click(function () {
	var value1 = $("#artikelnummertorso2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummertorso2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummertorso2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummertorso2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleTorso2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons Shirt

$("#buttonshirtleft1").click(function () {
	var value = $("#artikelnummershirt1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummershirt1").innerHTML = idshirt;
	} else {
		document.getElementById("artikelnummershirt1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummershirt1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleShirt1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonshirtright1").click(function () {
	var value1 = $("#artikelnummershirt1").text();
	var value2 = parseInt(value1);
	if (value1 > idshirt) {
		document.getElementById("artikelnummershirt1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummershirt1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummershirt1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleShirt1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonshirtleft2").click(function () {
	var value = $("#artikelnummershirt2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummershirt2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummershirt2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummershirt2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleShirt2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonshirtright2").click(function () {
	var value1 = $("#artikelnummershirt2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummershirt2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummershirt2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummershirt2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleShirt2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons hose

$("#buttonhoseleft1").click(function () {
	var value = $("#artikelnummerhose1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhose1").innerHTML = idhose;
	} else {
		document.getElementById("artikelnummerhose1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhose1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHose1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonhoseright1").click(function () {
	var value1 = $("#artikelnummerhose1").text();
	var value2 = parseInt(value1);
	if (value1 > idhose) {
		document.getElementById("artikelnummerhose1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhose1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhose1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHose1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonhoseleft2").click(function () {
	var value = $("#artikelnummerhose2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerhose2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummerhose2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerhose2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHose2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonhoseright2").click(function () {
	var value1 = $("#artikelnummerhose2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummerhose2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerhose2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerhose2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleHose2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Buttons Schuhe

$("#buttonschuheleft1").click(function () {
	var value = $("#artikelnummerschuhe1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerschuhe1").innerHTML = idschuhe;
	} else {
		document.getElementById("artikelnummerschuhe1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerschuhe1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleSchuhe1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonschuheright1").click(function () {
	var value1 = $("#artikelnummerschuhe1").text();
	var value2 = parseInt(value1);
	if (value1 > idschuhe) {
		document.getElementById("artikelnummerschuhe1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerschuhe1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerschuhe1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleSchuhe1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

$("#buttonschuheleft2").click(function () {
	var value = $("#artikelnummerschuhe2").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerschuhe2").innerHTML = colorid;
	} else {
		document.getElementById("artikelnummerschuhe2").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerschuhe2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleSchuhe2",
		JSON.stringify({ endvalue2: endvalue2 })
	);
});

$("#buttonschuheright2").click(function () {
	var value1 = $("#artikelnummerschuhe2").text();
	var value2 = parseInt(value1);
	if (value1 > colorid) {
		document.getElementById("artikelnummerschuhe2").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerschuhe2").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerschuhe2").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleSchuhe2",
		JSON.stringify({ endvalue2: endvalue1 })
	);
});

// Arme

$("#buttonarmeleft1").click(function () {
	var value = $("#artikelnummerarme1").text();
	var values = parseInt(value);
	if (values < 0) {
		document.getElementById("artikelnummerarme1").innerHTML = idarme;
	} else {
		document.getElementById("artikelnummerarme1").innerHTML = values - 1;
	}

	var endvalue2 = $("#artikelnummerarme1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleArme1",
		JSON.stringify({ endvalue1: endvalue2 })
	);
});

$("#buttonarmeright1").click(function () {
	var value1 = $("#artikelnummerarme1").text();
	var value2 = parseInt(value1);
	if (value1 > idarme) {
		document.getElementById("artikelnummerarme1").innerHTML = 0;
	} else {
		document.getElementById("artikelnummerarme1").innerHTML = value2 + 1;
	}

	var endvalue1 = $("#artikelnummerarme1").text();
	$.post(
		"http://SevenLife_KleidungsLaden/MakeArticleArme1",
		JSON.stringify({ endvalue1: endvalue1 })
	);
});

// Kauf Button

$(".buttonkaufen").click(function () {
	$(".kleidungsladen").hide();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	var preis = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	$(".listofitems").html(" ");
	document.getElementById("preistotal").innerHTML = "$0";
	document.getElementById("preistotal").setAttribute("data-value", "0");
	$.post(
		"http://SevenLife_KleidungsLaden/PayForOutfit",
		JSON.stringify({ preis: preis })
	);
});

// Save Button

$(".buttonspeichern").click(function () {
	$(".saveoutifit").show();
});

$(".buttonabbrechen").click(function () {
	$(".saveoutifit").hide();
	document.getElementById("inputtsoutfit").value = "";
});

$(".buttonspeichern2").click(function () {
	$(".saveoutifit").hide();
	CloseAll();
	var preis = document
		.getElementById("preistotal")
		.getAttribute("data-value");
	$(".listofitems").html(" ");
	document.getElementById("preistotal").innerHTML = "$0";
	document.getElementById("preistotal").setAttribute("data-value", "0");
	var $inputt = document.getElementById("inputtsoutfit").value;
	var cleanstring = $inputt.replace(/[^a-zA-Z ]/g, "");

	if (isEmpty(cleanstring)) {
		$.post("http://SevenLife_KleidungsLaden/Error", JSON.stringify({}));
	} else {
		$.post(
			"http://SevenLife_KleidungsLaden/SaveOutfitandPay",
			JSON.stringify({ preis: preis, input: cleanstring })
		);
	}
});

function isEmpty(value) {
	return value == null || value.length === 0;
}

$(".buttonoutfits").click(function () {
	$(".mainpage").hide();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	$(".outfitpage").show();
	$.post("http://SevenLife_KleidungsLaden/GetOutfits", JSON.stringify({}));
});

$(".buttonzurück").click(function () {
	$(".mainpage").show();
	$(".hut").hide();
	$(".torso").hide();
	$(".shirt").hide();
	$(".pants").hide();
	$(".shoes").hide();
	$(".saveoutifit").hide();
	$(".outfitpage").hide();
});

function MakeOutfits(items) {
	$(".container-outfit").html("");
	$.each(items, function (index, item) {
		$(".container-outfit").append(
			`
			<div class="container-innerercontainer" name = ${item.outfitname} model = ${item.model} skin = ${item.skin} outfitId = ${item.outfitId}>
			    <h1 class="outfittext">${item.outfitname} </h1>
			    <button
				  type="button"
				  id="buttondelete"
				  class="buttondelete"
			      name = ${item.outfitname} 
				  model = ${item.model} 
				  skin = ${item.skin} 
				  outfitId = ${item.outfitId}
			    >
				<img
					src="src/outline_delete_white_36dp.png"
					class="bildimgage"
					alt=""
				/>
			   </button>
		    </div>
             `
		);
	});
}

$(".outfitpage").on("click", ".buttondelete", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $model = $button.attr("model");
	var $skin = $button.attr("skin");
	var $outfitId = $button.attr("outfitId");
	CloseAll();
	$.post(
		"http://SevenLife_KleidungsLaden/DeleteOutfit",
		JSON.stringify({
			name: $name,
			model: $model,
			skin: $skin,
			outfitId: $outfitId,
		})
	);
});

$(".outfitpage").on("click", ".container-innerercontainer", function () {
	var $button = $(this);
	var $name = $button.attr("name");
	var $model = $button.attr("model");
	var $skin = $button.attr("skin");
	var $outfitId = $button.attr("outfitId");
	$.post(
		"http://SevenLife_KleidungsLaden/ShowOutfit",
		JSON.stringify({
			name: $name,
			model: $model,
			skin: $skin,
			outfitId: $outfitId,
		})
	);
});
$(document).keydown(function (e) {
	if (e.key === "d") {
		$.post(
			"http://SevenLife_KleidungsLaden/rotationleft",
			JSON.stringify({ value: -5 })
		);
	}
});
$(document).keydown(function (e) {
	if (e.key === "a") {
		$.post(
			"http://SevenLife_KleidungsLaden/rotationright",
			JSON.stringify({ value: 5 })
		);
	}
});
