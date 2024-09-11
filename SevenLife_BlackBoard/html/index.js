$("document").ready(function () {
	$(".container-board").hide();
	$(".startmatch").hide();
	$(".seveninfo").hide();
	$(".imginfo").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;

		if (event.data.type === "OpenTafel") {
			$(".container-board").fadeIn(500);
			InsertData(msg.result);
		} else if (event.data.type === "OpenAuswahlMenu") {
			$(".startmatch").show();
		} else if (event.data.type === "OpenNormalMenu") {
			$(".seveninfo").fadeIn(500);
		} else if (event.data.type === "OpenImgMenu") {
			$(".imginfo").show();
		}
	});
});

function InsertData(plakate) {
	$(".container-scroll").html(" ");
	$.each(plakate, function (index, item) {
		if (item.imgfrage == 1) {
			$(".container-scroll").append(
				`
				<div class="blatt">
					<div class="card">
						<h1 class="textüberschrift">${item.titel}</h1>
						<h1 class="überschrift2"></h1>
						<h1 class="textbeschreibung">
							${item.description}
						</h1>
					</div>
				</div>
				 `
			);
		} else {
			$(".container-scroll").append(
				`
			<div class="blatt">
				<div class="card">
					<img src="${item.src}" class="imginit" alt="" />
				</div>
			</div>
			 `
			);
		}
	});
}
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".container-board").hide();
	$.post("https://SevenLife_BlackBoard/Escape");
}
$(".container-board").on("click", ".btn", function () {
	var $button = $(this);

	$(".container-board").hide();
	$.post("https://SevenLife_BlackBoard/OpenEditor", JSON.stringify({}));
});
$(".startmatch").on("click", "#startbild", function () {
	var $button = $(this);

	$(".startmatch").hide();
	$.post(
		"https://SevenLife_BlackBoard/OpenEditorBoard",
		JSON.stringify({ id: 2 })
	);
});
$(".startmatch").on("click", "#startposter", function () {
	var $button = $(this);

	$(".startmatch").hide();
	$.post(
		"https://SevenLife_BlackBoard/OpenEditorBoard",
		JSON.stringify({ id: 1 })
	);
});
$("#akzeptieren").click(function () {
	$(".seveninfo").hide();
	var titel = document.getElementById("iputt-titel").value;
	var beschreibung = document.getElementById("iputt-beschreibung").value;
	$.post(
		"https://SevenLife_BlackBoard/Finish",
		JSON.stringify({
			beschreibung: beschreibung,
			titel: titel,
		})
	);
});
$("#akzeptierenimg").click(function () {
	$(".imginfo").hide();
	var src = document.getElementById("iputt-beschreibung2").value;
	$.post(
		"https://SevenLife_BlackBoard/Finish2",
		JSON.stringify({
			src: src,
		})
	);
});
