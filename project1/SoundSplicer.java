import java.io.*;

public class SoundSplicer
{
    public static void main(String[] args)
    {
        try
        {
            double duration = 30.0;     // Duration of output file [seconds]
            
            // Open the wav file specified as the first argument
            WavFile wavFileIn = WavFile.openWavFile(new File("colony9.wav"));
            
            // Display information about the wav file to the terminal for fun
            //wavFileIn.display();
            
            // Read sample rate [samples/second] of input file so we can use this value for output file
            int sampleRate = (int)(wavFileIn.getSampleRate());
            
            long numFramesIn = wavFileIn.getNumFrames();
            
            // Calculate the number of frames required for specified duration for easy reference
            long numFramesOut = (long)(duration*sampleRate);
            
            // Prepare an output file with the length and sample rate determined prior
            WavFile wavFileOut = WavFile.newWavFile(new File("colony9new.wav"), 2, numFramesOut, 16, sampleRate);
            
            // Get the number of audio channels in the wav file so that we may allocate buffer space accordingly
            int numChannels = wavFileIn.getNumChannels();

            //Create input buffer covering whole song for easy access.
            double[] bufferIn = new double[(int)(numFramesIn * numChannels)];
            
            //Create output buffer for new song. [0][] is left channel; [1][] is right.
            double[][] bufferOut = new double[numChannels][(int)(numFramesOut)];
            
            // Initialize variable to count how many frames we've looked at
            int framesRead = 0;

            // Initialize a local frame counter
            long frameCounter = 0;

            
            //0.9 and 0.2 work alright
            
            int maintainFrames = (int)(0.1 * sampleRate);
            int switchFrames = (int)(0.1 * sampleRate);
            boolean switchMode = false;
            
            wavFileIn.readFrames(bufferIn, (int)numFramesIn);
            
            int stateFrames = maintainFrames;
            int randomOffset = 0;
            
            
            
            randomOffset = (int)((numFramesIn-switchFrames)*Math.random()); //TRY ONLY ONE RANDOM?
            
            // Loop until all frames written
            for (int i=0; i<numFramesOut; i++)
            {
                if (switchMode)
                {
                    //What to do in "switch" mode
                    bufferOut[0][i] = bufferIn[2*i+randomOffset];
                    bufferOut[1][i] = bufferIn[2*i+1+randomOffset];
                    
                    //bufferOut[0][i] = bufferIn[2*i+switchFrames];
                    //bufferOut[1][i] = bufferIn[2*i+1+switchFrames];
                    
                    // Check whether it's time to leave the state
                    if(--stateFrames <= 0)
                    {
                        stateFrames = maintainFrames;
                        switchMode = false;
                    }
                }
                
                else
                {
                    //What to do in "maintain" mode
                    bufferOut[0][i] = bufferIn[2*i];
                    bufferOut[1][i] = bufferIn[2*i+1];
                    
                    // Check whether it's time to leave the state
                    if(--stateFrames <= 0)
                    {
                        stateFrames = switchFrames;
                        switchMode = true;
                        
                        //randomOffset = (int)((numFramesIn-switchFrames)*Math.random());
                    }
                }
            }
            
            wavFileOut.writeFrames(bufferOut, (int)numFramesOut);
            
            // Close the wav files
            wavFileIn.close();
            wavFileOut.close();
        }
        catch (Exception e)
        {
            System.err.println(e);
        }
    }    
}