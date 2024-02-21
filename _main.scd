/*
This script exemplifies the use of SuperCollider on Bela.
When a project contains a `_main.scd` file, `sclang` is started
and the content of the file is executed.
The examples in SuperCollider/ include more code examples to interface
with Bela-specific UGens.
If you want to interact with SuperCollider running on the board
from within the SuperCollider IDE on your computer, check out
the SuperCollider/7-remote-control examples instead.
*/
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 0;
s.options.numDigitalChannels = 16;

s.options.blockSize = 32;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 8;

s.options.postln;

s.waitForBoot({
  	~outmix = Bus.audio(s,4);
	~waterbus = Bus.audio(s,4);
	~waternormal = Bus.audio(s,4);
	~waterfuture = Bus.audio(s,4);
	//~watercalm = Bus.audio(s,4);
	//~watermedium = Bus.audio(s,4);
	//~waterhigh = Bus.audio(s,4);
	//~watertorrent = Bus.audio(s,4);
	//~wateryear1 = Bus.audio(s,4);
	//~wateryear2 = Bus.audio(s,4);
	//~wateryear3 = Bus.audio(s,4);
	//~wateryear4 = Bus.audio(s,4);
	~granularbus = Bus.audio(s,4);
	~iso1bus = Bus.audio(s,4);
	~iso2bus = Bus.audio(s,4);
	~iso3bus = Bus.audio(s,4);
	~noise1bus = Bus.audio(s,4);
	~noise2bus = Bus.audio(s,4);
	~harshbus = Bus.audio(s,4);
	~effectbus = Bus.audio(s,4);

	~ctrl_debit = Bus.control(s,1);
	~ctrl_year = Bus.control(s,1);
	~ctrl_grain = Bus.control(s,1);
	~ctrl_rate = Bus.control(s,1);
	~ctrl_species = Bus.control(s,1);
	~ctrl_road = Bus.control(s,1);
	~ctrl_birds = Bus.control(s,1);
	~ctrl_harsh = Bus.control(s,1);
	~ctrl_med = Bus.control(s,1);
	~ctrl_effect = Bus.control(s,1);

	//~water1 = Buffer.read(s, "QUAD_year1.wav");
	//~water2 = Buffer.read(s, "QUAD_year2.wav");
	//~water3 = Buffer.read(s, "QUAD_year3.wav");
	//~water4 = Buffer.read(s, "QUAD_year4.wav");
	~water5 = Buffer.read(s, "STEREO_13_lointain_oiseaux.wav");
	~water6 = Buffer.read(s, "QUAD_echo.wav");
	~water7 = Buffer.read(s, "QUAD_granular.wav");
	~water8 = Buffer.read(s, "Future.wav");
	~water9 = Buffer.read(s, "QUAD_35_smallnervous.wav");
	//~water10 = Buffer.read(s, "QUAD_36_waterfall.wav");
	//~water11 = Buffer.read(s, "MONO_41_bubbles.wav");


	SynthDef("playwater4",{arg out=0, buf=0, rate=1, amp=1;
		var output = PlayBuf.ar(numChannels:4, bufnum:buf, rate:rate,loop:1);
		Out.ar(out,output*amp)
	}).send(s);

	SynthDef("playwater2",{arg out=0, buf=0, rate=1, amp=1;
		var output = PlayBuf.ar(numChannels:2, bufnum:buf, rate:rate,loop:1);
		Out.ar(out,output*amp);
		Out.ar(out+2,output*amp)
	}).send(s);

	SynthDef("river_combiner",{arg out=0, year=0, amp=1.0;
		var playA = InBus.ar(~waternormal,4,0);
		var playB = InBus.ar(~waterfuture,4,0);
		var pan = year-1;
		var play = LinXFade2.ar(inA: playA, inB: playB, pan: pan, level: amp);
		Out.ar(out,play)
	}).send(s);

	SynthDef("isochronous",{arg freq1=97.94, freq2=136.1, beat1=1.3, beat2=3.9,
		amp1=0.24, amp2=0.22, amp=0.0, out=0, isofreq=1, width=0.5; //freq3=174, freq4=285
		var sin1, sin2, brainmix, isochronic;
		sin1=SinOsc.ar([freq1-(beat1/2),freq1-beat1,freq1+(beat1/2),freq1+beat1],
			0,amp1,0);
		sin2=SinOsc.ar([freq2-(beat2/2),freq2-beat2,freq2+(beat2/2),freq2+beat2],
			0,amp2,0);
		isochronic=LFPulse.ar(isofreq,0,width,amp,0).lag(0.01);
		brainmix=Mix.new([sin1, sin2]*isochronic);
		Out.ar(out,brainmix)
	}).send(s);

	SynthDef("orage",{arg out=0, amp=0, trigfreq=22050, freq_trig=6264, stepsize_param=0.0624;
		var stepSize = Dbrown(0.0, stepsize_param, 0.01);
		var rw = Dbrown(-1.0, 1.0, stepSize);
		var trigger = Impulse.ar(freq:freq_trig);
		var z = Demand.ar(trigger, 0, rw) * 0.5;
		Out.ar(out,Pan4.ar(
			in:z,
			xpos:LFNoise1.ar(10,1),
			ypos:LFNoise1.ar(10,1),
			level:amp))
	}).send(s);

	SynthDef("Pink_Noise_Machine",{arg amp = 0.06, ffreq = 1000, rq = 0.8, out=0;
		var snd;
		amp = Lag.kr(amp, 1);
		snd = PinkNoise.ar(amp);
		snd = BPF.ar(snd, ffreq, rq);
		Out.ar(out,Pan4.ar(
			in:snd,
			xpos:LFNoise1.ar(1,0.7),
			ypos:LFNoise1.ar(1,0.7),
			level:1))
	}).send(s);

	SynthDef("Brown_Noise_Machine",{arg amp = 0.06, ffreq = 1000, rq = 0.8, out=0;
		var snd;
		amp = Lag.kr(amp, 1);
		snd = PinkNoise.ar(amp);
		snd = BPF.ar(snd, ffreq, rq);
		Out.ar(out,Pan4.ar(
			in:snd,
			xpos:LFNoise1.ar(1,0.7),
			ypos:LFNoise1.ar(1,0.7),
			level:1))
	}).send(s);

	SynthDef("param_sender_flush",{arg out=0, ctrl=1, ctrl2=0, slewlo=0.1, slewhi=0.1, amp=1;
		var button = DigitalIn.kr(ctrl);
		var cancel = DigitalIn.kr(ctrl2);
		var slew = Slew.kr(button,slewhi,slewlo);
		var slewcancel = Slew.kr(cancel,slewhi,slewlo);
		var val =Clip.kr(slew-slewcancel,0,1);
		Out.kr(out,amp*val)
	}).send(s);

	SynthDef("param_sender_rate",{arg out=0, ctrl=0, ctrl2=0, slewlo=0.1, slewhi=0.1, amp=0.2;
		var button = DigitalIn.kr(ctrl);
		var cancel = DigitalIn.kr(ctrl2);
		var slew = Slew.kr(button,slewhi,slewlo);
		var slewcancel = Slew.kr(cancel,slewhi,slewlo);
		var val = Clip.kr(slew-slewcancel,0,1);
		var rate = 1 - (val*amp);
		Out.kr(out,rate)
	}).send(s);

	SynthDef("outmix",{arg out=0, water=0.0, granular=0.0, noise1=0.0, noise2=0.0, iso1=0.0, iso2=0.0, iso3=0.0, harsh=0.0, effect=0.0;
		Out.ar(~outmix,InBus.ar(~waterbus,4,0)*water);
		Out.ar(~outmix,InBus.ar(~granularbus,4,0)*granular);
		Out.ar(~outmix,InBus.ar(~noise1bus,4,0)*noise1);
		Out.ar(~outmix,InBus.ar(~noise2bus,4,0)*noise2);
		Out.ar(~outmix,InBus.ar(~iso1bus,4,0)*iso1);
		Out.ar(~outmix,InBus.ar(~iso2bus,4,0)*iso2);
		Out.ar(~outmix,InBus.ar(~iso3bus,4,0)*iso3);
		Out.ar(~outmix,InBus.ar(~harshbus,4,0)*harsh);
		Out.ar(~outmix,InBus.ar(~effectbus,4,0)*effect);
		Out.ar(out+0,InBus.ar(~outmix,1,0));
		Out.ar(out+1,InBus.ar(~outmix,1,0));
		Out.ar(out+2,InBus.ar(~outmix,1,1));
		Out.ar(out+3,InBus.ar(~outmix,1,1));
		Out.ar(out+4,InBus.ar(~outmix,1,2));
		Out.ar(out+5,InBus.ar(~outmix,1,2));
		Out.ar(out+6,InBus.ar(~outmix,1,3));
		Out.ar(out+7,InBus.ar(~outmix,1,3))
	}).send(s);

	s.sync;
	~playfuture=Synth.new("playwater4", ['out', ~waterfuture, 'buf', ~water8, 'rate', 1, 'amp', 1], target: s);
	~playnormal=Synth.new("playwater4", ['out', ~waternormal, 'buf', ~water9, 'rate', 1, 'amp', 1], target: s);
	~playgrain=Synth.new("playwater4", ['out', ~granularbus, 'buf', ~water7, 'rate', 1, 'amp', 0.3], target: s);
	~playecho=Synth.new("playwater4", ['out', ~effectbus, 'buf', ~water6, 'rate', 1, 'amp', 1], target: s);
	~playbirds=Synth.new("playwater2", ['out', ~water, 'buf', ~water5, 'rate', 1, 'amp', 0], target: s); //amp =7

	~isosynth1=Synth.new("isochronous", ['out', ~iso1bus, 'freq1', 741, 'freq2',528, 'isofreq', 32, 'width', 0.2, 'amp', 0.1], target: s);
	~isosynth2=Synth.new("isochronous", ['out', ~iso2bus, 'isofreq', 16, 'width', 0.2, 'amp', 0.2], target: s);
	~isosynth3=Synth.new("isochronous", ['out', ~iso3bus, 'freq1', 850, 'freq2',900, 'isofreq', 32, 'width', 0.5, 'amp', 0.3], target: s); //amp = 0.3

	~noisesynth1=Synth.new("Pink_Noise_Machine", ['out', ~noise1bus, 'ffreq', 741, 'rq', 1/200, 'amp', 4], target: s);
	~noisesynth2=Synth.new("Brown_Noise_Machine", ['out', ~noise2bus, 'ffreq', 174, 'rq', 0.1, 'amp', 2], target: s);

	Synth.new("orage", ['out', ~harshbus, 'amp', 0.3], target: s); //amp = 1

	Synth.new("param_sender_flush",['out', ~ctrl_grain, 'ctrl', 1, 'ctrl2', 2, 'slewhi', 10, 'slewlo', 0.03, 'amp', 3], target: s);
	Synth.new("param_sender_flush",['out', ~ctrl_species, 'ctrl', 5, 'ctrl2', 0,'slewhi', 10, 'slewlo', 0.03, 'amp', 3], target: s);
	Synth.new("param_sender_flush",['out', ~ctrl_road, 'ctrl', 8, 'ctrl2', 9, 'slewhi', 10, 'slewlo', 0.03, 'amp', 3], target: s);
	Synth.new("param_sender_flush",['out', ~ctrl_med, 'ctrl', 6, 'ctrl2', 7, 'slewhi', 10, 'slewlo', 0.03, 'amp', 3], target: s);
	Synth.new("param_sender_flush",['out', ~ctrl_harsh, 'ctrl', 10, 'ctrl2', 14, 'slewhi', 10, 'slewlo', 0.03, 'amp', 4], target: s);
	Synth.new("param_sender_flush",['out', ~ctrl_effect, 'ctrl', 12, 'ctrl2', 13, 'slewhi', 10, 'slewlo', 0.03, 'amp', 3], target: s);

	Synth.new("param_sender_rate",['out', ~ctrl_rate, 'ctrl', 3, 'ctrl2', 4,'slewhi', 10, 'slewlo', 0.03, 'amp', 0.4], target: s);
	Synth.new("param_sender_flush",['out', ~ctrl_year, 'ctrl', 11, 'ctrl2', 15,'slewhi', 10, 'slewlo', 0.03, 'amp', 2], target: s);

	~playwater=Synth.new("river_combiner", ['out', ~waterbus,'amp', 3], target: s);
	~outmixer=Synth.new("outmix", ['water', 1], target: s);

	~playwater.map(\year, ~ctrl_year);
	~playfuture.map(\rate, ~ctrl_rate);
	~playnormal.map(\rate, ~ctrl_rate);
	~playgrain.map(\rate, ~ctrl_rate);
	~playecho.map(\rate, ~ctrl_rate);

	~outmixer.map(\granular, ~ctrl_grain);
	~outmixer.map(\effect, ~ctrl_effect);
	~outmixer.map(\iso1, ~ctrl_species);
	~outmixer.map(\iso2, ~ctrl_road);
	~outmixer.map(\iso3, ~ctrl_med);
	~outmixer.map(\noise1, ~ctrl_species);
	~outmixer.map(\noise2, ~ctrl_road);
	~outmixer.map(\harsh, ~ctrl_harsh);
	~playbirds.map(\amp, ~ctrl_birds);
	//~ctrl_year.set(0);
});
//ServerQuit.add({ 0.exit }); // quit if the button is pressed

