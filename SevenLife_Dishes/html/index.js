var wette = 0;
var autoauszahlen = false;
var stand;
var currencoins;
var currentnumber = 1;
var IsGameRunning = false;
$("document").ready(function () {
	$(".container-background").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenLimbo") {
			wette = 0;
			currencoins = msg.money;
			currentnumber = 1;
			var vid = document.getElementById("video1");
			vid.muted = true;
			autoauszahlen = false;
			$(".container-background").show();
			document.getElementById("money").innerHTML = msg.money;
			InsertIntoList(msg.result);
		} else if (event.data.type === "UpdateNUI") {
			currencoins = msg.coins;
			InsertIntoList(msg.list);
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});

function CloseMenu() {
	$(".container-background").hide();
	$.post("https://SevenLife_Dishes/escape");
}
function InsertIntoList(items) {
	$(".container-scroll").html(" ");

	$.each(items, function (index, item) {
		$(".container-scroll").prepend(
			`
                <div class="container-all">
					<div class="container-player">
						<img
							src="src/baseline_person_white_48dp.png"
							class="person-img"
							alt=""
						/>
					</div>
				    <div class="container-durch">
					<h1 class="namegewinner">${item.name}</h1>
						<div class="container-multiplayer">
							<h1 class="item-text-multi">${item.multi}x</h1>
						</div>
					</div>
				</div>
             `
		);
	});
}
$(".btn").click(function () {
	var value = document.getElementById("wetten").value;
	wette = value;
});

$(".btn2").click(function () {
	var value = document.getElementById("auszahlen").value;
	autoauszahlen = value;
});
var ergebnis = 0;

const sliders = document.getElementById("input-makdssssssssssssss");
const thumbs = document.getElementById("slider-makyssssssssssssss");
$(".btn3").click(function () {
	currentnumber = 50.0;

	document.getElementById("input-makdssssssssssssss").value = 50;

	if (currencoins >= wette) {
		if (IsGameRunning == false) {
			IsGameRunning = true;
			var min = 0;
			var max = 100;
			var x = Math.random() * (max - min) + min;

			var x = x.toFixed(2);
			x = Number(x);
			console.log(x);
			Animation(x);
		}
	} else {
		CloseMenu();
		$.post("https://SevenLife_Dishes/ZuwenigGeld");
	}
});

function Animation(tims) {
	var vid = document.getElementById("video1");
	vid.muted = false;
	if (tims >= 50) {
		var inter = setInterval(() => {
			if (tims >= currentnumber) {
				if (autoauszahlen != currentnumber) {
					currentnumber = Number(currentnumber);
					currentnumber = currentnumber + 1;
					currentnumber = currentnumber.toFixed(2);

					document.getElementById("input-makdssssssssssssss").value =
						currentnumber;
				} else {
					vid.muted = true;
					$.post(
						"https://SevenLife_Dishes/Gewonnen",
						JSON.stringify({
							einsatz: wette,
							multi: tims,
						})
					);
					IsGameRunning = false;
					clearInterval(inter);
				}
			} else {
				vid.muted = true;
				$.post(
					"https://SevenLife_Dishes/Gewonnen",
					JSON.stringify({
						einsatz: wette,
						multi: tims,
					})
				);
				IsGameRunning = false;
				clearInterval(inter);
			}
		}, 10);
	} else {
		var inter = setInterval(() => {
			if (currentnumber >= tims) {
				if (autoauszahlen != currentnumber) {
					currentnumber = Number(currentnumber);
					currentnumber = currentnumber - 1;
					currentnumber = currentnumber.toFixed(2);

					document.getElementById("input-makdssssssssssssss").value =
						currentnumber;
				} else {
					vid.muted = true;
					$.post(
						"https://SevenLife_Dishes/Verloren",
						JSON.stringify({
							einsatz: wette,
							multi: tims,
						})
					);
					IsGameRunning = false;
					clearInterval(inter);
				}
			} else {
				vid.muted = true;
				$.post(
					"https://SevenLife_Dishes/Verloren",
					JSON.stringify({
						einsatz: wette,
						multi: tims,
					})
				);
				IsGameRunning = false;
				clearInterval(inter);
			}
		}, 10);
	}
}
