ml = library("music.lib");
fl = library("filter.lib");
el = library("effect.lib");

gui(x) = vgroup("DRUM LAB",x);
midi(x) = gui(hgroup("[0] Main MIDI Controls",x));
mk(x) = midi(hgroup("[1] Keys",x));
out(x) = gui(vgroup("[2] Output Processing",x));


freq = mk(vslider("Pitch [style:knob] [tooltip: Drum-head pitch in Piano Key (PK) units]
       [unit:PK] [midi: KeyNumber]", 19, 1, 88, 1)) 
       : el.pianokey2hz;
gain = mk(vslider("Amplitude [midi: KeyVelocity] [tooltip: Note amplitude]
       [style:knob] [unit:dB]", -10, -90, 10, 0.1))
       : ml.db2linear;
gate = mk(checkbox("gate [midi: KeyDown] [tooltip: Note trigger]"));

t60 = mk(vslider("[0] Decay T60 [tooltip: String decay time]
    [style:knob] [unit:sec]", 
    4, 0, 10, 0.01));

B = str(vslider("[1] Brightness [tooltip: String brightness]
    [style:knob] [midi:Brightness]", 0.5, 0, 1, 0.01));
    // MIDI Controller 0x74 is often "brightness" (or VCF lowpass cutoff freq)

// Defaults 130 and 5000 Hz based loosely on Celestion 12" measurements:
sf1  = spkr(vslider("[3] LF Edge 
       [tooltip: Speaker low-frequency band-edge]
       [style:knob] [unit:Hz]",
       130,20,1000,1));
sf2  = spkr(vslider("[4] HF Edge 
       [tooltip: Speaker high-frequency band-edge]
       [style:knob] [unit:Hz]",
       5000,1000,10000,1));

level = out(vslider("[2] Level 
      [style:knob] [tooltip:Overall output level in dB]
      [unit:dB] [midi:Volume]", 
      0, -70, 10, 0.1))
      : ml.db2linear;

pole = fl.tau2pole(t60/6.91);
env = (gain * gate) : fl.pole(pole);
excitation = ml.noise * gate * env;
kick = (level * env * excitation) : fl.nlf2(freq,pole);
process = kick;




