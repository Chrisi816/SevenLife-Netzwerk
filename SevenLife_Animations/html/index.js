$("document").ready(function () {
	$(".container-anim").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "openDanceNUI") {
			$(".box-anim").hide();
			$(".container-anim").fadeIn(200);
			fetch("../Animations.json")
				.then((resp) => resp.json())
				.then((data) => CreateStarterPanel(data, msg.result))
				.catch((e) => console.log("Fetching Error: " + e));
		} else if (event.data.type === "UpdateDanceNui") {
			fetch("../Animations.json")
				.then((resp) => resp.json())
				.then((data) => CreateStarterPanel(data, msg.result))
				.catch((e) => console.log("Fetching Error: " + e));
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseAll();
	}
});

function CloseAll() {
	$(".container-anim").hide();
	$.post("https://SevenLife_Animations/CloseMenu", JSON.stringify({}));
}

$(".button-oben-rechts").click(function () {
	CloseAll();
	$.post("https://SevenLife_Animations/CloseAnim", JSON.stringify({}));
});

function CreateStarterPanel(data, result) {
	var item1 = 1;
	var item2 = 1;
	var item3 = 1;

	result.forEach((marked) => {
		console.log(item1);
		if (item1 === 1) {
			item1 = marked.titel;
			console.log(marked.titel);
		} else if (item2 === 1) {
			item2 = marked.titel;
			console.log(marked.titel);
		} else if (item3 === 1) {
			item3 = marked.titel;
			console.log(marked.titel);
		}
	});

	$(".AnimList-box").html(" ");
	data.forEach((panel) => {
		if (panel && panel.type) {
			if (
				item1 == panel.title ||
				item2 == panel.title ||
				item3 == panel.title
			) {
				const content = $(
					`
					<div class="boxing"> 
					    <div class="box-anim" id="box-anim" anim = ${panel.title} type = ${panel.type} dancedict = ${panel.dict} danceanim = ${panel.anim} prop = ${panel.prop}  propBone = ${panel.propBone}  propPlacement = ${panel.propPlacement} propTwo = ${panel.propTwo} propTwoBone = ${panel.propTwoBone} propTwoPlacement = ${panel.propTwoPlacement}>
							<h1 class="dancename">
							   ${panel.title}
							</h1>
							<h2 class="tyoeanim">
							${panel.type}
							</h2>
					    </div>
						<img src="src/outline_star_white_24dp.png" class = "starfull"  anim = "${panel.title}"  type = "${panel.type}" dancedict = "${panel.dict}" danceanim = "${panel.anim}" prop = "${panel.prop}"  propBone = "${panel.propBone}"  propPlacement = "${panel.propPlacement}" propTwo = "${panel.propTwo}" propTwoBone = "${panel.propTwoBone}" propTwoPlacement = "${panel.propTwoPlacement}" >
					</div>
					`
				);

				$(".AnimList-box").prepend(content);
			} else {
				const content = $(
					`
					<div class="boxing"> 
					    <div class="box-anim" id="box-anim" anim = ${panel.title} type = ${panel.type} dancedict = ${panel.dict} danceanim = ${panel.anim} prop = ${panel.prop}  propBone = ${panel.propBone}  propPlacement = ${panel.propPlacement} propTwo = ${panel.propTwo} propTwoBone = ${panel.propTwoBone} propTwoPlacement = ${panel.propTwoPlacement}>
							<h1 class="dancename">
							   ${panel.title}
							</h1>
							<h2 class="tyoeanim">
							${panel.type}
							</h2>
					    </div>
						<img src="src/outline_grade_white_24dp.png" class = "star" anim = "${panel.title}"  type = "${panel.type}" dancedict = "${panel.dict}" danceanim = "${panel.anim}" prop = "${panel.prop}"  propBone = "${panel.propBone}"  propPlacement = "${panel.propPlacement}" propTwo = "${panel.propTwo}" propTwoBone = "${panel.propTwoBone}" propTwoPlacement = "${panel.propTwoPlacement}" >
					</div>
					`
				);

				$(".AnimList-box").append(content);
			}
		}
	});
}
function CreatePanel(data, result) {
	data.forEach((panel) => {
		if (panel && panel.type) {
			const content = $(
				`
            <div class="box-anim" id="box-anim" anim = ${panel.title} type = ${panel.type} dancedict = ${panel.dict} danceanim = ${panel.anim} prop = ${panel.prop}  propBone = ${panel.propBone}  propPlacement = ${panel.propPlacement} propTwo = ${panel.propTwo} propTwoBone = ${panel.propTwoBone} propTwoPlacement = ${panel.propTwoPlacement}>
                    <h1 class="dancename">
                       ${panel.title}
                    </h1>
                    <h2 class="tyoeanim">
                    ${panel.type}
                    </h2>
					<img src="src/outline_grade_white_24dp.png" class = "star" anim = ${panel.title}  type = ${panel.type} dancedict = ${panel.dict} danceanim = ${panel.anim} prop = ${panel.prop}  propBone = ${panel.propBone}  propPlacement = ${panel.propPlacement} propTwo = ${panel.propTwo} propTwoBone = ${panel.propTwoBone} propTwoPlacement = ${panel.propTwoPlacement}alt="">
            </div>
            `
			);

			$(".AnimList-box").append(content);
		}
	});
}

