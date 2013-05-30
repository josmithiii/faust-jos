import("oscillator.lib");
import("filter.lib");
import("instrument.lib");

transpose = vslider("[0] midi/transpose[unit:semitones] 
	  [tooltip:Transposition] [style:knob]",0,-12,12,0.1);
freq = 2^(transpose/12)*vslider("midi/freq [1][unit:Hz] 
          [tooltip:Tone frequency] [style:knob]",440,20,20000,1);
gate = checkbox("midi/gate [1] [tooltip:noteOn = 1, noteOff = 0]");
ampdb = vslider("[1] amp_db [unit:dB] [tooltip: Sawtooth waveform
      	amplitude] [style:knob]",-10,-60,40,0.1); 
amp = ampdb : db2linear : smooth(0.999) : *(gate);
res = vslider("Corner Resonance [3] [tooltip: Amount of VCF corner
      resonance (0 to 1)] [style:knob]", 0.5, 0, 1, 0.01);
portamento = vslider("[4] Portamento [unit:sec]
	     [tooltip: Portamento (frequency-glide) time-constant in seconds] [style:knob]",
	     0.01,0.01,1,0.001);

sfreq = freq : smooth(tau2pole(portamento));

signal = amp * pink_noise;

vcf = moog_vcf_2b(res,sfreq);

process = signal : vcf; // : stereoizer(SR/freq);




