CSC 344 Project 2: Soft Synth
Code adapted by Ed Foley from Dr. John Clements' implementation of a JUCE demo audio plug-in
January 28, 2014
============================================================================================

This code creates a VST instrument that forms amplitude-modulated, decaying half-square, 
half-sine waves. The rate of amplitude modulation is proportional to the note's frequency,
but the decay rate is independent.

Special thanks to James Bilous for his help in getting Juce running and to Kyle Schaefer
for hanging in there with me.