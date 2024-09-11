$("document").ready(function () {
	$(".container").hide();
	$(".container-warnung").hide();
	$(".container-auftrag").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openmailoffice") {
			$(".container").fadeIn(200);
			if (msg.numberofmail === undefined) {
				document.getElementById("paketenumber").innerHTML = "Pakete 0";
			} else {
				document.getElementById("paketenumber").innerHTML =
					"Pakete " + msg.numberofmail;
			}
			displaymails(msg.mails);
		} else if (event.data.type === "OpenWarnung") {
			$(".container-warnung").show();
		} else if (event.data.type === "OpenMainMenuPostal") {
			$(".container-auftrag").show();
		}
	});
});
function displaymails(items) {
	$(".container-box").html("");
	$.each(items, function (index, item) {
		$(".container-box").append(
			`
 
             
          <div class="container-nachricht" >
             <img src="src/baseline_email_white_36dp.png" class ="mail-bild" alt="">
               <div class="text-absender">
                Abesender: ${item.name}
               </div>
               <button class="button fortnite" itemname = "${item.things}" number = "${item.number}" name = "${item.name}" toid = ${item.toidentifer} id = ${item.id} >Abholen</button>
             
          </div>
             `
		);
	});
}
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container").hide();
	$(".container-warnung").hide();
	$(".container-auftrag").hide();
	$.post("http://SevenLife_Postal/CloseMenu", JSON.stringify({}));
	$.post("http://SevenLife_Postal/ClosePostal", JSON.stringify({}));
}

$(".container").on("click", ".fortnite", function () {
	var $button = $(this);
	$(".container").hide();
	var item = $button.attr("itemname");
	var number = $button.attr("number");
	var name = $button.attr("name");
	var toid = $button.attr("toid");
	var id = $button.attr("id");
	$.post("http://SevenLife_Postal/CloseMenu", JSON.stringify({}));
	$.post(
		"http://SevenLife_Postal/giveitem",
		JSON.stringify({
			item: item,
			number: number,
			name: name,
			toid: toid,
			id: id,
		})
	);
});
$("#abbrechen").click(function () {
	$(".container-warnung").hide();
	$.post("http://SevenLife_Postal/ClosePostal", JSON.stringify({}));
});
$("#weiter").click(function () {
	$(".container-warnung").hide();
	$.post("http://SevenLife_Postal/GivePedJob", JSON.stringify({}));
});
$("#loslegen").click(function () {
	$(".container-warnung").hide();
	$(".container-auftrag").hide();
	var value = document.getElementById("inputte").value;

	$.post(
		"http://SevenLife_Postal/LetsStartJob",
		JSON.stringify({ value: value })
	);
});
