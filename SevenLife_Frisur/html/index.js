$("document").ready(function () {
	$(".haare").hide();
	$(".augen").hide();
	$(".falten").hide();
	$(".Barber-Container").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "opennuibarber") {
			$(".Barber-Container").fadeIn(1000);
		}
	});
});
$("#haare").click(function () {
	$(".fontseite-links").hide();
	$(".fontseite-rechts").hide();
	$(".haare").fadeIn(300);
});
$(".back").click(function () {
	$(".fontseite-links").fadeIn(300);
	$(".fontseite-rechts").fadeIn(300);
	$(".haare").hide();
	$(".augen").hide();
	$(".falten").hide();
});
$("#augens").click(function () {
	$(".fontseite-links").hide();
	$(".fontseite-rechts").hide();
	$(".augen").fadeIn(300);
});
$("#falten").click(function () {
	$(".fontseite-links").hide();
	$(".fontseite-rechts").hide();
	$(".falten").fadeIn(300);
});
const containersees = document.querySelectorAll(".range-slidersese");

for (let i = 0; i < containersees.length; i++) {
	const sliders = containersees[i].querySelector(".slidersess");
	const thumbs = containersees[i].querySelector(".slider-thumbsesses");
	const prgresss = containersees[i].querySelector(".progressssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/Haar1",
			JSON.stringify({ Haar1: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseese = document.querySelectorAll(".range-sliderseses");

for (let i = 0; i < containerseese.length; i++) {
	const sliders = containerseese[i].querySelector(".slidersesss");
	const thumbs = containerseese[i].querySelector(".slider-thumbsessess");
	const prgresss = containerseese[i].querySelector(".progresssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/Haar2",
			JSON.stringify({ Haar2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseeses = document.querySelectorAll(".range-slidersesess");

for (let i = 0; i < containerseeses.length; i++) {
	const sliders = containerseeses[i].querySelector(".slidersessses");
	const thumbs = containerseeses[i].querySelector(".slider-thumbsessesse");
	const prgresss = containerseeses[i].querySelector(".progresssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/Haar-farbe1",
			JSON.stringify({ haarfarbe1: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesess = document.querySelectorAll(".range-slidersesessse");

for (let i = 0; i < containerseesess.length; i++) {
	const sliders = containerseesess[i].querySelector(".slidersesssesse");
	const thumbs = containerseesess[i].querySelector(".slider-thumbsessesses");
	const prgresss = containerseesess[i].querySelector(".progressssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/Haar-farbe2",
			JSON.stringify({ haarfarbe2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".Barber-Container").hide();
	$.post("http://SevenLife_Frisur/CloseMenu", JSON.stringify({}));
}
$(".buttonkaufen").click(function () {
	$(".Barber-Container").hide();
	$.post("http://SevenLife_Frisur/Kaufen", JSON.stringify({}));
});
const cdontainerseesasdsaesssasdesesses = document.querySelectorAll(
	".rangadse-dedfdasadadasdas"
);

for (let i = 0; i < cdontainerseesasdsaesssasdesesses.length; i++) {
	const sliders =
		cdontainerseesasdsaesssasdesesses[i].querySelector(".sadaasdasdaAdsad");
	const thumbs = cdontainerseesasdsaesssasdesesses[i].querySelector(
		".slider-dddaadsasddasasdadsadast"
	);
	const prgresss =
		cdontainerseesasdsaesssasdesesses[i].querySelector(".dasdadsadaada");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/Bart-Farbe",
			JSON.stringify({ eyebrow: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontaiasdnerseesesssasdesesses = document.querySelectorAll(
	".rangadse-dedfdasadaasdadqqdasdas"
);

for (let i = 0; i < cdontaiasdnerseesesssasdesesses.length; i++) {
	const sliders = cdontaiasdnerseesesssasdesesses[i].querySelector(
		".sadaaasdadqsdasdaAdsad"
	);
	const thumbs =
		cdontaiasdnerseesesssasdesesses[i].querySelector(".slider-asdqasadq");
	const prgresss =
		cdontaiasdnerseesesssasdesesses[i].querySelector(".dasdadsasdaadaada");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/AugenBrauenDichte",
			JSON.stringify({ eyebrowopacity: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontaineasdrseesesssasdesesses = document.querySelectorAll(
	".rangadse-dedfdasadaasdaadsqetdqqdasdas"
);

for (let i = 0; i < cdontaineasdrseesesssasdesesses.length; i++) {
	const sliders = cdontaineasdrseesesssasdesesses[i].querySelector(
		".sadasadadaasdadqsdasdaAdsad"
	);
	const thumbs =
		cdontaineasdrseesesssasdesesses[i].querySelector(".slider-asdawqeqgg");
	const prgresss = cdontaineasdrseesesssasdesesses[i].querySelector(
		".dasdetgfadsasdaadaada"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/AugenBrauen",
			JSON.stringify({ eyebrowcolor: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontasdinerseesesssasdesesses = document.querySelectorAll(
	".rangadse-dedfdadasdas"
);

for (let i = 0; i < cdontasdinerseesesssasdesesses.length; i++) {
	const sliders = cdontasdinerseesesssasdesesses[i].querySelector(
		".slidedsfsadasdrsaddaases"
	);
	const thumbs = cdontasdinerseesesssasdesesses[i].querySelector(
		".slider-dddaadsasddasdsadast"
	);
	const prgresss =
		cdontasdinerseesesssasdesesses[i].querySelector(".dasdada");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/BartVar",
			JSON.stringify({ eyecolor: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containeraSseesessesses = document.querySelectorAll(
	".range-slidersesseff"
);

for (let i = 0; i < containeraSseesessesses.length; i++) {
	const sliders = containeraSseesessesses[i].querySelector(".slidersesesdd");
	const thumbs =
		containeraSseesessesses[i].querySelector(".slider-thumbseses");
	const prgresss =
		containeraSseesessesses[i].querySelector(".progressssedfss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/ProblemHaut",
			JSON.stringify({ skinproblem: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdoadsntainerseesesssesesses = document.querySelectorAll(".range-dddd");

for (let i = 0; i < cdoadsntainerseesesssesesses.length; i++) {
	const sliders =
		cdoadsntainerseesesssesesses[i].querySelector(".slideddrseses");
	const thumbs = cdoadsntainerseesesssesesses[i].querySelector(
		".slider-thumbsdeses"
	);
	const prgresss =
		cdoadsntainerseesesssesesses[i].querySelector(".progresssdfss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/SommerSprossen",
			JSON.stringify({ freckle: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdoadsntaineasdarseesesssesesses = document.querySelectorAll(
	".range-slidersesSseffsasdas"
);

for (let i = 0; i < cdoadsntaineasdarseesesssesesses.length; i++) {
	const sliders = cdoadsntaineasdarseesesssesesses[i].querySelector(
		".sasdlidersesesasdd"
	);
	const thumbs = cdoadsntaineasdarseesesssesesses[i].querySelector(
		".slider-adsthumbsesadsaes"
	);
	const prgresss = cdoadsntaineasdarseesesssesesses[i].querySelector(
		".progresssdassedfss"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/ProblemHautVar",
			JSON.stringify({ skinproblemopacity: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontainerseesesssesesses = document.querySelectorAll(".range-ddddasda");

for (let i = 0; i < cdontainerseesesssesesses.length; i++) {
	const sliders =
		cdontainerseesesssesesses[i].querySelector(".dasdslideddrseses");
	const thumbs = cdontainerseesesssesesses[i].querySelector(
		".slider-thumdfsfsfasdeses"
	);
	const prgresss = cdontainerseesesssesesses[i].querySelector(".asdaadsa");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_Frisur/SommerSprossenVar",
			JSON.stringify({ freckleopacity: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
$(".buttonspeichern").click(function () {
	CloseAll();
});
$(document).keydown(function (e) {
	if (e.key === "d") {
		$.post(
			"http://SevenLife_Frisur/rotationleft",
			JSON.stringify({ value: -5 })
		);
	}
});
$(document).keydown(function (e) {
	if (e.key === "a") {
		$.post(
			"http://SevenLife_Frisur/rotationright",
			JSON.stringify({ value: 5 })
		);
	}
});
