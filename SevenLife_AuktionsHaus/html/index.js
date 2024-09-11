var plate;
var type;
var all;
var names;
var label;
$("document").ready(function () {
	$(".container-auktionshaus").hide();
	$(".verkaufenpage").hide();
	//$(".mainpage").hide();
	$(".pageseeall").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "OpenAuktion") {
			$(".container-auktionshaus").show();
			all = msg.result;
			InsertAuktionData(msg.result, msg.zeit);
		} else if (event.data.type === "UpdateAktion") {
			all = msg.result;
			InsertAuktionData(msg.result, msg.zeit);
		} else if (event.data.type === "UpdateCars") {
			MakeCars(msg.model, msg.plate, msg.vehicleid);
		} else if (event.data.type === "UpdateItems") {
			MakeItems(msg.items);
		} else if (event.data.type === "MakeShops") {
			MakeShops(msg.items);
		} else if (event.data.type === "MakeTankstellen") {
			MakeTankstellen(msg.items);
		} else if (event.data.type === "UpdateGebote") {
			MakeGebote(msg.deineangebote, msg.deinegebote);
			$(".pageseeall").show();
			$(".verkaufenpage").hide();
			$(".mainpage").hide();
		} else if (event.data.type === "UpdateGebote2") {
			MakeGebote(msg.deineangebote, msg.deinegebote);
			$(".scrollcontainerdeinegebote").html(" ");
			$(".scrollcontainerdeineangebote").html(" ");
		}
	});
});

