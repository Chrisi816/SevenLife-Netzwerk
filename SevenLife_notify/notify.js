$("document").ready(function () {
	$(".container").hide();
	window.addEventListener("message", (event) => {
		var msg = event.data;
		if (msg.type === "TimetSeven") {
			const content = $(
				`
            
			<div class="notifyinformation">
				<div class="background-info"></div>
				<div class="notify-containers">
					<h1 class="titelss">${msg.bignachricht}</h1>
					<span class="nachrichttext"> ${msg.smallnachricht}.</span>
				</div>
				
			</div>
            `
			);

			$(".container-clean-res").prepend(content);

			setTimeout(() => {
				content.hide(2000);
			}, 5000);
		} else if (msg.type === "PoliceNotify") {
			const content = $(
				`
			<div class="Policeoverall">
				<div class="background-info2">
					<img src="src/LSPD.webp" class="imgpolice" alt="" />
				</div>
				<div class="policenotify">
					<h1 class="policetext">LSPD - Nachricht</h1>

					<h1 class="nachrichtpd">${msg.smallnachricht}</h1>
				</div>
			</div>
            `
			);

			$(".container-clean-res").append(content);

			setTimeout(() => {
				content.hide(2000);
			}, 5000);
		} else if (msg.type === "NotifyInfo") {
			const content = $(
				`
                <div class="paycheck">
				   <img
					src="src/baseline_notifications_active_white_24dp.png"
					alt=""
					class="notify-img"
				    />
				   <h1 class="PayCheckText">${msg.bignachricht}</h1>
				   <h1 class="PayCheckText2">${msg.smallnachricht}</h1>
			    </div>
            `
			);

			$(".container-clean-res").prepend(content);

			setTimeout(() => {
				content.hide(2000);
			}, 5000);
		} else if (msg.type === "OpenTankeMessage") {
			const content = $(
				`
                <div class="container-notifytanke">
				<div class="container-tankstellennotify"></div>
				<div class="info-notify">
					   <img src="src/question.png" class="imageinit" alt="" />
					    <h1 class="headeroftext">TANKSTELLEN - INFO</h1>
				    	<h1 class="descoftext">${msg.message}</h1>
				    </div>
			    </div>
            `
			);

			$(".container-clean-res").prepend(content);

			setTimeout(() => {
				content.hide();
			}, 5000);
		} else if (event.data.type === "OpenMoneyMessage") {
			const content = $(
				`
                <div class="container-notifytanke">
				<div class="container-tankstellennotify2"></div>
				<div class="info-notify2">
					<img
						src="src/baseline_attach_money_white_48dp.png"
						class="imageinit"
						alt=""
					/>
					<h1 class="headeroftext">PayCheck - INFO</h1>
					<h1 class="descoftext2">
						${msg.message}
					</h1>
				</div>
			</div>
            `
			);

			$(".container-clean-res").prepend(content);

			setTimeout(() => {
				content.hide();
			}, 5000);
		}
	});

	window.addEventListener("message", function (event) {
		var msgaction = event.data.action;
		var msg = event.data;
		switch (msgaction) {
			case "shownui":
				showNotification(msg.header, msg.text, msg.show);
				break;
		}
	});
	window.addEventListener("message", function (event) {
		var msgaction = event.data.action;
		var msg = event.data;
		switch (msgaction) {
			case "showtimetnui":
				showtimetNotification(msg.header, msg.text, msg.time);
				break;
		}
	});
});

function showNotification(header, text, show) {
	if (show === true) {
		document.getElementById("headertext").innerHTML = header;
		document.getElementById("text").innerHTML = text;
		$(".container").fadeIn(300);
	} else if (show === false) {
		$(".container").fadeOut(300);
	}
}

function showtimetNotification(header, text, time) {
	document.getElementById("headertext").innerHTML = header;
	document.getElementById("text").innerHTML = text;
}
function sleep(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}
$("document").ready(function () {
	$(".container-accept").hide();
	$(".container-fail").hide();
	$(".container-infos").hide();

	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (msg.type === "infos") {
			displayinfos(msg.msg);
		} else if (msg.type === "error") {
			displayerror(msg.msg);
		} else if (msg.type === "success") {
			displaysuccess(msg.msg);
		} else if (msg.type === "removeinfo") {
			$(".container-infos").hide();
		} else if (msg.type === "removeerror") {
			$(".container-fail").hide();
		} else if (msg.type === "removesuccess") {
			$(".container-accept").hide();
		}
	});
});

function displayinfos(msg) {
	$(".container-range").append(
		`
         <div class="container-infos">
         <img src="src/info.png" class="container-accept-bild" alt="">
         <div class="überschriftse" id="headertext">
           Info
         </div>
         <div class="container-accept-text">
           ${msg}
         </div>
         </div>
         `
	);
}
function displayerror(msg) {
	$(".container-range").append(
		`
        <div class="container-fail">
        <img src="src/outline_close_white_48dp.png" class="container-accept-bild" alt="">
        <div class="überschrifts" id="headertext">
           ERORR
       </div>
       <div class="container-accept-text">
        ${msg}
       </div>
       </div>
        `
	);
}
function displaysuccess(msg) {
	$(".container-range").append(
		`
        <div class="container-accept">
        <img src="src/accept.png" class="container-accept-bild" alt="">
        <div class="überschrift" id="headertext">
           Success
       </div>
       <div class="container-accept-text">
        ${msg}
       </div>
      </div>
        `
	);
}
