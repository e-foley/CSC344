markov = [1 1 0;
          0 1 1;
          1 0 1];
      
tonemap = [4 5 6;
           5 6 7;
           6 7 8];
       
starter = 1;

ender = 3;

test = generateProgression(32, markov, tonemap, starter, ender)