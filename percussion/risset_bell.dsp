// Risset Bell
// Ported from SuperCollider implementation by Matthew Shanley:
// http://blog.littlesecretsrecords.com/2011/09/26/risset-bell-in-supercollider/
// which came from a Pd version such as this one:
// http://crca.ucsd.edu/~msp/techniques/v0.11/book-html/node71.html

import("oscillator.lib");

// ======= Basic Parameters gate/gain/freq/xpose ==========
gate = checkbox("[0]gate [tooltip:noteOn = 1, noteOff = 0]");
gain = vslider("[1]gain [tooltip:Gain (value between 0 and 1)] [style:knob]",1,0,1,0.01); 
freq = 2^(transpose/12)*vslider("[2]freq [unit:Hz] 
  [tooltip:Tone frequency] [style:knob]",440,20,1200,1);
dur = vslider("[3]dur [unit:seconds]
  [tooltip:Overall duration in seconds] [style:knob]",4,0.1,120,0.1);
transpose = vslider("[4]transpose [unit:semitones] 
  [tooltip:Transposition] [style:knob]",0,-12,12,0.1);

process = 
    partial(1, 1, 0.56, 0) +
    partial(0.67, 0.9, 0.56, 1) +
    partial(1, 0.65, 0.92, 0) +
    partial(1.8, 0.55, 0.92, 1.7) +
    partial(2.67, 0.325, 1.19, 0) +
    partial(1.67, 0.35, 1.7, 0) +
    partial(1.46, 0.25, 2, 0) +
    partial(1.33, 0.2, 2.74, 0) +
    partial(1.33, 0.15, 3, 0) +
    partial(1, 0.1, 3.76, 0) +
    partial(1.33, 0.075, 4.07, 0) 
with {
    att = 0.005;
    partial(amp,rdur,rfreq,detune) = amp * 0.1 * 
      oscrs(rfreq*freq*2^transpose+detune) *
        adsr(att, 0, 1.0, dur*rdur, envgate(int(att*SR)));
//  EnvGen.ar(Env.perc(att,dur,peak))) -> peak*adsr(att,0,1.0,dur,envgate);
    trigger = gate > gate';
    decay(n,x) = x - (x>0.0)/n;
    release(n) = + ~ decay(n);
    envgate(n) = trigger : release(n) : >(0.0);
};




