$("document").ready(function () {
	$(".container-firstframe").hide();
	$(".registerier-container").hide();
	$(".container-charcreator").hide();
	$(".HaareundAugen").hide();
	$(".head").hide();
	$(".reisepass").hide();
	$(".lastside").hide();
	$(".illegalorlegall").hide();
	$(".registeriers-container").hide();
	$(".hautprobleme").hide();
	$(".Kleidung-LastSide").hide();
	$(".juwell").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "opennui") {
			$(".container-firstframe").show();
		} else if (event.data.type === "removeannounce") {
			$(".container-firstframe").hide();
		} else if (event.data.type === "NextStepAfterNewAccount") {
			$(".registerier-container").hide();
			$(".reisepass").fadeIn(500);
			$(".container-charcreator").fadeIn(500);
			$(".charcreator").hide();
		} else if (event.data.type === "OpenLegalorillegal") {
			$(".illegalorlegall").fadeIn(600);
		} else if (event.data.type === "RemoveLoginPanel") {
			$(".registeriers-container").hide();
		}
	});
});
$(".left").click(function () {
	$(".container-firstframe").hide();
	$(".registeriers-container").fadeIn(500);
});
$(".submit-btns").click(function () {
	var benutzername = document.getElementById("loginUsers").value;
	var password = document.getElementById("loginPasswords").value;

	$.post(
		"http://SevenLife_LoginSkin/Login",
		JSON.stringify({ benutzername: benutzername, passwort: password })
	);
});
$(".submitbuttonseedsf").click(function () {
	$.post("http://SevenLife_LoginSkin/ReiseBeginnen", JSON.stringify({}));
	$(".container-charcreator").hide();
});
$(".right").click(function () {
	$(".container-firstframe").hide();
	$(".registerier-container").fadeIn(500);
});
$(".submit-btn").click(function () {
	var benutzername = document.getElementById("loginUser").value;
	var password = document.getElementById("loginPassword").value;
	$.post(
		"http://SevenLife_LoginSkin/CreateAccount",
		JSON.stringify({ benutzername: benutzername, passwort: password })
	);
});
$(".submitbuttonse").click(function () {
	$(".reisepass").hide();
	$(".charcreator").show();
	var vorname = document.getElementById("inputtes").value;
	var nachname = document.getElementById("inputtees").value;
	var geburtsort = document.getElementById("inputteees").value;
	var date = $("#birthday").val();
	var dateCheck = new Date($("#birthday").val());

	if (dateCheck == "Invalid Date") {
		date == "invalid";
	} else {
		const ye = new Intl.DateTimeFormat("en", { year: "numeric" }).format(
			dateCheck
		);
		const mo = new Intl.DateTimeFormat("en", { month: "2-digit" }).format(
			dateCheck
		);
		const da = new Intl.DateTimeFormat("en", { day: "2-digit" }).format(
			dateCheck
		);

		var formattedDate = `${mo}/${da}/${ye}`;

		$.post(
			"http://SevenLife_LoginSkin/CreateData",
			JSON.stringify({
				vorname: vorname,
				nachname: nachname,
				birth: formattedDate,
			})
		);
	}
});
$(".buttonses").click(function () {
	document.getElementById("weiblich").style.backgroundColor =
		"rgba(15, 15, 15, 0.356)";
	document.getElementById("männlich").style.backgroundColor =
		"rgba(0, 0, 0, 0.562)";
	let gender = "0";
	$.post(
		"http://SevenLife_LoginSkin/ChangeSEX",
		JSON.stringify({ gender: gender })
	);
});
$(".buttonse").click(function () {
	document.getElementById("männlich").style.backgroundColor =
		"rgba(15, 15, 15, 0.356)";
	document.getElementById("weiblich").style.backgroundColor =
		"rgba(0, 0, 0, 0.562)";
	let gender = "1";
	$.post(
		"http://SevenLife_LoginSkin/ChangeSEX",
		JSON.stringify({ gender: gender })
	);
});
const container = document.querySelectorAll(".range-slider");

