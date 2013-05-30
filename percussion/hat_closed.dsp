ml = library("music.lib");
sc = library("sc.lib"); // SuperCollider compatibility library
// fl = library("filter.lib");
   smooth(s) = *(1.0 - s) : + ~ *(s); // all we presently need

// Port from SuperCollider (SC) to Faust of SynthDef \SOShat in 
// <SuperCollider>/examples/demonstrations/DrumSynths.scd
// e.g., /usr/local/share/SuperCollider/examples/demonstrations/DrumSynths.scd
// on Linux
// based on a Sound-on-Sound 'synth secrets' tutorial:
// http://www.soundonsound.com/sos/Jun02/articles/synthsecrets0602.asp

gate = checkbox("gate [3]
       [tooltip:noteOn = 1, noteOff = 0]");

ampdb  = vslider("[1] amp_db [unit:dB] 
   [style:knob] [tooltip: Volume level in decibels]",-20,-60,40,0.1);
amp = ampdb : ml.db2linear : smooth(0.999);

freq = vslider("freq [style:knob]", 6000.0, 0, 10000, 1);
sustain = vslider("sustain [style:knob]", 0.1, 0, 10, 0.01);

//freq = 6000;
// sustain = 0.1;

trigger = gate > gate';
//root_cymbal_square = sc.lfpulse0(freq, 0.5); // NON-bandlimited
root_cymbal_square = sc.pulse0p5(freq);
//FIXME: Above should be instead pulse(freq, 0.5) [bandlimited]
root_cymbal = root_cymbal_square <: 
    sc.pmosc(freq*1.34, 310.0/1.3) + 
    sc.pmosc(freq*2.405, 26.0/0.5) +
    sc.pmosc(freq*3.09, 11.0/3.4) + 
    sc.pmosc(freq*1.309, 0.72772);
initial_bpf_contour = sc.line(15000, 9000, 0.1, trigger);
initial_env = sc.perc(0.005, 0.1, trigger);
initial_bpf = root_cymbal : sc.bpf(initial_bpf_contour,1.0) * initial_env;
// take sqrt since "curve" was -2 while default is -4:

body_env = sqrt(sc.perc(0.005, sustain, trigger)); 
body_hpf = root_cymbal : sc.hpf(sc.line(9000, 12000, sustain, trigger)) 
	 * body_env;
cymbal_mix = (initial_bpf + body_hpf) * amp;

process = cymbal_mix;




