var station = 0;
var stage = 0;
$("document").ready(function () {
	$(".container-busfahrer").hide();

	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenNui") {
			var stage = 0;
			$(".container-busfahrer").fadeIn(200);
			$(".container-busfahrerrufen").html("");
			$.each(msg.description, function (index, item) {
				stage++;
				if (stage === 1) {
					$(".container-busfahrerrufen").append(`
					<div class="container-buscontainer station1">
						 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
						 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
					 </div>
				 `);
				} else if (stage === 2) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station2">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 3) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station3">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 4) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station4">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 5) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station5">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 6) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station6">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 7) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station7">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 8) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station8">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 9) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station9">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				} else if (stage === 10) {
					$(".container-busfahrerrufen").append(`
				<div class="container-buscontainer station10">
					 <h1 class="textwhere">${item.name}: Preis: ${item.preis}$</h1>
					 <h1 class="entfernung">Entfernung: ${item.desc}Km</h1>
				 </div>
			 `);
				}
			});
		}
	});
});

$(".container-busfahrer").on("click", ".station1", function () {
	$(".marker1").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 1;
});

$(".container-busfahrer").on("click", ".station2", function () {
	$(".marker2").addClass("active");
	$(".marker1").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 2;
});

$(".container-busfahrer").on("click", ".station3", function () {
	$(".marker3").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 3;
});

$(".container-busfahrer").on("click", ".station4", function () {
	$(".marker4").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 4;
});

$(".container-busfahrer").on("click", ".station5", function () {
	$(".marker5").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 5;
});
$(".container-busfahrer").on("click", ".station6", function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").addClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 6;
});
$(".container-busfahrer").on("click", ".station7", function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").addClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 7;
});
$(".container-busfahrer").on("click", ".station8", function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").addClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 8;
});
$(".container-busfahrer").on("click", ".station9", function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").addClass("active");
	$(".marker10").removeClass("active");
	station = 9;
});
$(".container-busfahrer").on("click", ".station10", function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").addClass("active");
	station = 10;
});
$(".marker1").click(function () {
	$(".marker1").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 1;
});

$(".marker2").click(function () {
	$(".marker2").addClass("active");
	$(".marker1").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 2;
});

$(".marker3").click(function () {
	$(".marker3").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 3;
});

$(".marker4").click(function () {
	$(".marker4").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker5").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 4;
});

$(".marker5").click(function () {
	$(".marker5").addClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 5;
});
$(".marker6").click(function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").addClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 6;
});
$(".marker7").click(function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").addClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 7;
});
$(".marker8").click(function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").addClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").removeClass("active");
	station = 8;
});
$(".marker9").click(function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").addClass("active");
	$(".marker10").removeClass("active");
	station = 9;
});
$(".marker10").click(function () {
	$(".marker5").removeClass("active");
	$(".marker2").removeClass("active");
	$(".marker3").removeClass("active");
	$(".marker4").removeClass("active");
	$(".marker1").removeClass("active");
	$(".marker6").removeClass("active");
	$(".marker7").removeClass("active");
	$(".marker8").removeClass("active");
	$(".marker9").removeClass("active");
	$(".marker10").addClass("active");
	station = 10;
});

$(".submitbuttonseeds").click(function () {
	CloseAll();
	$.post(
		"https://SevenLife_BusFahrer/StartCourse",
		JSON.stringify({
			station: station,
		})
	);
});
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-busfahrer").hide();
	$.post("https://SevenLife_BusFahrer/Close", JSON.stringify({}));
}
