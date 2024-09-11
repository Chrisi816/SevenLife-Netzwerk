$("document").ready(function () {
	$(".esseninteraktionsmenu").hide();
	$(".container-hilfe").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenMenuGolfBall") {
			$(".esseninteraktionsmenu").show();
			activepfeiltastenessen = true;
			if ($(".selected").length === 0) {
				$(".boxinter2").first().addClass("focus");
				$(".boxinter2 div").first().addClass("selected").focus();
			}
		} else if (event.data.type === "OpenHelp") {
			$(".container-hilfe").show();
		} else if (event.data.type === "RemoveHelp") {
			$(".container-hilfe").hide();
		}
	});
});

document.onkeydown = function (e) {
	switch (e.keyCode) {
		case 38:
			moveUpEssenInteraktion();
			break;
		case 40:
			moveDownEssenInteraktion();
			break;
		case 13:
			$(".esseninteraktionsmenu").hide();
			var box = $(".selected");
			var action = box.attr("typeofaction");

			$.post(
				"https://SevenLife_Golf/MakeActionBealle",
				JSON.stringify({ action: action })
			);

			activepfeiltastenessen = false;
	}
};

function moveUpEssenInteraktion() {
	if ($(".selected").prev("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.prev("div")
			.addClass("selected")
			.focus();
	}
}

function moveDownEssenInteraktion() {
	if ($(".selected").next("div").length > 0) {
		$(".selected")
			.removeClass("selected")
			.next("div")
			.addClass("selected")
			.focus();
	}
}
