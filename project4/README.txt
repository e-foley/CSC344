CSC 344 Lab 4: Algorithmic Composition
Ed Foley
March 5, 2014
Makes use of Ken Schutte's MATLAB–MIDI code

Overview
========
This MATLAB code algorithmically generates a MIDI file using primarily random parameters.

Song structure
==============
Currently, write_a_midi.m generates a song in an A–B–A pattern where all parts are the same length and A is written in the relative minor of B or vice-versa.

Markov matrices and maps
========================
The Markov matrices defined in code represent the relative likelihood of a transition from one state to another state. These are applied to...

* Chord transitions
* Bass note transitions
* Bass note rhythm transitions
* Melody pivot tone transitions
* Melody pivot rhythm transitions
* Melody flow rate transitions

Each state is related to its significance by a corresponding map. For example, state 4 in the bass note rhythm transition matrix might be mapped to an eighth note. Markov chains generate a sequence of the mapped values for use in the actual song construction.

Seeding
=======
write_a_song called with a particular non-negative 32-bit integer will always generate the same song. If the parameter is omitted, a random seed may be used.

Scales
======
Scales are represented by a string of numbers representing half-tones above a fundamental. For example, [0 2 4 5 7 9 11] represents the "whole–whole–half–whole–whole–whole–half" gaps defining a major scale. Scales are assumed to repeat every 12 semitones.

Known issues
============
1. Under certain conditions, a melody may be absent for Part A only. This would seem to relate to a particular configuration of beatsPerChordChange, beatsPerBassRhythmChange, and related variables, but understanding the problem's cause in full demands more effort.
2. Melodies gradually fall out-of-sync relative to the bass and chord parts as a song progresses. It is not understood what causes this behavior, especially since all times are synchronized at the start of each song section. It may be an issue with the borrowed matrix2midi code.

Questions that would presumably be asked frequently if this code receives sufficient exposure
=============================================================================================
What is a melody pivot?
-----------------------
A melody pivot is a sort of waypoint or via that the melody must pass through. A pivot note is set to some interval above the tonic of the current chord—that interval governed by the melody pivot tone transition matrix—and its timing is determined by the melody pivot rhythm transition matrix.

What MATLAB syntax might be unfamiliar to non-MATLAB users?
-----------------------------------------------------------
1. An apostrophe (') transposes a matrix.
2. Two numbers separated by a colon define a row vector of integers bridging the two numbers.
3. kron(X,Y) forms a new matrix by replacing each element in X by the product of the element and the entirety of Y.
4. MATLAB does not support shorthand increment or decrement commands like ++, --, +=, etc.

Why MATLAB?
-----------
Markov models make extensive use of matrices. I wanted to use a program adept at handling them and I didn't want to worry about memory allocation concerns frequently encountered when using two-dimensional arrays in other languages.