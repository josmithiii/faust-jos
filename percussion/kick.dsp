sc = library("sc.lib"); // SuperCollider compatibility library
ml = library("music.lib");
// fl = library("filter.lib");
   smooth(s) = *(1.0 - s) : + ~ *(s); // all we presently need

// Port from SuperCollider (SC) to Faust of SOSkick in 
// <SuperCollider>/examples/demonstrations/DrumSynths.scd
// based on a Sound-on-Sound 'synth secrets' tutorial:
// http://www.soundonsound.com/sos/jan02/articles/synthsecrets0102.asp

// for faust2octave test:
// gate = 1-1';
// amp = 1.0;
// freq = 50.0;
// mod_freq = 5.0;
// mod_index = 5.0;
// sustain = 0.4;
// beater_noise_level = 0.025;

gate = checkbox("Kick!");
ampdb  = vslider("[1] amp_db [unit:dB] 
   [style:knob] [tooltip: Volume level in decibels]",-20,-60,40,0.1);
amp = ampdb : smooth(0.999) : ml.db2linear;
freq = vslider("freq [style:knob]", 50.0, 0, 1000, 0.1);
mod_freq = vslider("mod_freq [style:knob]", 5.0, 0, 1000, 0.1);
mod_index = vslider("mod_index [style:knob]", 5.0, 0, 20, 0.1);
sustain = vslider("sustain [style:knob]", 0.4, 0, 3, 0.1);
beater_noise_level = vslider("beater_noise_level [style:knob]", 0.025, 0, 1, 0.01);

trigger = gate>gate';
pitch_contour = sc.line(freq*2, freq, 0.02, trigger);
// drum_osc = PMOsc.ar( pitch_contour, mod_freq, mod_index/1.3);
drum_osc = sc.pmosc(pitch_contour, mod_freq, mod_index/1.3);
drum_lpf = drum_osc : sc.lpf(1000);
drum_env = drum_lpf * sc.perc(0.005,sustain,trigger);
//       = drum_lpf * EnvGen.ar(Env.perc(0.005, sustain), 1.0, doneAction: 2);
// EnvGen.ar(envelope, gate, levelScale, levelBias, timeScale, doneAction)
// *perc(attackTime(0.01), releaseTime(1.0), peakLevel(1.0), curve(-4))
beater_source = ml.noise * beater_noise_level;
beater_hpf = beater_source : sc.hpf(500);
lpf_cutoff_contour = sc.line(6000, 500, 0.03, trigger);
beater_lpf = beater_hpf : sc.lpf(lpf_cutoff_contour);
beater_env = beater_lpf * sc.perc(0.01, 1.0, trigger);
//         = beater_lpf * EnvGen.ar(Env.perc, gate:1.0, doneAction: 2);
// EnvGen.ar(envelope, gate, levelScale, levelBias, timeScale, doneAction)
kick_mix = (drum_env + beater_env) * 2 * amp;
//
process = kick_mix;
//process = beater_hpf;
//process = beater_env;
//process = drum_env;
//process = drum_lpf;




