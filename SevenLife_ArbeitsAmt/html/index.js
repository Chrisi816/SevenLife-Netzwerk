$("document").ready(function () {
	$(".container").hide();
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (msg.type === "OpenArbeitsAmt") {
			OpenArbeitsAmt(msg.job);
			$(".container").show();
		}
	});
});

function OpenArbeitsAmt(items) {
	$(".Arbeitsamtliste-box").html(" ");

	$.each(items, function (index, item) {
		$(".Arbeitsamtliste-box").append(
			`
         <div class="job-container"> 
                 <img src="src/outline_work_white_24dp.png" class="img-box" alt="">
                 <div class="strichs">

                 </div>
                 <h1 class="jobname">
                     ${item.label}
                 </h1>
                 <button type="button" name = "${item.jobname}" label = " ${item.label}" class="button-job">
                    Job Annnehmen
                </button>
          </div>
         `
		);
	});
}

$(".container").on("click", ".button-job", function () {
	var $button = $(this);
	var $job = $button.attr("name");
	var $label = $button.attr("label");
	CloseMenu();
	$.post(
		"http://SevenLife_ArbeitsAmt/giveJob",
		JSON.stringify({ job: $job, label: $label })
	);
});

function CloseMenu() {
	$(".container").hide();
	$.post("http://SevenLife_ArbeitsAmt/CloseMenu", JSON.stringify({}));
}

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		CloseMenu();
	}
});