for (let i = 0; i < container.length; i++) {
	const slider = container[i].querySelector(".slider");
	const thumb = container[i].querySelector(".slider-thumb");
	const prgress = container[i].querySelector(".progress");
	function customslider() {
		const maxVal = slider.getAttribute("max");
		const val = (slider.value / maxVal) * 100 + "%";

		prgress.style.width = val;
		thumb.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/ChangeMother",
			JSON.stringify({ mother: slider.value })
		);
	}
	customslider();
	slider.addEventListener("input", () => {
		customslider();
	});
}
const containers = document.querySelectorAll(".range-sliders");

for (let i = 0; i < containers.length; i++) {
	const sliders = containers[i].querySelector(".sliders");
	const thumbs = containers[i].querySelector(".slider-thumbs");
	const prgresss = containers[i].querySelector(".progresss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/ChangeFather",
			JSON.stringify({ dad: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerse = document.querySelectorAll(".range-sliderse");

for (let i = 0; i < containerse.length; i++) {
	const sliders = containerse[i].querySelector(".sliderse");
	const thumbs = containerse[i].querySelector(".slider-thumbse");
	const prgresss = containerse[i].querySelector(".progressss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/ChangeMotherColor",
			JSON.stringify({ MotherColor: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}

const containersee = document.querySelectorAll(".range-sliderses");

for (let i = 0; i < containersee.length; i++) {
	const sliders = containersee[i].querySelector(".sliderses");
	const thumbs = containersee[i].querySelector(".slider-thumbses");
	const prgresss = containersee[i].querySelector(".progresssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/ChangeFaterColor",
			JSON.stringify({ FaterColor: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}

$(document).keydown(function (e) {
	if (e.key === "d") {
		$.post(
			"http://SevenLife_LoginSkin/rotationleft",
			JSON.stringify({ value: -5 })
		);
	}
});
$(document).keydown(function (e) {
	if (e.key === "a") {
		$.post(
			"http://SevenLife_LoginSkin/rotationright",
			JSON.stringify({ value: 5 })
		);
	}
});
$("#face").click(function () {
	$(".geschlecht").hide();
	$(".hautprobleme").hide();
	$(".head").show();
	$(".lastside").hide();
	$(".restlicheGesicht").hide();
	$(".umschauen").show();
	$(".HaareundAugen").hide();
	$(".Kleidung-LastSide").hide();
	$(".juwell").hide();
});
$("#kleidung").click(function () {
	$(".geschlecht").hide();
	$(".hautprobleme").hide();
	$(".head").hide();
	$(".lastside").hide();
	$(".restlicheGesicht").hide();
	$(".umschauen").show();
	$(".HaareundAugen").hide();
	$(".Kleidung-LastSide").show();
	$(".juwell").hide();
});
$("#geschelcht").click(function () {
	$(".head").hide();
	$(".geschlecht").show();
	$(".hautprobleme").hide();
	$(".restlicheGesicht").hide();
	$(".umschauen").show();
	$(".lastside").hide();
	$(".HaareundAugen").hide();
	$(".Kleidung-LastSide").hide();
	$(".juwell").hide();
});
$("#haut").click(function () {
	$(".head").hide();
	$(".geschlecht").hide();
	$(".hautprobleme").show();
	$(".restlicheGesicht").hide();
	$(".HaareundAugen").hide();
	$(".lastside").hide();
	$(".umschauen").show();
	$(".Kleidung-LastSide").hide();
	$(".juwell").hide();
});
$("#rest").click(function () {
	$(".head").hide();
	$(".geschlecht").hide();
	$(".hautprobleme").hide();
	$(".restlicheGesicht").show();
	$(".HaareundAugen").hide();
	$(".lastside").hide();
	$(".umschauen").show();
	$(".Kleidung-LastSide").hide();
	$(".juwell").hide();
});
$("#juwell").click(function () {
	$(".head").hide();
	$(".geschlecht").hide();
	$(".hautprobleme").hide();
	$(".restlicheGesicht").show();
	$(".HaareundAugen").hide();
	$(".lastside").hide();
	$(".umschauen").show();
	$(".juwell").show();
	$(".Kleidung-LastSide").hide();
});
$("#augenundhaare").click(function () {
	$(".HaareundAugen").show();
	$(".head").hide();
	$(".geschlecht").hide();
	$(".hautprobleme").hide();
	$(".restlicheGesicht").hide();
	$(".umschauen").show();
	$(".lastside").hide();
	$(".juwell").hide();
	$(".Kleidung-LastSide").hide();
});
$("#fertigundextras").click(function () {
	$(".HaareundAugen").hide();
	$(".head").hide();
	$(".geschlecht").hide();
	$(".hautprobleme").hide();
	$(".restlicheGesicht").hide();
	$(".lastside").show();
	$(".umschauen").hide();
	$(".juwell").hide();
	$(".Kleidung-LastSide").hide();
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
			"http://SevenLife_LoginSkin/NaseWidth",
			JSON.stringify({ NaseWidth: sliders.value })
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
			"http://SevenLife_LoginSkin/NasePeakHeight",
			JSON.stringify({ NasePeakHeight: sliders.value })
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
			"http://SevenLife_LoginSkin/NasePeakHeightlength",
			JSON.stringify({ nosepeakl: sliders.value })
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
			"http://SevenLife_LoginSkin/NasePeakBoneHeight",
			JSON.stringify({ noseboneh: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesesses = document.querySelectorAll(".range-slidersesessses");

for (let i = 0; i < containerseesesses.length; i++) {
	const sliders = containerseesesses[i].querySelector(".sliderssesssesse");
	const thumbs = containerseesesses[i].querySelector(
		".slider-thumbsessessses"
	);
	const prgresss = containerseesesses[i].querySelector(".progresssssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/NosePeakLowering",
			JSON.stringify({ nosepeakh: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesessse = document.querySelectorAll(".range-slidersesesssese");

for (let i = 0; i < containerseesessse.length; i++) {
	const sliders = containerseesessse[i].querySelector(".slidersesssessess");
	const thumbs = containerseesessse[i].querySelector(
		".slider-thumbsessesseses"
	);
	const prgresss = containerseesessse[i].querySelector(
		".progresssssssssssss"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/NoseBoneTwist",
			JSON.stringify({ nosetwist: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesessesse = document.querySelectorAll(
	".range-slidersesessseseses"
);

for (let i = 0; i < containerseesessesse.length; i++) {
	const sliders = containerseesessesse[i].querySelector(
		".slidersesssessessess"
	);
	const thumbs = containerseesessesse[i].querySelector(
		".slider-thumbsessessesesse"
	);
	const prgresss = containerseesessesse[i].querySelector(
		".progresssssssssssssssss"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Eyebrowheight",
			JSON.stringify({ eyesbrowh: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesessseses = document.querySelectorAll(
	".range-slidersesesssesesesessse"
);

for (let i = 0; i < containerseesessseses.length; i++) {
	const sliders = containerseesessseses[i].querySelector(
		".slidersesssessesesss"
	);
	const thumbs = containerseesessseses[i].querySelector(
		".slider-thumbsessessesesses"
	);
	const prgresss = containerseesessseses[i].querySelector(".progressjdjdjd");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Eyebrowdept",
			JSON.stringify({ eyesbrowd: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesessesses = document.querySelectorAll(
	".range-slidersesesssesesesessseses"
);

for (let i = 0; i < containerseesessesses.length; i++) {
	const sliders = containerseesessesses[i].querySelector(
		".slidersesssessssesesss"
	);
	const thumbs = containerseesessesses[i].querySelector(
		".slider-thumbsessesssesseses"
	);
	const prgresss =
		containerseesessesses[i].querySelector(".progressjssdjdjd");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/CheekbonesHeight",
			JSON.stringify({ cheekboneh: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const containerseesesssesesses = document.querySelectorAll(
	".range-slidersesesssesesesesssesese"
);

for (let i = 0; i < containerseesesssesesses.length; i++) {
	const sliders = containerseesesssesesses[i].querySelector(
		".slidersesssessssesesssesse"
	);
	const thumbs = containerseesesssesesses[i].querySelector(
		".slider-thumbsessessesessssses"
	);
	const prgresss = containerseesesssesesses[i].querySelector(
		".progressjssdjdjdse"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/CheekbonesWidth",
			JSON.stringify({ cheekbonew: sliders.value })
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
			"http://SevenLife_LoginSkin/ProblemHaut",
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
			"http://SevenLife_LoginSkin/SommerSprossen",
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
			"http://SevenLife_LoginSkin/ProblemHautVar",
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
			"http://SevenLife_LoginSkin/SommerSprossenVar",
			JSON.stringify({ freckleopacity: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const dasdasdadasdada = document.querySelectorAll(".range-dedfds");

for (let i = 0; i < dasdasdadasdada.length; i++) {
	const sliders = dasdasdadasdada[i].querySelector(".slidersaddases");
	const thumbs = dasdasdadasdada[i].querySelector(".slider-dddadast");
	const prgresss = dasdasdadasdada[i].querySelector(".progresddasasdassss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Wunden",
			JSON.stringify({ cicatrices: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontaineadsarseesesssesesses = document.querySelectorAll(
	".range-dedfdadasdas"
);

for (let i = 0; i < cdontaineadsarseesesssesesses.length; i++) {
	const sliders = cdontaineadsarseesesssesesses[i].querySelector(
		".slideadasdrsaddaases"
	);
	const thumbs = cdontaineadsarseesesssesesses[i].querySelector(
		".slider-dddadasdsadast"
	);
	const prgresss = cdontaineadsarseesesssesesses[i].querySelector(
		".progresdasdsadasasdassss"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/WundenVar",
			JSON.stringify({ cicatricesp: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontainesadrseesesssesesses =
	document.querySelectorAll(".range-dddasda");

for (let i = 0; i < cdontainesadrseesesssesesses.length; i++) {
	const sliders =
		cdontainesadrseesesssesesses[i].querySelector(".sliasdadderses");
	const thumbs = cdontainesadrseesesssesesses[i].querySelector(
		".slider-thusadadmbses"
	);
	const prgresss =
		cdontainesadrseesesssesesses[i].querySelector(".progsadaresssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Falten",
			JSON.stringify({ wrinkle: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontainerseesesssasdesesses = document.querySelectorAll(
	".range-dddassdasdAda"
);

for (let i = 0; i < cdontainerseesesssasdesesses.length; i++) {
	const sliders = cdontainerseesesssasdesesses[i].querySelector(
		".sliasadsdaddadsaerses"
	);
	const thumbs = cdontainerseesesssasdesesses[i].querySelector(
		".slider-tadsadhusadadmbses"
	);
	const prgresss = cdontainerseesesssasdesesses[i].querySelector(
		".proadsadgsadaresasdassss"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/FaltenVar",
			JSON.stringify({ wrinkleopacity: sliders.value })
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
			"http://SevenLife_LoginSkin/AugenFarbe",
			JSON.stringify({ eyecolor: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
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
			"http://SevenLife_LoginSkin/AugenBrauen",
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
			"http://SevenLife_LoginSkin/AugenBrauenDichte",
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
			"http://SevenLife_LoginSkin/AugenBrauen",
			JSON.stringify({ eyebrowcolor: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
$(".einreisenlegal").click(function () {
	$.post("http://SevenLife_LoginSkin/LagaleReise", JSON.stringify({}));
	$(".illegalorlegall").hide();
});
$(".einreisenillegal").click(function () {
	$.post("http://SevenLife_LoginSkin/ILLagaleReise", JSON.stringify({}));
	$(".illegalorlegall").hide();
});
const cdontaineasdrseesesssasasddesessses = document.querySelectorAll(
	".rangadse-dedfdasadaasdaadsqetdqqdasdasasadds"
);

for (let i = 0; i < cdontaineasdrseesesssasasddesessses.length; i++) {
	const sliders = cdontaineasdrseesesssasasddesessses[i].querySelector(
		".sadsadasadadaasdadqsdasdaAdsad"
	);
	const thumbs = cdontaineasdrseesesssasasddesessses[i].querySelector(
		".slider-asdasdawqeqgg"
	);
	const prgresss =
		cdontaineasdrseesesssasasddesessses[i].querySelector(
			".dssadasdsadwaqdw"
		);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Haare1",
			JSON.stringify({ Haar1: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontaineasdrseesesssasdesessses = document.querySelectorAll(
	".rangadse-dedfdasadaasdaadsqetdqqdasdasasd"
);

for (let i = 0; i < cdontaineasdrseesesssasdesessses.length; i++) {
	const sliders =
		cdontaineasdrseesesssasdesessses[i].querySelector(".sadasasada");
	const thumbs = cdontaineasdrseesesssasdesessses[i].querySelector(
		".slider-asdasddasdawqeqgg"
	);
	const prgresss = cdontaineasdrseesesssasdesessses[i].querySelector(
		".dasdetgfadcyxsasdaadaada"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Haare2",
			JSON.stringify({ Haar1: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontaineasdrseesessdsasasdesessses = document.querySelectorAll(
	".rangadse-dedfdasadaasdaaasdasddsqetdqqdasdas"
);

for (let i = 0; i < cdontaineasdrseesessdsasasdesessses.length; i++) {
	const sliders = cdontaineasdrseesessdsasasdesessses[i].querySelector(
		".sasda4adasadadaasdadqsdasdaAdsad"
	);
	const thumbs = cdontaineasdrseesessdsasasdesessses[i].querySelector(
		".slider-asd3432awqeqgg"
	);
	const prgresss =
		cdontaineasdrseesessdsasasdesessses[i].querySelector(".sadasdwae23s");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Haare-farbe",
			JSON.stringify({ haarfarbe1: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const cdontaineasdrseesessdasdsasasdesessses = document.querySelectorAll(
	".rangadse-dedfdasadaasdaaasdasadsasddsqetdqqdasdas"
);

for (let i = 0; i < cdontaineasdrseesessdasdsasasdesessses.length; i++) {
	const sliders = cdontaineasdrseesessdasdsasasdesessses[i].querySelector(
		".sasda4adasadadaasdadqadasdasdaAdsad"
	);
	const thumbs =
		cdontaineasdrseesessdasdsasasdesessses[i].querySelector(
			".slider-adadaw32"
		);
	const prgresss =
		cdontaineasdrseesessdasdsasasdesessses[i].querySelector(
			".sadasdwa32e23"
		);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Haare2-farbe",
			JSON.stringify({ haarfarbe2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}

const slider = document.querySelectorAll(".slider-style");

for (let i = 0; i < slider.length; i++) {
	const sliders = slider[i].querySelector(".input-slider");
	const thumbs = slider[i].querySelector(".slider-list");
	const prgresss = slider[i].querySelector(".endslider");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/T-Shirt",
			JSON.stringify({ shirt: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderd = document.querySelectorAll(".slider-styles");

for (let i = 0; i < sliderd.length; i++) {
	const sliders = sliderd[i].querySelector(".input-sliders");
	const thumbs = sliderd[i].querySelector(".slider-lists");
	const prgresss = sliderd[i].querySelector(".endsliders");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/T-Shirt2",
			JSON.stringify({ shirt2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderde = document.querySelectorAll(".slider-styless");

for (let i = 0; i < sliderde.length; i++) {
	const sliders = sliderde[i].querySelector(".input-sliderss");
	const thumbs = sliderde[i].querySelector(".slider-listss");
	const prgresss = sliderde[i].querySelector(".endsliderss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Troso",
			JSON.stringify({ Troso: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdes = document.querySelectorAll(".slider-stylesss");

for (let i = 0; i < sliderdes.length; i++) {
	const sliders = sliderdes[i].querySelector(".input-slidersss");
	const thumbs = sliderdes[i].querySelector(".slider-listsss");
	const prgresss = sliderdes[i].querySelector(".endslidersss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Troso2",
			JSON.stringify({ Troso2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdess = document.querySelectorAll(".slider-stylessss");

for (let i = 0; i < sliderdess.length; i++) {
	const sliders = sliderdess[i].querySelector(".input-sliderssss");
	const thumbs = sliderdess[i].querySelector(".slider-listssss");
	const prgresss = sliderdess[i].querySelector(".endsliderssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Arme",
			JSON.stringify({ Arme: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesss = document.querySelectorAll(".slider-stylesssss");

for (let i = 0; i < sliderdesss.length; i++) {
	const sliders = sliderdesss[i].querySelector(".input-slidersssss");
	const thumbs = sliderdesss[i].querySelector(".slider-listsssss");
	const prgresss = sliderdesss[i].querySelector(".endslidersssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Arme2",
			JSON.stringify({ Arme2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessss = document.querySelectorAll(".slider-stylessssss");

for (let i = 0; i < sliderdessss.length; i++) {
	const sliders = sliderdessss[i].querySelector(".input-sliderssssss");
	const thumbs = sliderdessss[i].querySelector(".slider-listssssss");
	const prgresss = sliderdessss[i].querySelector(".endsliderssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Pants",
			JSON.stringify({ Pants: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssss = document.querySelectorAll(".slider-stylesssssss");

for (let i = 0; i < sliderdesssss.length; i++) {
	const sliders = sliderdesssss[i].querySelector(".input-slidersssssss");
	const thumbs = sliderdesssss[i].querySelector(".slider-listsssssss");
	const prgresss = sliderdesssss[i].querySelector(".endslidersssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Pants2",
			JSON.stringify({ Pants2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssss = document.querySelectorAll(".slider-stylessssssss");

for (let i = 0; i < sliderdessssss.length; i++) {
	const sliders = sliderdessssss[i].querySelector(".input-sliderssssssss");
	const thumbs = sliderdessssss[i].querySelector(".slider-listssssssss");
	const prgresss = sliderdessssss[i].querySelector(".endsliderssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Shoes",
			JSON.stringify({ Shoes: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssssss = document.querySelectorAll(".slider-stylesssssssss");

for (let i = 0; i < sliderdesssssss.length; i++) {
	const sliders = sliderdesssssss[i].querySelector(".input-slidersssssssss");
	const thumbs = sliderdesssssss[i].querySelector(".slider-listsssssssss");
	const prgresss = sliderdesssssss[i].querySelector(".endslidersssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/Shoes2",
			JSON.stringify({ Shoes2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
/* text */

const sliderdessssssss = document.querySelectorAll(".slider-make");

for (let i = 0; i < sliderdessssssss.length; i++) {
	const sliders = sliderdessssssss[i].querySelector(".input-makd");
	const thumbs = sliderdessssssss[i].querySelector(".slider-maky");
	const prgresss = sliderdessssssss[i].querySelector(".makk");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/juwell",
			JSON.stringify({ juwell: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssssssss = document.querySelectorAll(".slider-makes");

for (let i = 0; i < sliderdesssssssss.length; i++) {
	const sliders = sliderdesssssssss[i].querySelector(".input-makds");
	const thumbs = sliderdesssssssss[i].querySelector(".slider-makys");
	const prgresss = sliderdesssssssss[i].querySelector(".makks");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/brille",
			JSON.stringify({ brille: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssssssss = document.querySelectorAll(".slider-makess");

for (let i = 0; i < sliderdessssssssss.length; i++) {
	const sliders = sliderdessssssssss[i].querySelector(".input-makdss");
	const thumbs = sliderdessssssssss[i].querySelector(".slider-makyss");
	const prgresss = sliderdessssssssss[i].querySelector(".makkss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/brille2",
			JSON.stringify({ brille2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssssssssss = document.querySelectorAll(".slider-makesss");

for (let i = 0; i < sliderdesssssssssss.length; i++) {
	const sliders = sliderdesssssssssss[i].querySelector(".input-makdsss");
	const thumbs = sliderdesssssssssss[i].querySelector(".slider-makysss");
	const prgresss = sliderdesssssssssss[i].querySelector(".makksss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/ohringe",
			JSON.stringify({ ohringe: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssssssssss = document.querySelectorAll(".slider-makessss");

for (let i = 0; i < sliderdessssssssssss.length; i++) {
	const sliders = sliderdessssssssssss[i].querySelector(".input-makdssss");
	const thumbs = sliderdessssssssssss[i].querySelector(".slider-makyssss");
	const prgresss = sliderdessssssssssss[i].querySelector(".makkssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/ohringe2",
			JSON.stringify({ ohringe2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssssssssssss = document.querySelectorAll(".slider-makesssss");

for (let i = 0; i < sliderdesssssssssssss.length; i++) {
	const sliders = sliderdesssssssssssss[i].querySelector(".input-makdsssss");
	const thumbs = sliderdesssssssssssss[i].querySelector(".slider-makysssss");
	const prgresss = sliderdesssssssssssss[i].querySelector(".makksssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/uhr",
			JSON.stringify({ uhr: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssssssssssss = document.querySelectorAll(".slider-makessssss");

for (let i = 0; i < sliderdessssssssssssss.length; i++) {
	const sliders =
		sliderdessssssssssssss[i].querySelector(".input-makdssssss");
	const thumbs =
		sliderdessssssssssssss[i].querySelector(".slider-makyssssss");
	const prgresss = sliderdessssssssssssss[i].querySelector(".makkssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/uhr2",
			JSON.stringify({ uhr2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssssssssssssss = document.querySelectorAll(
	".slider-makesssssss"
);

for (let i = 0; i < sliderdesssssssssssssss.length; i++) {
	const sliders =
		sliderdesssssssssssssss[i].querySelector(".input-makdsssssss");
	const thumbs = sliderdesssssssssssssss[i].querySelector(
		".slider-makysssssss"
	);
	const prgresss = sliderdesssssssssssssss[i].querySelector(".makksssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/armband",
			JSON.stringify({ armband: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssssssssssssss = document.querySelectorAll(
	".slider-makessssssss"
);

for (let i = 0; i < sliderdessssssssssssssss.length; i++) {
	const sliders = sliderdessssssssssssssss[i].querySelector(
		".input-makdssssssss"
	);
	const thumbs = sliderdessssssssssssssss[i].querySelector(
		".slider-makyssssssss"
	);
	const prgresss = sliderdessssssssssssssss[i].querySelector(".makkssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/armband2",
			JSON.stringify({ armband2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
/*Textes*/

const sliderdesssssssssssssssss = document.querySelectorAll(
	".slider-makesssssssss"
);

for (let i = 0; i < sliderdesssssssssssssssss.length; i++) {
	const sliders = sliderdesssssssssssssssss[i].querySelector(
		".input-makdsssssssss"
	);
	const thumbs = sliderdesssssssssssssssss[i].querySelector(
		".slider-makysssssssss"
	);
	const prgresss =
		sliderdesssssssssssssssss[i].querySelector(".makksssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/hut",
			JSON.stringify({ hut: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssssssssssssssss = document.querySelectorAll(
	".slider-makessssssssss"
);

for (let i = 0; i < sliderdessssssssssssssssss.length; i++) {
	const sliders = sliderdessssssssssssssssss[i].querySelector(
		".input-makdssssssssss"
	);
	const thumbs = sliderdessssssssssssssssss[i].querySelector(
		".slider-makyssssssssss"
	);
	const prgresss =
		sliderdessssssssssssssssss[i].querySelector(".makkssssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/hut2",
			JSON.stringify({ hut2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdesssssssssssssssssss = document.querySelectorAll(
	".slider-makesssssssssss"
);

for (let i = 0; i < sliderdesssssssssssssssssss.length; i++) {
	const sliders = sliderdesssssssssssssssssss[i].querySelector(
		".input-makdsssssssssss"
	);
	const thumbs = sliderdesssssssssssssssssss[i].querySelector(
		".slider-makysssssssssss"
	);
	const prgresss =
		sliderdesssssssssssssssssss[i].querySelector(".makksssssssssss");
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/maske",
			JSON.stringify({ maske: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
const sliderdessssssssssssssssssss = document.querySelectorAll(
	".slider-makesssssssssssss"
);

for (let i = 0; i < sliderdessssssssssssssssssss.length; i++) {
	const sliders = sliderdessssssssssssssssssss[i].querySelector(
		".input-makdssssssssssssss"
	);
	const thumbs = sliderdessssssssssssssssssss[i].querySelector(
		".slider-makyssssssssssssss"
	);
	const prgresss = sliderdessssssssssssssssssss[i].querySelector(
		".makkssssssssssssss"
	);
	function customslider() {
		const maxVal = sliders.getAttribute("max");
		const minVal = sliders.getAttribute("min");
		const val = (sliders.value / maxVal) * 100 + "%";

		prgresss.style.width = val;
		thumbs.style.left = val;
		$.post(
			"http://SevenLife_LoginSkin/maske2",
			JSON.stringify({ maske2: sliders.value })
		);
	}
	customslider();
	sliders.addEventListener("input", () => {
		customslider();
	});
}
$(".backtolight").click(function () {
	$(".container-firstframe").fadeIn(500);
	$(".registerier-container").hide();
});
$(".backtolightzwei").click(function () {
	$(".container-firstframe").fadeIn(500);
	$(".registeriers-container").hide();
});

document.querySelectorAll('input[type="range"]').forEach((input) => {
	input.addEventListener("mousedown", () =>
		window.getSelection().removeAllRanges()
	);
});
