$("document").ready(function () {
	$(".container-wash").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenWaschanlage") {
			$(".container-wash").show();
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-wash").hide();
	$.post("http://SevenLife_CleanUp/CloseMenu", JSON.stringify({}));
}
$(".container-wash").on("click", ".button-down", function () {
	var $button = $(this);

	$(".container-wash").hide();

	$.post("http://SevenLife_CleanUp/makeweasche1", JSON.stringify({}));
});
$(".container-wash").on("click", ".button-down2", function () {
	var $button = $(this);

	$(".container-wash").hide();

	$.post("http://SevenLife_CleanUp/makeweasche2", JSON.stringify({}));
});
$(".container-wash").on("click", ".button-down3", function () {
	var $button = $(this);

	$(".container-wash").hide();

	$.post("http://SevenLife_CleanUp/makeweasche3", JSON.stringify({}));
});
