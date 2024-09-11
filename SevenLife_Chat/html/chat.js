var open = false;
$("document").ready(function () {
	$(".container-chat").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.type === "OpenChat") {
			$(".container-chat").show();
			document.getElementById("inputt-sendcommand").focus();
			setTimeout(function () {
				open = true;
			}, 100);
		} else if (event.data.type === "AppendOOCNachricht") {
			$(".container-chat").fadeIn(500);
			const content = $(
				`
				<div class="notify-containers">
					<img
						src="src/outline_info_white_24dp.png"
						class="infos-bild"
						alt=""
					/>
					<h1 class="titelss">OOC - ${msg.titel}</h1>
					<span class="nachrichttext"> ${msg.message} </span>
				</div>
            `
			);

			$(".box-container-abwesend").prepend(content);

			setTimeout(() => {
				$(".container-chat").fadeOut(500);
			}, 3000);
		} else if (event.data.type === "ShowId") {
			$(".container-chat").fadeIn(500);
			const content = $(
				`
				<div class="notify-containersid">
					<img
						src="src/outline_info_white_24dp.png"
						class="infos-bild"
						alt=""
					/>
					<h1 class="titelss">ID - ${msg.titel}</h1>
					<span class="nachrichttext"> Static-ID: ${msg.message} </br> Session-ID: ${msg.id}  </span>
				</div>
            `
			);

			$(".box-container-abwesend").prepend(content);

			setTimeout(() => {
				$(".container-chat").fadeOut(500);
			}, 3000);
		} else if (event.data.type === "ShowIds") {
			$(".container-chat").fadeIn(500);
			const content = $(
				`
				<div class="notify-containersid">
					<img
						src="src/outline_info_white_24dp.png"
						class="infos-bild"
						alt=""
					/>
					<h1 class="titelss">ID - ${msg.titel}</h1>
					<span class="nachrichttext">   ${msg.message} </span>
				</div>
            `
			);

			$(".box-container-abwesend").prepend(content);

			setTimeout(() => {
				$(".container-chat").fadeOut(500);
			}, 3000);
		} else if (event.data.type === "UpdateCode") {
			document.getElementById("inputt-sendcommand").value = msg.resulting;
		}
	});
});

$(".inputt-sendcommand").on("keyup", function (e) {
	if (e.key === "Enter" || e.keyCode === 13) {
		var input = document.getElementById("inputt-sendcommand").value;
		if (onlyLetters(input)) {
			$(".container-chat").hide();
			$.post("https://SevenLife_Chat/RemoveChat", JSON.stringify({}));
			$.post(
				"https://SevenLife_Chat/SendCommandToCLient",
				JSON.stringify({ input: input })
			);
			document.getElementById("inputt-sendcommand").value = "";
		} else {
			$(".container-chat").hide();
			$.post("https://SevenLife_Chat/RemoveChat", JSON.stringify({}));
			document.getElementById("inputt-sendcommand").value = "";
			$.post("https://SevenLife_Chat/Fehler", JSON.stringify({}));
		}
	}
	if (e.key === "ArrowUp" || e.keyCode === 38) {
		$.post("https://SevenLife_Chat/GetLast", JSON.stringify({}));
	}
	if (e.key === "ArrowDown" || e.keyCode === 40) {
		document.getElementById("inputt-sendcommand").value = "";
	}
});

function onlyLetters(str) {
	console.log(str);
	return /^[.a-zA-Z/ ",0-123456789_-]+$/.test(str);
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		if (open) {
			$(".container-chat").hide();
			document.getElementById("inputt-sendcommand").value = "";
			open = false;
			$.post("https://SevenLife_Chat/RemoveChat", JSON.stringify({}));
		}
	}
});