function InsertAuktionData(items, zeit) {
	$(".container-start").html("");

	$.each(items, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.sofort == false) {
				$(".container-start").append(
					`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
				);
			} else {
				$(".container-start").append(
					`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
				);
			}
		}
	});
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".container-auktionshaus").hide();
	$.post("https://SevenLife_AuktionsHaus/Escape");
}
$("#all").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.sofort == false) {
				$(".container-start").append(
					`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
				);
			} else {
				$(".container-start").append(
					`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
				);
			}
		}
	});
});
$("#cars").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "cars") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});
$("#boats").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "boats") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});
$("#fly").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "fly") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});
$("#items").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "items") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop"  attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});
$("#shops").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "shops") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter} </h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});
$("#fuel").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "fuel") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter}</h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop"  attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter}</h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});
$("#hauses").click(function () {
	$(".container-start").html("");

	$.each(all, function (index, item) {
		if (item.endezeit !== "abgeschlossen") {
			if (item.kategorie == "hauses") {
				if (item.sofort == false) {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter}</h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "bieten" id="bieten" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Mit Bieten</button>
                </div>
             `
					);
				} else {
					$(".container-start").append(
						`
                <div class="container-auction">
                        <div class="bild-auction">
                            <img src="src/${item.inhalt}.png" class="img-item" alt="">
                        </div>
                        <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                        <div class="underlinestrich2"></div>
                        <h1 class="akutellercountbieter">Gebote: ${item.bieter}</h1>
                        <div class="underlinestrich3"></div>	
                        <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
                        <div class="underlinestrich4"></div>
                        <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                        <div class="underlinestrich"></div>
                        <h1 class="längederAuktion">Auktion endet um: ${item.endezeit}</h1>
                        <button class="Button-BuyShop" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Sofort Kaufen</button>
                </div>
             `
					);
				}
			}
		}
	});
});

$("#verkaufenpage").click(function () {
	$(".mainpage").hide();
	$(".verkaufenpage").show();
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetCars");
});
$("#homepage").click(function () {
	$(".mainpage").show();
	$(".pageseeall").hide();
	$(".verkaufenpage").hide();
});
$("#homepages").click(function () {
	$(".mainpage").show();
	$(".pageseeall").hide();
	$(".verkaufenpage").hide();
});

function MakeCars(model, plate, vehicleid) {
	document.getElementById("text-impounder4").innerHTML =
		"Auktion - Fahrzeuge";
	$(".containerauto").append(
		`
                <div class="container-impunder-containing">
								
								<h1 class="carname-impounder">${model}</h1>
								<h1 class="info-impounder">Kennzeichen:</h1>

								<h1 class="info-impounder2" id="kennzeichen">
									${plate}
								</h1>

								<button class="button-downs" name="${plate}" names = "${vehicleid}"type = "cars">
									Auswählen
								</button>
							</div>
             `
	);
}
$("#cars2").click(function () {
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetCars");
});
$("#boats2").click(function () {
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetBoote");
});
$("#fly2").click(function () {
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetFlugzeuge");
});
$("#items2").click(function () {
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetItems");
});
$("#shops2").click(function () {
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetShops");
});
$("#fuel2").click(function () {
	$(".containerauto").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetTanke");
});

$(".verkaufenpage").on("click", ".button-downs", function () {
	var $box = $(this);
	var $plate = $box.attr("name");
	var $type = $box.attr("type");
	var $names = $box.attr("names");
	var $label = $box.attr("label");

	plate = $plate;
	type = $type;
	names = $names;
	label = $label;
	count = 1;
});

$(".verkaufenpage").on("click", "#Veröffentlichen", function () {
	var $box = $(this);
	$(".mainpage").show();
	$(".verkaufenpage").hide();
	var choice = $(".selectfraktion option:selected").text();
	var zeit = $(".selectfraktion2 option:selected").text();
	var preis = document.getElementById("Inputt-PaymentStart").value;
	var choicenumber;
	if (choice == "Auktion") {
		choicenumber = false;
	} else if (choice == "Sofort Kauf") {
		choicenumber = true;
	}

	if (zeit == "1h") {
		zeitnumber = 1;
	} else if (zeit == "2h") {
		zeitnumber = 2;
	} else if (zeit == "3h") {
		zeitnumber = 3;
	} else if (zeit == "4h") {
		zeitnumber = 4;
	} else if (zeit == "5h") {
		zeitnumber = 5;
	} else if (zeit == "6h") {
		zeitnumber = 6;
	} else if (zeit == "12h") {
		zeitnumber = 7;
	} else if (zeit == "24h") {
		zeitnumber = 8;
	}

	$.post(
		"https://SevenLife_AuktionsHaus/MakeAuktion",
		JSON.stringify({
			choice: choicenumber,
			zeit: zeitnumber,
			preis: preis,
			type: type,
			plate: plate,
			count: count,
			vehicleid: names,
			label: label,
		})
	);
});
function MakeItems(alls) {
	document.getElementById("text-impounder4").innerHTML = "Auktion - Items";
	$.each(alls, function (index, item) {
		$(".containerauto").append(
			`
            <div class="container-impunder-containing">
								
            <h1 class="carname-impounder">${item.label}</h1>
            <h1 class="info-impounder">Anzahl:</h1>

            <h1 class="info-impounder2" id="kennzeichen">
                ${item.count}
            </h1>

            <button class="button-downs" name="${item.name}" label = "${item.label}" type = "items">
                Auswählen
            </button>
        </div>
             `
		);
	});
}
function MakeShops(alls) {
	document.getElementById("text-impounder4").innerHTML = "Auktion - Shops";
	$.each(alls, function (index, item) {
		$(".containerauto").append(
			`
            <div class="container-impunder-containing">
								
            <h1 class="carname-impounder">${item.ShopName}</h1>
            <h1 class="info-impounder">ID:</h1>

            <h1 class="info-impounder2" id="kennzeichen">
                ${item.ShopNumber}
            </h1>

            <button class="button-downs" name="${item.ShopNumber}" type = "shops">
                Auswählen
            </button>
        </div>
             `
		);
	});
}

function MakeTankstellen(alls) {
	document.getElementById("text-impounder4").innerHTML =
		"Auktion - Tankstellen";
	$.each(alls, function (index, item) {
		$(".containerauto").append(
			`
            <div class="container-impunder-containing">
								
            <h1 class="carname-impounder">${item.firmenname}</h1>
            <h1 class="info-impounder">ID:</h1>

            <h1 class="info-impounder2" id="kennzeichen">
                ${item.tankstellennummer}
            </h1>

            <button class="button-downs" name="${item.tankstellennummer}" type = "fuel">
                Auswählen
            </button>
        </div>
             `
		);
	});
}
$(".mainpage").on("click", ".Button-BuyShop", function () {
	var $box = $(this);
	var typing = $box.attr("attr");
	var preis = $box.attr("preis");
	var label = $box.attr("label");
	var count = $box.attr("count");
	var id = $box.attr("name");
	if (typing == "bieten") {
		$.post(
			"https://SevenLife_AuktionsHaus/BieteMit",
			JSON.stringify({ id: id, count: count, label: label, preis: preis })
		);
	} else if (typing == "kaufen") {
		$.post(
			"https://SevenLife_AuktionsHaus/SofortKauf",
			JSON.stringify({
				id: id,
				count: count,
				label: label,
				preis: preis,
			})
		);
	}
});
$("#alleauktionensehen").click(function () {
	$(".scrollcontainerdeinegebote").html(" ");
	$(".scrollcontainerdeineangebote").html(" ");
	$.post("https://SevenLife_AuktionsHaus/GetAngebote");
});
function MakeGebote(eins, zwei) {
	$.each(eins, function (index, item) {
		$(".scrollcontainerdeineangebote").append(
			`
            <div class="container-auction2">
            <div class="bild-auction">
                <img
                    src="src/${item.inhalt}.png"
                    class="img-item"
                    alt=""
                />
            </div>
            <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
            <div class="underlinestrich2"></div>
            <h1 class="akutellercountbieter">
                Gebote: ${item.bieter}
            </h1>
            <div class="underlinestrich3"></div>
            <h1 class="akutellerstartpreis">
                Startpreis: ${item.startpreis}$
            </h1>
            <div class="underlinestrich4"></div>
            <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
            <div class="underlinestrich"></div>
            <h1 class="längederAuktion">
                Auktion endet um: ${item.endezeit}
            </h1>
        </div>
             `
		);
	});
	$.each(zwei, function (index, item) {
		if (item.endezeit === "abgeschlossen") {
			$(".scrollcontainerdeinegebote").append(`
            <div class="container-auction2">
            <div class="bild-auction">
                <img src="src/${item.inhalt}.png" class="img-item" alt="">
            </div>
            <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
            <div class="underlinestrich2"></div>
            <h1 class="akutellercountbieter">Gebote: ${item.bieter}</h1>
            <div class="underlinestrich3"></div>	
            <h1 class="akutellerstartpreis">Startpreis: ${item.startpreis}$</h1>
            <div class="underlinestrich4"></div>
            <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
            <div class="underlinestrich"></div>
           
            <button class="Button-BuyShop2" attr = "kaufen" id="kaufen" preis = "${item.endpreis}" label = "${item.label}" count = "${item.count}" name="${item.id}">Abholen</button>
            </div>
         `);
		} else {
			$(".scrollcontainerdeinegebote").append(
				`
                <div class="container-auction2">
                <div class="bild-auction">
                    <img
                        src="src/${item.inhalt}.png"
                        class="img-item"
                        alt=""
                    />
                </div>
                <h1 class="akutellercount">Preis: ${item.endpreis}$</h1>
                <div class="underlinestrich2"></div>
                <h1 class="akutellercountbieter">
                    Gebote: ${item.bieter}
                </h1>
                <div class="underlinestrich3"></div>
                <h1 class="akutellerstartpreis">
                    Startpreis: ${item.startpreis}$
                </h1>
                <div class="underlinestrich4"></div>
                <h1 class="namederauktion">Inhalt: ${item.inhalt}</h1>
                <div class="underlinestrich"></div>
                <h1 class="längederAuktion">
                    Auktion endet um: ${item.endezeit}
                </h1>
            </div>
                 `
			);
		}
	});
}
$(".pageseeall").on("click", ".Button-BuyShop2", function () {
	var $box = $(this);

	var preis = 0;
	var label = $box.attr("label");
	var count = $box.attr("count");
	var id = $box.attr("name");

	$.post(
		"https://SevenLife_AuktionsHaus/SofortKauf2",
		JSON.stringify({
			id: id,
			count: count,
			label: label,
			preis: preis,
		})
	);
});
