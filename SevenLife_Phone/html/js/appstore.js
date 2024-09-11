$(".button-submit-middel").click(function () {
	$(".firstscreen").hide();
	$(".hauptscreen").show();
});

$(".appstores").click(function () {
	$.post("http://SevenLife_Phone/GetAppDataShopping", JSON.stringify({}));
});

$(".back-appstore").click(function () {
	$(".appstore").hide();
});

$("#sections1").click(function () {
	$(".hauptseitenhaupt").show();
	$(".allappsdownload").hide();
	$(".installedapps").hide();
});

$("#sections2").click(function () {
	$(".hauptseitenhaupt").hide();
	$(".allappsdownload").show();
	$(".installedapps").hide();
});

$("#sections3").click(function () {
	$(".hauptseitenhaupt").hide();
	$(".installedapps").show();
	$(".allappsdownload").hide();
});

$(".appstore").on("click", ".container-downloadbutton", function () {
	var $button = $(this);
	var $appname = $button.attr("name");

	$button.hide();
	if ($appname === "Garage") {
		$(".garage").show();
	} else if ($appname === "Twitter") {
	} else if ($appname === "Crypto") {
		$(".crypto").show();
	} else if ($appname === "LiveInvader") {
		$(".lifeinvader").show();
	} else if ($appname === "Notizen") {
		$(".notizen").show();
	}
	setTimeout(function () {
		$button.show();
		$.post(
			"http://SevenLife_Phone/DownLoadApp",
			JSON.stringify({ name: $appname })
		);
	}, 5000);
});

$(".appstore").on("click", ".container-downloadbutton1", function () {
	var $button = $(this);
	var $appname = $button.attr("name");

	if ($appname === "Garage") {
		$(".garage").hide();
	} else if ($appname === "Twitter") {
	} else if ($appname === "Crypto") {
		$(".crypto").hide();
	} else if ($appname === "LiveInvader") {
		$(".lifeinvader").hide();
	}
	$button.hide();

	setTimeout(function () {
		$button.show();
		$button.parent().hide();
		$.post(
			"http://SevenLife_Phone/DeleteApp",
			JSON.stringify({ name: $appname })
		);
	}, 5000);
});
