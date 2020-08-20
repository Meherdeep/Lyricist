/*
The MIT License (MIT)

Copyright (c) 2014 Chris Wilson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

window.AudioContext = window.AudioContext || window.webkitAudioContext;

var audioContext = null;
var isPlaying = false;
var sourceNode = null;
var analyser = null;
var theBuffer = null;
var DEBUGCANVAS = null;
var mediaStreamSource = null;
var detectorElem,
	canvasElem,
	waveCanvas,
	noteElem,
	detuneElem,
	detuneAmount;
var songPath = "../assets/sounds/whistling3.mp3";

window.onload = function () {
	audioContext = new AudioContext();
	MAX_SIZE = Math.max(4, Math.floor(audioContext.sampleRate / 5000));	// corresponds to a 5kHz signal
	var request = new XMLHttpRequest();
	request.open("GET", songPath, true);
	request.responseType = "arraybuffer";
	request.onload = function () {
		audioContext.decodeAudioData(request.response, function (buffer) {
			theBuffer = buffer;
		});
	}
	request.send();

	detectorElem = document.getElementById("detector");
	canvasElem = document.getElementById("output");
	DEBUGCANVAS = document.getElementById("waveform");
	if (DEBUGCANVAS) {
		waveCanvas = DEBUGCANVAS.getContext("2d");
		waveCanvas.strokeStyle = "black";
		waveCanvas.lineWidth = 1;
	}
	noteElem = document.getElementById("note");

	detectorElem.ondragenter = function () {
		this.classList.add("droptarget");
		return false;
	};
	detectorElem.ondragleave = function () { this.classList.remove("droptarget"); return false; };
	detectorElem.ondrop = function (e) {
		this.classList.remove("droptarget");
		e.preventDefault();
		theBuffer = null;

		var reader = new FileReader();
		reader.onload = function (event) {
			audioContext.decodeAudioData(event.target.result, function (buffer) {
				theBuffer = buffer;
			}, function () { alert("error loading!"); });

		};
		reader.onerror = function (event) {
			alert("Error: " + reader.error);
		};
		reader.readAsArrayBuffer(e.dataTransfer.files[0]);
		return false;
	};
}

function error() {
	alert('Stream generation failed.');
}

function getUserMedia(dictionary, callback) {
	try {
		navigator.getUserMedia =
			navigator.getUserMedia ||
			navigator.webkitGetUserMedia ||
			navigator.mozGetUserMedia;
		navigator.getUserMedia(dictionary, callback, error);
	} catch (e) {
		alert('getUserMedia threw exception :' + e);
	}
}

function gotStream(stream) {
	// Create an AudioNode from the stream.
	mediaStreamSource = audioContext.createMediaStreamSource(stream);

	// Connect it to the destination.
	analyser = audioContext.createAnalyser();
	analyser.fftSize = 2048;
	mediaStreamSource.connect(analyser);
	updatePitch();
}

function toggleLiveInput() {
	audioContext.resume().then(() => {
		console.log('Playback resumed successfully.');
		$("#record-btn").prop("disabled", true);
	});
	isPlaying = true;
	if (isPlaying) {
		//stop playing and return
		// sourceNode.stop(0);
		sourceNode = null;
		analyser = null;
		isPlaying = false;
		if (!window.cancelAnimationFrame)
			window.cancelAnimationFrame = window.webkitCancelAnimationFrame;
		window.cancelAnimationFrame(rafID);
	}
	getUserMedia(
		{
			"audio": {
				"mandatory": {
					"googEchoCancellation": "false",
					"googAutoGainControl": "false",
					"googNoiseSuppression": "false",
					"googHighpassFilter": "false"
				},
				"optional": []
			},
		}, gotStream);
}

// function togglePlayback() {
// 	if (isPlaying) {
// 		//stop playing and return
// 		sourceNode.stop(0);
// 		sourceNode = null;
// 		analyser = null;
// 		isPlaying = false;
// 		if (!window.cancelAnimationFrame)
// 			window.cancelAnimationFrame = window.webkitCancelAnimationFrame;
// 		window.cancelAnimationFrame(rafID);
// 		return "start";
// 	}

// 	sourceNode = audioContext.createBufferSource();
// 	sourceNode.buffer = theBuffer;
// 	sourceNode.loop = false;

// 	analyser = audioContext.createAnalyser();
// 	analyser.fftSize = 2048;
// 	sourceNode.connect(analyser);
// 	analyser.connect(audioContext.destination);
// 	sourceNode.start(0);
// 	isPlaying = true;
// 	isLiveInput = false;
// 	updatePitch();

// 	return "stop";
// }

var rafID = null;
var tracks = null;
var buflen = 2048;
var buf = new Float32Array(buflen);

var noteStrings = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

function noteFromPitch(frequency) {
	var noteNum = 12 * (Math.log(frequency / 440) / Math.log(2));
	return Math.round(noteNum) + 69;
}

function frequencyFromNoteNumber(note) {
	return 440 * Math.pow(2, (note - 69) / 12);
}

function centsOffFromPitch(frequency, note) {
	return Math.floor(1200 * Math.log(frequency / frequencyFromNoteNumber(note)) / Math.log(2));
}

function autoCorrelate(buf, sampleRate) {
	// Implements the ACF2+ algorithm
	var SIZE = buf.length;
	var rms = 0;

	for (var i = 0; i < SIZE; i++) {
		var val = buf[i];
		rms += val * val;
	}
	rms = Math.sqrt(rms / SIZE);
	if (rms < 0.01) // not enough signal
		return -1;

	var r1 = 0, r2 = SIZE - 1, thres = 0.2;
	for (var i = 0; i < SIZE / 2; i++)
		if (Math.abs(buf[i]) < thres) { r1 = i; break; }
	for (var i = 1; i < SIZE / 2; i++)
		if (Math.abs(buf[SIZE - i]) < thres) { r2 = SIZE - i; break; }

	buf = buf.slice(r1, r2);
	SIZE = buf.length;

	var c = new Array(SIZE).fill(0);
	for (var i = 0; i < SIZE; i++)
		for (var j = 0; j < SIZE - i; j++)
			c[i] = c[i] + buf[j] * buf[j + i];

	var d = 0; while (c[d] > c[d + 1]) d++;
	var maxval = -1, maxpos = -1;
	for (var i = d; i < SIZE; i++) {
		if (c[i] > maxval) {
			maxval = c[i];
			maxpos = i;
		}
	}
	var T0 = maxpos;

	var x1 = c[T0 - 1], x2 = c[T0], x3 = c[T0 + 1];
	a = (x1 + x3 - 2 * x2) / 2;
	b = (x3 - x1) / 2;
	if (a) T0 = T0 - b / (2 * a);

	return sampleRate / T0;
}

function updatePitch(time) {
	var cycles = new Array;
	analyser.getFloatTimeDomainData(buf);
	var ac = autoCorrelate(buf, audioContext.sampleRate);

	if (ac == -1) {
		detectorElem.className = "vague";
		noteElem.innerText = "-";
	} else {
		detectorElem.className = "confident";
		pitch = ac;
		var note = noteFromPitch(pitch);
		noteElem.innerHTML = noteStrings[note % 12];
		$(".final-note").append(noteStrings[note % 12] + "4, ");
		// abcjs.renderAbc("paper", "X:1\nK:D\nDDAA|BBA2|\n");

	}

	if (!window.requestAnimationFrame)
		window.requestAnimationFrame = window.webkitRequestAnimationFrame;
	rafID = window.requestAnimationFrame(updatePitch);
}

function generateSheet() {
	document.getElementById("generate-sheet").disabled = true;
	var nodes = document.getElementById("final-note").value;
	var data = { "nodes": nodes };
	var xhr = new XMLHttpRequest();
	xhr.open("POST", "http://127.0.0.1:8000/getNodes", true);
	xhr.setRequestHeader("Content-Type", "application/json");
	xhr.send(JSON.stringify(data));
	xhr.onload = function () {
		if (this.status == 200 || this.status == 201) {
			var data = JSON.parse(this.responseText);
			console.log(data);
			$("#final-sheet").append(data);
			window.print().delay(99000);
		} else {
			console.log("Try Again");
			document.getElementById("generate-sheet").disabled = false;
		}
	};
}