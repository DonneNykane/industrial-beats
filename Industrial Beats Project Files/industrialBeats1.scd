// Benjamin Donnelly
// Ionian University / Glasgow Caledonian University

// Industrial Beat Generator
// Use the position of the mouse cursor to control pitch envelope and oscillator feedback. Perform quick gestures to create interesting results!




// execute this code block first to define the synths
(
// Kick Drum
//
// Simple kick drum synthesised using subractive methods

SynthDef("kickDrum",
	{arg freq = 220, release = 0.1,  amp = 1;
		
		var pitchEnv, ampEnv, noiseEnv, body, click, snd;
		
		pitchEnv = Env.perc(releaseTime: release, level: freq).kr(2);
		ampEnv = Env.perc(releaseTime: release, level: amp).kr(2);
		noiseEnv = Env.perc(releaseTime: 0.05, level: amp/10).kr();
		
		body = SinOsc.ar(freq: pitchEnv, mul: ampEnv );
		click = WhiteNoise.ar(mul: noiseEnv);
		snd = HPF.ar(in: body + click, freq:  40, mul: amp);
		
		Out.ar(0, Splay.ar(snd));		
	}
).add;

//
// Snare
//
// Using a 909 snare drum sample. PLEASE UPDATE THE FILENAME WITH YOUR OWN FILE LOCATION!

~snareBuff = Buffer.read(s, "/Users/ben/Documents/Ionian University/A&I/909Snare.wav");

SynthDef("snare",
	{arg amp = 1;
		
		var snd = PlayBuf.ar(1, ~snareBuff, doneAction: 2);

		Out.ar(0, Splay.ar(snd));
	}
).add;


//
// Hi-Hats
//
// Simple hi-hats synthesised using white noise

SynthDef("hiHats",
	{arg release = 0.1, amp = 1;
		
		var ampEnv, snd;
		
		ampEnv = Env.perc(releaseTime: release, level: amp).kr(2);
		snd = WhiteNoise.ar(mul: ampEnv);
		
		Out.ar(0, Splay.ar(snd));
	}
).add;


//
// PM Synth Algorithms
//
// The Phase Modulation Syntheisiser can be played with six different modulation algorithms, the archetecture of which has been heavily inspired by the ALM Busy Circuits 'Akemie's Taiko', a eurorack format percussion synthesiser (please see the manual for the Akemie's Taiko for more information).
//
// Algorithms 1 & 2 use two operators (oscillators), the rest use four.
// 
// Arguments with the suffix "A" relate to odd numbered operators, those with the suffix "B" relate to even numbered operators.
//
// The notation "-->" means "modulates", e.g. "Op1 --> Op2" means Operator 2 phase modulated by Operator 1.
// The notation "+" means "and", e.g. "Op1 + Op2" means the output we hear is the sound of each operator.
//
// Feedback of certain operators (lone operators or those at the top of a modulation chain) is controlled by the cursor's x axis position.
// The amount of pitch envelope applied to all operators os controlled by the cursor's y axis position.
//
// "rel" arguments define the release/decay times of the amplitude envelopes.
// "ratio" arguments define what ratio the operators should relate to the base frequency by (e.g. ratioA = 2 means that odd numbered operators will have a frequency of 2 * freq
// "mod" arguments define the strength of the phase modulation by modifying the amplitude of the modulating operators

SynthDef("Algorithm1",		// Op1 --> Op2
	{arg freq = 82.41, fback = 0, ampA = 0.5, ampB = 0.5, relA = 1, relB = 1, ratioA = 0.5, ratioB = 1, modA = 1, modB = 1, pitchAmp = 1;		// arguments accepted by the synth
		
		var envA, envB, pitchEnv, operator1, operator2, snd;	// create modulation and sound variables

		envA = Env.perc(releaseTime: relA, level: ampA).kr();	// amp envelope of operators 1 & 3
		envB = Env.perc(releaseTime: relB, level: ampB).kr(2);	// amp envelope of operators 2 & 4
		pitchEnv = Env.perc(releaseTime: 0.1, level: MouseY.kr(0, freq)).kr();	// pitch envelope for all operators
		
		operator1 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: fback + MouseX.kr(0, 2), mul: envA);
		operator2 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioB), phase: (operator1 * modA), mul: envB); // phase of oscillator being modulated by operator 1 * modulation amount
		
		snd = operator2;	// outputting the operator or combination of operators we want to hear
		
		Out.ar(0, Splay.ar(snd));	// outputs from both speakers
	}
).add;


