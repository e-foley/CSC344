import java.io.*;

/**
 * The SoundSplicer class is simply a container for a method that decomposes a
 * .wav file and splices it together to form a new piece of music (or sound).
 * The WavFile class referred to herein is courtesy of Dr. Andrew Greensted.
 * 
 * @author Ed Foley 
 * @version 01/11/14
 */
public class SoundSplicer
{
    /** Defines the quality of output files created with this class (8 bits mean samples range 0–255)*/
    public static final int OUTPUT_BITS = 8;
    
    /**
     * Transforms a .wav file by replacing the original audio at regular intervals
     * with a randomly offset version of the same song. The new piece is saved
     * in a new file.
     * 
     * @param  args[0]   The address of the input .wav file, sans extension
     * @param  args[1]   The length of output desired, in seconds. In practice, this value is limited by the length of the original song
     * @param  args[2]   The time interval (in seconds) devoted to playing the original song at its original timing before switching to the offset mode
     * @param  args[3]   The time interval (in seconds) devoted to playing the original song at its offset timing before switching back to normal timing
     * @param  args[4]   Whether to begin the output file with the original timing ("true") or offset timing ("false")
     */
    public static void main(String[] args)
    {        
        try
        {         
            WavFile wavFileIn = WavFile.openWavFile(new File(args[0]+".wav")); // Open the wav file specified as the first argument
            long numFramesIn = wavFileIn.getNumFrames();    // Read the number of frames in the original file
            long sampleRate = wavFileIn.getSampleRate();    // Read sample rate [samples/second] of input file
            int numChannels = wavFileIn.getNumChannels();   // Read number of channels in original file. We will match this in output
            
            // Calculate the number of frames required for the duration specified (#frames = (#frames/second)*seconds).
            //   We can't write more frames than we read, so we don't try.
            long numFramesOut = Math.min(numFramesIn,(long)(sampleRate*Double.parseDouble(args[1])));
            
            // Prepare an output file of the user-specified length with the properties determined above
            WavFile wavFileOut = WavFile.newWavFile(new File(args[0]+"_out.wav"), numChannels, numFramesOut, OUTPUT_BITS, sampleRate);
            
            // Create and load input buffer that covers the entire song.
            // The readFrames() method loads all data into a 1-D array; thus
            //   n-channel data of length i frames enters indices [ni], [ni+1], [ni+2], ..., [ni+n-1] for 0<=i<=frames.
            // Why do this for readFrames() but not writeFrames()? Ask the author of the WavFile class.
            double[] bufferIn = new double[(int)(numFramesIn * numChannels)];
            wavFileIn.readFrames(bufferIn, (int)numFramesIn);
            
            // Create output buffer for new song. For two channels, [0][i] is left channel and [1][i] is right.
            double[][] bufferOut = new double[numChannels][(int)(numFramesOut)];
            
            // Set initial values of maintainFrames, switchFrames, and switchMode to user inputs 
            int maintainFrames = (int)(Double.parseDouble(args[2]) * sampleRate);
            int switchFrames = (int)(Double.parseDouble(args[3]) * sampleRate);
            boolean switchMode = !Boolean.parseBoolean(args[4]);
            
            // We define a variable to count how many frames are left in a given state before we switch to the other one.
            // We initialize this to switchFrames or maintainFrames depending on switchMode.
            int stateFrames = switchMode ? switchFrames : maintainFrames;
            
            // Generate the random offset that will be used for the "switch" mode
            int randomOffset = (int)((numFramesIn-switchFrames)*Math.random());
            
            // Loop until all frames written or we run out of music to read in.
            // Yes, the "if (switchMode)" branches can be condensed by a considerable amount, but doing so would likely make it
            //   more difficult to adapt this code for additional functionality in the future.
            for (int i=0; i<numFramesOut; i++)
            {
                if (switchMode)
                {
                    // In switch mode, we reference a point in the song that has been randomly offset and move it to the present
                    //   position in the new song.
                    for (int j=0; j<numChannels; j++)
                        bufferOut[j][i] = bufferIn[numChannels*i+randomOffset+j];
                    
                    // Check whether it's time to leave the state; if so, do it
                    if(--stateFrames <= 0)
                    {
                        stateFrames = maintainFrames;
                        switchMode = false;
                    }
                }
                
                else
                {
                    // In maintain mode, we simply copy the song frame-by-frame
                    for (int j=0; j<numChannels; j++)
                        bufferOut[j][i] = bufferIn[numChannels*i+j];
                    
                    // Check whether it's time to leave the state; if so, do it
                    if(--stateFrames <= 0)
                    {
                        stateFrames = switchFrames;
                        switchMode = true;
                    }
                }
            }
            
            // Finally commit our output buffer to a file
            wavFileOut.writeFrames(bufferOut, (int)numFramesOut);
            
            // Close the wav files
            wavFileIn.close();
            wavFileOut.close();
        }
        
        // If something goes wrong, let the world know
        catch (Exception e)
        {
            System.err.println(e);
        }
    }    
}