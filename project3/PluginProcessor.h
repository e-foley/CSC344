/*
==============================================================================

	Ed Foley's Amplifier-Distorter-Canceller-Doer
	CSC 344: Music Programming Lab 3
	February 12, 2014

	Plugin processor header

==============================================================================
*/

#ifndef PLUGINPROCESSOR_H_INCLUDED
#define PLUGINPROCESSOR_H_INCLUDED

#include "../JuceLibraryCode/JuceHeader.h"


//==============================================================================
/**
*/
class PlugTestAudioProcessor  : public AudioProcessor
{
public:
    //==============================================================================
    PlugTestAudioProcessor();
    ~PlugTestAudioProcessor();

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock);
    void releaseResources();

    void processBlock (AudioSampleBuffer& buffer, MidiBuffer& midiMessages);

    //==============================================================================
    AudioProcessorEditor* createEditor();
    bool hasEditor() const;

    //==============================================================================
    const String getName() const;

    int getNumParameters();

    float getParameter (int index);
    void setParameter (int index, float newValue);

    const String getParameterName (int index);
    const String getParameterText (int index);

    const String getInputChannelName (int channelIndex) const;
    const String getOutputChannelName (int channelIndex) const;
    bool isInputChannelStereoPair (int index) const;
    bool isOutputChannelStereoPair (int index) const;

    bool acceptsMidi() const;
    bool producesMidi() const;
    bool silenceInProducesSilenceOut() const;
    double getTailLengthSeconds() const;

    //==============================================================================
    int getNumPrograms();
    int getCurrentProgram();
    void setCurrentProgram (int index);
    const String getProgramName (int index);
    void changeProgramName (int index, const String& newName);

    //==============================================================================
    void getStateInformation (MemoryBlock& destData);
    void setStateInformation (const void* data, int sizeInBytes);

	enum Parameters
	{
		gainParam = 0,
		freqParam,
		distortionParam,

		totalNumParams
	};

	float gain, freq, distortion;

	// this keeps a copy of the last set of time info that was acquired during an audio
	// callback - the UI component will read this and display it.
	AudioPlayHead::CurrentPositionInfo lastPosInfo;

	int lastUIWidth;
	int lastUIHeight;

private:

	AudioSampleBuffer delayBuffer;
	int delayPosition;
	const long SAMPLE_RATE = 44100;		// samples/second
	const int DELAY_BUFFER_SIZE = 44100;

    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (PlugTestAudioProcessor)
};

#endif  // PLUGINPROCESSOR_H_INCLUDED
