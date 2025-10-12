{
  output = {
    "bass_enhancer#0" = {
      amount = 0;
      blend = 3;
      bypass = false;
      floor = 20;
      floor-active = true;
      harmonics = 8.5;
      input-gain = 0;
      output-gain = 0;
      scope = 100;
    };
    blocklist = [
    ];
    "compressor#0" = {
      attack = 20;
      boost-amount = 6;
      boost-threshold = -72;
      bypass = false;
      dry = -100;
      hpf-frequency = 10;
      hpf-mode = "off";
      input-gain = 0;
      knee = -6;
      lpf-frequency = 20000;
      lpf-mode = "off";
      makeup = 0;
      mode = "Downward";
      output-gain = 0;
      ratio = 2;
      release = 250;
      release-threshold = -100;
      sidechain = {
        lookahead = 0;
        mode = "RMS";
        preamp = 0;
        reactivity = 10;
        source = "Middle";
        stereo-split-source = "Left/Right";
        type = "Feed-forward";
      };
      stereo-split = false;
      threshold = -18;
      wet = 0;
    };
    "convolver#0" = {
      autogain = true;
      bypass = false;
      input-gain = -4;
      ir-width = 100;
      kernel-name = "accudio48khz";
      output-gain = 0;
    };
    "crossfeed#0" = {
      bypass = false;
      fcut = 700;
      feed = 4.5;
      input-gain = 0;
      output-gain = 0;
    };
    "equalizer#0" = {
      balance = 0;
      bypass = false;
      input-gain = 0;
      left = {
        band0 = {
          frequency = 26;
          gain = 6;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band1 = {
          frequency = 41;
          gain = 4;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band10 = {
          frequency = 1631;
          gain = 2;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band11 = {
          frequency = 4096;
          gain = 4;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band12 = {
          frequency = 6493;
          gain = 6;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band13 = {
          frequency = 10291;
          gain = 4;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band14 = {
          frequency = 16310;
          gain = 2;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band2 = {
          frequency = 65;
          gain = 3;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band3 = {
          frequency = 103;
          gain = 1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band4 = {
          frequency = 163;
          gain = 0;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band5 = {
          frequency = 258;
          gain = -1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band6 = {
          frequency = 410;
          gain = 1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band7 = {
          frequency = 649;
          gain = -1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band8 = {
          frequency = 1029;
          gain = 0;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band9 = {
          frequency = 1631;
          gain = 0;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
      };
      mode = "IIR";
      num-bands = 15;
      output-gain = 0;
      pitch-left = 0;
      pitch-right = 0;
      right = {
        band0 = {
          frequency = 26;
          gain = 6;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band1 = {
          frequency = 41;
          gain = 4;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band10 = {
          frequency = 1631;
          gain = 2;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band11 = {
          frequency = 4096;
          gain = 4;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band12 = {
          frequency = 6493;
          gain = 6;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band13 = {
          frequency = 10291;
          gain = 4;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band14 = {
          frequency = 16310;
          gain = 2;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band2 = {
          frequency = 65;
          gain = 3;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band3 = {
          frequency = 103;
          gain = 1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band4 = {
          frequency = 163;
          gain = 0;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band5 = {
          frequency = 258;
          gain = -1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band6 = {
          frequency = 410;
          gain = 1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band7 = {
          frequency = 649;
          gain = -1;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band8 = {
          frequency = 1029;
          gain = 0;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
        band9 = {
          frequency = 1631;
          gain = 0;
          mode = "RLC (BT)";
          mute = false;
          q = 2.2;
          slope = "x1";
          solo = false;
          type = "Hi-shelf";
          width = 4;
        };
      };
      split-channels = false;
    };
    "limiter#0" = {
      alr = false;
      alr-attack = 5;
      alr-knee = 0;
      alr-release = 50;
      attack = 5;
      bypass = false;
      dithering = "None";
      external-sidechain = false;
      gain-boost = true;
      input-gain = 0;
      lookahead = 10;
      mode = "Herm Thin";
      output-gain = 0;
      oversampling = "None";
      release = 5;
      sidechain-preamp = 0;
      stereo-link = 100;
      threshold = 0;
    };
    plugins_order = [
      "limiter#0"
      "convolver#0"
      "equalizer#0"
      "bass_enhancer#0"
      "compressor#0"
      "crossfeed#0"
    ];
  };
}
