const VF = Vex.Flow;

// Create a VexFlow renderer attaced to the DIV element "boo"
var vf = new VF.Factory({renderer: {elementId: 'boo'}});
var score = vf.EasyScore();
var system = vf.System();

system.addStave({
  voices: [
    score.voice(score.notes('A#4/h, B4, A#4/h, B4, G#4/h, D4, D4, D#4/h, D#4/h, D4, B4, C4, C4, C4, C#4/h, B4, C4, C4, D4, F#4/h, F4, C#4/h,')),
    // score.voice(score.notes('C#4/h, C#4 C#4/h, C#4 C#4/h, C#4 C#4/h, C#4 C#4/h, C#4 C#4/h, C#4 C#4/h, C#4', {stem: 'down'}))
   
  ]
}).addClef('treble').addTimeSignature('4/4');

// Draw it!
vf.draw();