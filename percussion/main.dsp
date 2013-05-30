// Test various percussion elements
main_group(x) = hgroup("Percussion Instruments",x);
hat = main_group(vgroup("hat_closed.dsp",component("hat_closed.dsp"))); // hat_closed.dsp
kick = main_group(vgroup("kick.dsp",component("kick.dsp"))); // kick.dsp
risset_bell = main_group(vgroup("risset_bell.dsp",component("risset_bell.dsp"))); // risset_bell.dsp
snare = main_group(vgroup("snare.dsp",component("snare.dsp"))); // snare.dsp
tom = main_group(vgroup("tom.dsp",component("tom.dsp"))); // tom.dsp
wind = main_group(vgroup("wind.dsp",component("wind.dsp"))); // wind.dsp
process = hat+kick+risset_bell+snare+tom+wind <: _,_;




