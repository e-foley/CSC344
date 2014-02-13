CSC 344 Project 3: Filtering
Code adapted by Ed Foley from the JUCE demo audio plug-in
February 12, 2014
==============================================================================================

~~ Overview ~~
This code generates a VST plug-in that amplifies and distorts live audio while simultaneously
cancelling out integer multiples of a particular frequency. The gain, distortion factor, and
kill frequency are all adjustable by the user in the graphical user interface.

~~ Gain ~~
The gain is applied via JUCE's built-in applyGain function. It applies it on a logarithmic
scale such that doubling the gain doubles the perceived volume. The GUI lets the user change
this on a continuum from 0.00 to 1.00.

~~ Kill frequency ~~
This plug-in cancels particular frequencies by subtracting a delayed version of the input
from the current input. The delay is inversely proportional to the frequency specified by the
user, so that a high kill frequency corresponds to a low delay:

                sample rate
delay frames = --------------
               kill frequency

The accuracy of the frequency cancellation is dependent on the specified frequency and the
sample rate. At low sample rates and high kill frequencies, the frequency of highest
attenuation is unlikely to be that specified due to necessary rounding errors. The GUI
lets the user change this on a continuum from 10.00 to 3520.00.

~~ Distortion ~~
The distortion function takes the current sample, f(k), and transforms it to a new sample,
f'(k), by the following formula:

        (r+1)f(k)
f'(k) = ---------
        r|f(k)|+1

The variable r represents the distortion factor. It can be interpreted as how aggressively
non-maximum amplitudes are forced toward a maximum (-1.0 or +1.0). A distortion value of 0
leaves the signal untouched, but as r increases, so does the signal's resemblance to a
square wave. The GUI lets the user change this on a continuum from -1.00 to 50.00. (For
negative values of r, the samples are pushed toward 0 instead of toward a maximum.)
This algorithm was developed independently by Ed Foley, but it would not surprise him if a
similar mathematical transformation has already been described elsewhere.

It should be noted that the output is ultimately capped on the range [-1.0, 1.0] in case
the delay operation yields samples with magnitude greater than 1.0.

This concludes the technical explanation. Enjoy.