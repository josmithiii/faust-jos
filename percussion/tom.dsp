ml = library("music.lib");
ol = library("oscillator.lib");
sc = library("sc.lib"); // SuperCollider compatibility library
// fl = library("filter.lib");
   smooth(s) = *(1.0 - s) : + ~ *(s); // all we presently need

// Port from SuperCollider (SC) to Faust of SynthDef \SOStom in 
// <SuperCollider>/examples/demonstrations/DrumSynths.scd
// e.g., /usr/local/share/SuperCollider/examples/demonstrations/DrumSynths.scd
// based on a Sound-on-Sound 'synth secrets' tutorial:
// http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp

// SOStom -------
// http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp

ampdb  = vslider("[1] amp_db [unit:dB] 
   [tooltip: Volume level in decibels] [style:knob]",-20,-60,40,0.1);
amp = ampdb : smooth(0.999) : ml.db2linear;

gate = checkbox("gate [3] [tooltip:noteOn = 1, noteOff = 0]");
trigger = gate > gate';

freq = vslider("freq [style:knob]", 90, 0, 10000, 1);
sustain = vslider("sustain [style:knob]", 0.4, 0, 10, 0.01);
drum_timbre = vslider("drum_timbre [style:knob]", 1.0, 0, 10, 0.01);
drum_mode_level = vslider("drum_mode_level [style:knob]", 0.25, 0, 10, 0.01);

// freq = 90;
// sustain = 0.4;
// drum_timbre = 1.0;
// drum_mode_level = 0.25;

drum_mode_env = sc.perc(0.005, sustain, trigger);
drum_mode_sin_1 = sc.sinosc0(freq*0.8) * drum_mode_env * 0.5;
drum_mode_sin_2 = sc.sinosc0(freq) * drum_mode_env * 0.5;
drum_mode_pmosc = sc.pmosc(ol.saw2(freq*0.9), freq*0.85, drum_timbre/1.3)
		  * drum_mode_env * 5;
drum_mode_mix = (drum_mode_sin_1 + drum_mode_sin_2 + drum_mode_pmosc)
	      * drum_mode_level;
stick_noise = sc.crackle(2.01);
stick_env = sc.perc(0.005, 0.01, trigger) * 3;
tom_mix = (drum_mode_mix + stick_env) * 2 * amp;

process = tom_mix;
//y:process = drum_mode_mix;
//y:process = drum_mode_sin_1;
//y:process = drum_mode_pmosc;
//y:process = stick_env;