SynthDef("Algorithm2",		// Op1 + Op2
	{arg freq = 220, fback = 0, ampA = 0.5, ampB = 0.5, relA = 1, relB = 1, ratioA = 0.5, ratioB = 1, modA = 1, modB = 1, pitchAmp = 1;
		
		var envA, envB, pitchEnv, operator1, operator2, snd;

		envA = Env.perc(releaseTime: relA, level: ampA).kr();
		envB = Env.perc(releaseTime: relB, level: ampB).kr(2);
		pitchEnv = Env.perc(releaseTime: 0.1, level: MouseY.kr(0, freq)).kr();
		
		operator1 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: (fback + MouseX.kr(0, 2)), mul: envA);
		operator2 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioB), feedback: (fback + MouseX.kr(0, 2)), mul: envB);
		
		snd = operator1 + operator2;
		
		Out.ar(0, Splay.ar(snd));
	}
).add;


SynthDef("Algorithm3",		// Op1 --> Op2 --> Op3 --> Op4
	{arg freq = 220, fback = 0, ampA = 0.5, ampB = 0.5, relA = 1, relB = 1, ratioA = 0.5, ratioB = 1, modA = 1, modB = 1, pitchAmp = 1;
		
		var envA, envB, pitchEnv, operator1, operator2, operator3, operator4, snd;

		envA = Env.perc(releaseTime: relA, level: ampA).kr();
		envB = Env.perc(releaseTime: relB, level: ampB).kr(2);
		pitchEnv = Env.perc(releaseTime: 0.1, level: MouseY.kr(0, freq)).kr();
		
		operator1 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: (fback + MouseX.kr(0, 2)), mul: envA);
		operator2 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioB), phase: (operator1 * modA), mul: envB);
		operator3 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioA), phase: (operator2 * modB), mul: envA);
		operator4 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioB), phase: (operator3 * modA), mul: envB);
		
		snd = operator4;
		
		Out.ar(0, Splay.ar(snd));
	}
).add;


SynthDef("Algorithm4",		// (Op1 --> Op2) + (Op3 --> Op4)
	{arg freq = 220, fback = 0, ampA = 0.5, ampB = 0.5, relA = 1, relB = 1, ratioA = 0.5, ratioB = 1, modA = 1, modB = 1,  pitchAmp = 1;
		
		var envA, envB, pitchEnv, operator1, operator2, operator3, operator4, snd;

		envA = Env.perc(releaseTime: relA, level: ampA).kr();
		envB = Env.perc(releaseTime: relB, level: ampB).kr(2);
		pitchEnv = Env.perc(releaseTime: 0.1, level: MouseY.kr(0, freq)).kr();

		operator1 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: (fback + MouseX.kr(0, 2)), mul: envA);
		operator2 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioB), phase: (operator1 * modA), mul: envB);
		operator3 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: (fback + MouseX.kr(0, 2)), mul: envA);
		operator4 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioB), phase: (operator3 * modA), mul: envB);
		
		snd = operator2 + operator4;
		
		Out.ar(0, Splay.ar(snd));
	}
).add;


