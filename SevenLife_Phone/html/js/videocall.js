// Credits https://github.com/NNakreSS/VideoCall/tree/main/nakres_VideoCall

let sender = false;
let serverId, callId;
let streaming = false;
let watching = false;
let SenderpeerConn;
var switchStatus = false;

$("document").ready(function () {
	window.addEventListener("message", function (event) {
		var msg = event.data;
		if (event.data.message === "HandleData") {
			sender ? DataPack1(event.data) : DataPack2(event.data);
		} else if (event.data.message === "Antworten") {
			document.getElementById("coming-call").style.display = "inline";
			serverId = event.data.serverId;
		} else if (event.data.message === "Aufmachen") {
			document.getElementById("wrapper").style.top = "100%";
			serverId = message.serverId;
		}
	});
});

const RTCServers = {
	iceServers: [
		{
			urls: [
				"stun:stun1.l.google.com:19302",
				"stun:stun2.l.google.com:19302",
			],
		},
	],
	iceCandidatePoolSize: 10,
};

async function createAndSendAnswer() {
	let candidateAnswer = await peerConn.createAnswer();
	await peerConn.setLocalDescription(candidateAnswer);

	let answerObject = {
		sdp: candidateAnswer.sdp,
		type: candidateAnswer.type,
	};
	sendData({
		type: "send_answer",
		answer: answerObject,
	});
}

function sendData(data) {
	data.callId = parseInt(callId);
	data.serverId = parseInt(serverId);
	$.post("https://SevenLife_Phone/sendData", JSON.stringify(data));
}

let localStream;
let peerConn;

function joinCall() {
	$.post("https://SevenLife_Phone/addStartCall");
	watching = true;

	console.log("Server id : ", serverId);
	callId = serverId;

	peerConn = new RTCPeerConnection(RTCServers);
	let canvas = document.getElementById("local-video");
	MainRender.renderToTarget(canvas);
	let stream = canvas.captureStream();

	localStream = stream;
	document.getElementById("local-video").srcObject = localStream;

	let video = document.getElementById("remote-video");
	video.srcObject = new MediaStream();

	peerConn.onicecandidate = (e) => {
		if (e.candidate == null) return;

		let candidate = new RTCIceCandidate(e.candidate);
		peerConn.addIceCandidate(candidate);
		sendData({
			type: "send_candidate",
			candidate: candidate,
		});
	};

	peerConn.ontrack = (event) => {
		event.streams[0].getTracks().forEach((track) => {
			video.srcObject.addTrack(track);
		});
	};

	localStream.getTracks().forEach(function (track) {
		peerConn.addTrack(track, localStream);
	});

	sendData({
		type: "join_call",
	});
}
async function DataPack2(data) {
	switch (data.type) {
		case "offer":
			let sessionDesc = new RTCSessionDescription(data.offer);
			await peerConn.setRemoteDescription(sessionDesc);

			createAndSendAnswer();
			break;
		case "candidate":
			let candidate = new RTCIceCandidate(data.candidate);
			peerConn.addIceCandidate(candidate);
	}
}
async function DataPack1(data) {
	switch (data.type) {
		case "answer":
			let answer = new RTCSessionDescription(data.answer);
			await SenderpeerConn.setRemoteDescription(answer);

			break;
		case "candidate":
			let candidate = new RTCIceCandidate(data.candidate);
			SenderpeerConn.addIceCandidate(candidate);
	}
}
function stopCall() {
	if (streaming) {
		streaming = false;
		sender = false;
		serverId = null;
		callId = null;
		$.post(
			"https://SevenLife_Phone/stopVideoCall",
			JSON.stringify({ serverId: serverId, callId: callId })
		);
		SenderpeerConn.close();
		MainRender.stop();
		let video = document.getElementById("remote-video");
		video.pause();
		video.srcObject = null;
	} else if (watching) {
		watching = false;
		sender = false;
		serverId = null;
		callId = null;
		peerConn.close();
		MainRender.stop();
		let video = document.getElementById("remote-video");
		$.post(
			"https://SevenLife_Phone/leaveStream",
			JSON.stringify({ serverId: serverId })
		);
		video.pause();
		video.srcObject = null;
	}
}
async function createAndSendOffer() {
	let candidateOffer = await SenderpeerConn.createOffer();
	await SenderpeerConn.setLocalDescription(candidateOffer);
	let offerObject = {
		sdp: candidateOffer.sdp,
		type: candidateOffer.type,
	};

	sendData({
		type: "store_offer",
		offer: offerObject,
	});
}

async function startCall() {
	streaming = true;
	$.post("https://SevenLife_Phone/addStartCall");
	await sendcallId();
	sender = true;

	let canvas = document.getElementById("local-video");
	MainRender.renderToTarget(canvas);
	let stream = canvas.captureStream();

	localStream = stream;
	document.getElementById("local-video").srcObject = localStream;

	SenderpeerConn = new RTCPeerConnection(RTCServers);

	localStream.getTracks().forEach(function (track) {
		SenderpeerConn.addTrack(track, localStream);
	});

	SenderpeerConn.ontrack = function (event) {
		document.getElementById("remote-video").srcObject = event.streams[0];
	};

	SenderpeerConn.onicecandidate = (e) => {
		if (e.candidate == null) return;

		console.log("sender");
		let Sendercandidate = new RTCIceCandidate(e.candidate);
		SenderpeerConn.addIceCandidate(Sendercandidate);

		sendData({
			type: "store_candidate",
			candidate: Sendercandidate,
		});
	};
	createAndSendOffer();
	$.post(
		"https://SevenLife_Phone/startCallId",
		JSON.stringify({ id: callId })
	);
}
function sendcallId() {
	callId = document.getElementById("callId-input").value;
	sendData({
		type: "store_user",
	});
}
