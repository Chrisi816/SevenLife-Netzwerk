$(".dispatch").click(function () {
	$.post("http://SevenLife_Phone/GetActivDispatches", JSON.stringify({}));
});
$(".großkreismitte2").click(function () {
	document.getElementById("writeadispatch").style.animation =
		"fadeInBottom 1s ";
	document.getElementById("writeadispatch").style.removeProperty("display");
});

$(".dispachbarunten").click(function () {
	document.getElementById("writeadispatch").style.display = "none";
	$(".dispatchapp").hide();
});

$(".dispatchapp").on("click", ".button-senddispatch", function () {
	document.getElementById("writeadispatch").style.animation =
		"fadeOutBottom 1s ";
	setTimeout(function () {
		document.getElementById("writeadispatch").style.display = "none";
	}, 900);
	var frak = $(".selectfraktion option:selected").text();
	var titel = document.getElementById("inputttiteldispatch").value;
	var desc = document.getElementById("iputt-descriptiondispatch").value;
	$(".scroll-dispatch").prepend(
		`
			<div class="container-dispatchstatus">
				<div class="box-container-info">
					<img
					src="../src/tools/info.png"
					class="infozeichen"
					alt=""
					/>
				</div>
				<h1 class="text-dispach">${titel}</h1>
				<h1 class="infotextdispatch">
					${desc}
				</h1>
				<h1 class="statustext2">Nicht Angenommen</h1>
				<h1 class="InfoFraktion">${frak}</h1>
			</div>
		`
	);
	$.post(
		"http://SevenLife_Phone/SendDispatch",
		JSON.stringify({ frak: frak, titel: titel, desc: desc })
	);
});

$(".backdispatchhaupt").click(function () {
	document.getElementById("writeadispatch").style.animation =
		"fadeOutBottom 1s ";
	setTimeout(function () {
		document.getElementById("writeadispatch").style.display = "none";
	}, 900);
});

$(".sekonddispatchbox").click(function () {
	$(".frontpage-alldispatches").hide();
	$(".fraktionen-seite").show();
});

$(".firstdispatchbox").click(function () {
	$(".frontpage-alldispatches").show();
	$(".fraktionen-seite").hide();
});