function searchanim() {
	$(".box-anim").hide();
	let input = document.getElementById("search-bar").value;
	input = input.toUpperCase();
	let items = document.getElementsByClassName("box-anim");
	if (input == "") {
		fetch("../Animations.json")
			.then((resp) => resp.json())
			.then((data) => CreatePanel(data))
			.catch((e) => console.log("Fetching Error: " + e));
	}

	for (i = 0; i < items.length; i++) {
		if (
			!items[i]
				.querySelector(".dancename")
				.innerHTML.toUpperCase()
				.includes(input)
		) {
			$(items[i]).hide();
		} else {
			$(items[i]).show();
		}
	}
}

$(".container-anim").on("click", ".box-anim", function () {
	var $button = $(this);
	var type = $button.attr("type");
	var dancedict = $button.attr("dancedict");
	var danceanim = $button.attr("danceanim");
	var prop = $button.attr("prop");
	var propBone = $button.attr("propBone");
	var propPlacement = $button.attr("propPlacement");
	var propTwo = $button.attr("propTwo");
	var propTwoBone = $button.attr("propTwoBone");
	var propTwoPlacement = $button.attr("propTwoPlacement");
	$(".container-anim").hide();
	$.post("https://SevenLife_Animations/CloseMenu", JSON.stringify({}));
	$.post(
		"https://SevenLife_Animations/beginAnimation",
		JSON.stringify({
			type: type,
			dancedict: dancedict,
			danceanim: danceanim,
			prop: prop,
			propBone: propBone,
			propPlacement: propPlacement,
			propTwo: propTwo,
			propTwoBone: propTwoBone,
			propTwoPlacement: propTwoPlacement,
		})
	);
});
$(".container-anim").on("click", ".star", function () {
	var $button = $(this);
	var type = $button.attr("type");
	var title = $button.attr("anim");
	var dancedict = $button.attr("dancedict");
	var danceanim = $button.attr("danceanim");
	var prop = $button.attr("prop");
	var propBone = $button.attr("propBone");
	var propPlacement = $button.attr("propPlacement");
	var propTwo = $button.attr("propTwo");
	var propTwoBone = $button.attr("propTwoBone");
	var propTwoPlacement = $button.attr("propTwoPlacement");

	$.post(
		"https://SevenLife_Animations/StoreAnimation",
		JSON.stringify({
			type: type,
			title: title,
			dancedict: dancedict,
			danceanim: danceanim,
			prop: prop,
			propBone: propBone,
			propPlacement: propPlacement,
			propTwo: propTwo,
			propTwoBone: propTwoBone,
			propTwoPlacement: propTwoPlacement,
		})
	);
});
$(".container-anim").on("click", ".starfull", function () {
	var $button = $(this);
	var anim = $button.attr("anim");

	$.post(
		"https://SevenLife_Animations/DeleteAnim",
		JSON.stringify({
			anim: anim,
		})
	);
});