SynthDef("Algorithm5",		// Op1 + (Op2 --> Op3 --> Op4)
	{arg freq = 220, fback = 0, ampA = 0.5, ampB = 0.5, relA = 1, relB = 1, ratioA = 0.5, ratioB = 1, modA = 1, modB = 1, pitchAmp = 1;
		
		var envA, envB, pitchEnv, operator1, operator2, operator3, operator4, snd;

		envA = Env.perc(releaseTime: relA, level: ampA).kr();
		envB = Env.perc(releaseTime: relB, level: ampB).kr(2);
		pitchEnv = Env.perc(releaseTime: 0.1, level: MouseY.kr(0, freq)).kr();

		operator1 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: (fback + MouseX.kr(0, 2)), mul: envA);
		operator2 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioB), feedback: (fback + MouseX.kr(0, 2)), mul: envB);
		operator3 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioA), phase: (operator2 * modB), mul: envA);
		operator4 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioB), phase: (operator3 * modA), mul: envB);
		
		snd = operator1 + operator4;
		
		Out.ar(0, Splay.ar(snd));
	}
).add;


SynthDef("Algorithm6",		// Op1 + (Op2 --> Op3) + Op4
	{arg freq = 220, fback = 0, ampA = 0.5, ampB = 0.5, relA = 1, relB = 1, ratioA = 0.5, ratioB = 1, modA = 1, modB = 1,  pitchAmp = 1;
		
		var envA, envB, pitchEnv, operator1, operator2, operator3, operator4, snd;

		envA = Env.perc(releaseTime: relA, level: ampA).kr();
		envB = Env.perc(releaseTime: relB, level: ampB).kr(2);
		pitchEnv = Env.perc(releaseTime: 0.1, level: MouseY.kr(0, freq)).kr();

		operator1 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioA), feedback: (fback + MouseX.kr(0, 2)), mul: envA);
		operator2 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioB), feedback: (fback + MouseX.kr(0, 2)), mul: envB);
		operator3 = SinOsc.ar(freq: ((freq + pitchEnv) * ratioA), phase: (operator2 * modB), mul: envA);
		operator4 = SinOscFB.ar(freq: ((freq + pitchEnv) * ratioB), feedback: (fback + MouseX.kr(0, 2)), mul: envB);
		
		snd = operator1 + operator3 + operator4;
		
		Out.ar(0, Splay.ar(snd));
	};
).add;
)


//
// then this one to create scores for them to play. Experiment with the different phase modulation algorithms, maybe even try to make a piece that uses them all at separate points...
// try making the Pseqs all different sizes to produce out of phase patterns!

Scale.directory;	// if you want to view more scales...

(
~bpm = 95;			// if you want to change the bpm...

~beatKick = Pbind(
	\instrument, "kickDrum",
	\amp, 1,
	\dur, 1;
);

~beatSnare = Pbind(
	\instrument, "snare",
	\amp, 0.5,
	\dur, Pseq([Rest(1), 1], inf);
);

~beatHats = Pbind(
	\instrument, "hiHats",
	\release, 0.025,
	\amp, Pseq([0.1, 0.05, 0.075, 0.05]*2, inf),
	\dur, 0.25;
);

~pmTune = Pbind(
	\instrument, "Algorithm1",
	\scale, Scale.harmonicMinor,
	\degree, Pseq([Pn(0, 16), Pn(2, 8), Pn(-1, 8)], inf),
	\ampA, 0.4,
	\ampB, 0.4,
	\relA, 0.5,
	\relB, 0.5,
	\modA, Pseq([10, 10, 15, 10], inf),
	\modB, Pseq([5, 3, 1, 5], inf),
	\ratioA, Pseq([0.5, 1, 0.75], inf),
	\ratioB, Pseq([6, 4, 8, 3], inf),
	\dur, 0.25;
);
)


//
// play! 
(
~kicker = ~beatKick.play(TempoClock(~bpm/60));
~hatter = ~beatHats.play(TempoClock(~bpm/60));
~snarer = ~beatSnare.play(TempoClock(~bpm/60));
~synthPlayer = ~pmTune.play(TempoClock(~bpm/60));
)


