import("sc.lib"); // /l/fjl/sc.lib

// Port from SuperCollider to Faust of snare_stein in /l/sc/SynthDefPoolBag.sc
// by Dan Stowell based on a sound-on-sound 'synth secrets' tutorial

// MK 38 (D1) = Acoustic Snare
// MK 59 (B2) = Ride Cymbal 2

d2 = 73.42; // = midi key 38 = Acoustic Snare (when on MIDI channel 10)

freq = nentry("h:Basic_Parameters/freq [1][unit:Hz] 
       [tooltip:Tone frequency]",d2,20,20000,1);
gain = nentry("h:Basic_Parameters/gain [2]
       [tooltip:Gain (value between 0 and 1)]",1,0,1,0.01); 
gate = button("h:Basic_Parameters/gate [3]
       [tooltip:noteOn = 1, noteOff = 0]");

lpnoise = ml.noise : fl.lowpass(3,7040);
hpnoise = ml.noise : fl.highpass(3,523);
att = 0.0005; // attack-time in seconds

snare = (0.25 + ol.oscrs(330)) * perc(att,0.055)
      + (0.25 + ol.oscrs(185)) * perc(att,0.075)
      + 0.2 * lpnoise * perc(att,0.2)
      + 0.2 * hpnoise * perc(att,0.183);

ampdb  = hslider("[1] amp_db [unit:dB] 
   [tooltip: Volume level in decibels] [style:knob]",-20,-60,40,0.1);
amp = ampdb : fl.smooth(0.999) : ml.db2linear : *(gain);

freqToNoteNumber = (log - log(440))/log(2)*12 + 69 + 0.5 : int;
key = freqToNoteNumber(freq);

//process = key;
// process = (key==38) * snare * amp;
process = snare * amp; // key filtering done externally now
//process = 0.2 * lpnoise * adsr(att,0,1.0,0.2,envgate(att));

processT = adsr(a,d,s,r,g), g with {
  // Basic envelope test:
  a = 500.0/float(SR); // 500-sample linear rise time
  d = 0;
  s = 1.0;             // multiplied times gate g = max
  r = 250.0/float(SR); // 60 dB decay time, linear on dB scale
		       // strangely computed - see code in music.lib
  fg = float(SR)/2000.0;
  duty = r*fg*2.0;
  g = pulsetrainpos(fg,duty);
};

// maybe use these later:

// Modification of 
// process = component("oscillator.lib").sawtooth_demo 

envelopeAttack =
hslider("h:Envelopes_and_Vibrato/v:Envelope_Parameters/Envelope_Attack
[5][unit:s][tooltip:Envelope attack duration] [style:knob]",0.01,0,2,0.01);

envelopeDecay =
hslider("h:Envelopes_and_Vibrato/v:Envelope_Parameters/Envelope_Decay
[5][unit:s][tooltip:Envelope decay duration] [style:knob]",0.05,0,2,0.01);

envelopeRelease =
hslider("h:Envelopes_and_Vibrato/v:Envelope_Parameters/Envelope_Release
[5][unit:s][tooltip:Envelope release duration] [style:knob]",0.1,0,2,0.01);

envelope = adsr(amp*envelopeAttack,envelopeDecay,90,
	 (1-amp)*envelopeRelease,gate); 

portamento = hslider("[5] Speed [unit:sec]
        [tooltip: Response time-constant in seconds] [style:knob]",
      0.01,0.01,1,0.001);
fr = freq : smooth(tau2pole(portamento));

res = hslider("[6] Resonance [unit:Hz]
      [tooltip: Corner resonance in Hz] [style:knob]", 200,20,1000,1);

// signal = pink_noise : *(amp) : moog_vcf_2bn(res,fr);

