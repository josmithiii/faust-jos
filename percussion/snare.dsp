sc = library("sc.lib"); // ../lib/sc.lib
ml = library("music.lib");
// fl = library("filter.lib");
   smooth(s) = *(1.0 - s) : + ~ *(s); // all we presently need

// Port from SuperCollider to Faust of snare_stein in
// SynthDefPool by Dan Stowell, which in turn was based
// on a Sound-on-Sound 'synth secrets' tutorial

gate = checkbox("[1] gate [tooltip:noteOn = 1, noteOff = 0]");
trigger = (gate>gate');

ampdb  = vslider("[2] amp_db [unit:dB] 
   [tooltip: Volume level in decibels] [style:knob]",-20,-60,40,0.1);
amp = ampdb : smooth(0.999) : ml.db2linear;

lpnoise = ml.noise : sc.lpf(7040);
hpnoise = ml.noise : sc.hpf(523);
att = 0.0005; // attack-time in seconds

snare = (0.25 + sc.sinosc0(330)) * sc.perc(att,0.055,trigger)
      + (0.25 + sc.sinosc0(185)) * sc.perc(att,0.075,trigger)
      + 0.2 * lpnoise * sc.perc(att,0.2,trigger)
      + 0.2 * hpnoise * sc.perc(att,0.183,trigger);

process = snare * amp; // MIDI-key 38 (D2=73.42 Hz) filtering external

