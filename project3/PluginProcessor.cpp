/*
  ==============================================================================

    Ed Foley's Amplifier-Distorter-Canceller-Doer
	CSC 344: Music Programming Lab 3
	February 12, 2014

	Plugin processor

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

const float defaultGain = 1.0f;
const float defaultFreq = 523.25f;		// Corresponds to  C5
const float defaultDistortion = 0.0f;

//==============================================================================
PlugTestAudioProcessor::PlugTestAudioProcessor()
	: delayBuffer(2, 4411)		// buffer is about 1/10 second
{
	// Set up some default values..
	gain = defaultGain;
	freq = defaultFreq;
	distortion = defaultDistortion;

	lastUIWidth = 550;
	lastUIHeight = 480;

	lastPosInfo.resetToDefault();
	delayPosition = 0;
}

PlugTestAudioProcessor::~PlugTestAudioProcessor()
{
}

//==============================================================================
const String PlugTestAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

int PlugTestAudioProcessor::getNumParameters()
{
    return 0;
}

float PlugTestAudioProcessor::getParameter(int index)
{
	// This method will be called by the host, probably on the audio thread, so
	// it's absolutely time-critical. Don't use critical sections or anything
	// UI-related, or anything at all that may block in any way!
	switch (index)
	{
		case gainParam:			return gain;
		case freqParam:			return freq;
		case distortionParam:	return distortionParam;
		default:				return 0.0f;
	}
}

void PlugTestAudioProcessor::setParameter(int index, float newValue)
{
	// This method will be called by the host, probably on the audio thread, so
	// it's absolutely time-critical. Don't use critical sections or anything
	// UI-related, or anything at all that may block in any way!
	switch (index)
	{
		case gainParam:			gain = newValue;  break;
		case freqParam:			freq = newValue;  break;
		case distortionParam:	distortion = newValue; break;
		default:				break;
	}
}

const String PlugTestAudioProcessor::getParameterName(int index)
{
	switch (index)
	{
		case gainParam:		    return "gain";
		case freqParam:			return "freq";
		case distortionParam:	return "distortion";
		default:				break;
	}

	return String::empty;
}

const String PlugTestAudioProcessor::getParameterText(int index)
{
	return String(getParameter(index), 2);
}

const String PlugTestAudioProcessor::getInputChannelName (int channelIndex) const
{
    return String (channelIndex + 1);
}

const String PlugTestAudioProcessor::getOutputChannelName (int channelIndex) const
{
    return String (channelIndex + 1);
}

bool PlugTestAudioProcessor::isInputChannelStereoPair (int index) const
{
    return true;
}

bool PlugTestAudioProcessor::isOutputChannelStereoPair (int index) const
{
    return true;
}

bool PlugTestAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool PlugTestAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool PlugTestAudioProcessor::silenceInProducesSilenceOut() const
{
    return false;
}

double PlugTestAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int PlugTestAudioProcessor::getNumPrograms()
{
    return 0;
}

int PlugTestAudioProcessor::getCurrentProgram()
{
    return 0;
}

void PlugTestAudioProcessor::setCurrentProgram (int index)
{
}

const String PlugTestAudioProcessor::getProgramName (int index)
{
    return String::empty;
}

void PlugTestAudioProcessor::changeProgramName (int index, const String& newName)
{
}

//==============================================================================
void PlugTestAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    // Use this method as the place to do any pre-playback
    // initialisation that you need..;
	delayBuffer.clear();
}

void PlugTestAudioProcessor::releaseResources()
{
    // When playback stops, you can use this as an opportunity to free up any
    // spare memory, etc.
}

void PlugTestAudioProcessor::processBlock (AudioSampleBuffer& buffer, MidiBuffer& midiMessages)
{
	const int numSamples = buffer.getNumSamples();
	int channel, dp, offset = 0;

	// Go through the incoming data, and apply our gain to it...
	for (channel = 0; channel < getNumInputChannels(); ++channel)
		buffer.applyGain(channel, 0, buffer.getNumSamples(), gain);

	// Calculate offset based on target kill frequency
	offset = delayBuffer.getNumSamples() - (int)(round(SAMPLE_RATE / freq));

	// Apply our effects to the new output..
	for (channel = 0; channel < getNumInputChannels(); ++channel)
	{
		float* channelData = buffer.getSampleData(channel);
		float* delayData = delayBuffer.getSampleData(jmin(channel, delayBuffer.getNumChannels() - 1));
		dp = delayPosition;

		for (int i = 0; i < numSamples; ++i)
		{
			// For fast, easy reference
			const float in = channelData[i];			

			delayData[dp] = in;
			channelData[i] = in - 1.0f * delayData[(dp + offset) % delayBuffer.getNumSamples()];

			// Apply distortion. 0.0 distortion leads to no change to input, but as distortion increases, output
			//     comes to resemble a square wave.
			channelData[i] *= (distortion + 1.0f) / (distortion * abs(channelData[i]) + 1.0f);

			// Include this so we don't exceed our amplitude limits, for example, if the current and delayed sample
			//   summ to an absolute value greater than 1.0.
			channelData[i] = jmax(jmin(channelData[i], 1.0f), -1.0f);

			if (++dp >= delayBuffer.getNumSamples())
				dp = 0;
		}
	}

	delayPosition = dp;

	// In case we have more outputs than inputs, we'll clear any output
	// channels that didn't contain input data, (because these aren't
	// guaranteed to be empty - they may contain garbage).
	for (int i = getNumInputChannels(); i < getNumOutputChannels(); ++i)
		buffer.clear(i, 0, buffer.getNumSamples());

	// ask the host for the current time so we can display it...
	AudioPlayHead::CurrentPositionInfo newTime;

	if (getPlayHead() != nullptr && getPlayHead()->getCurrentPosition(newTime))
	{
		// Successfully got the current time from the host..
		lastPosInfo = newTime;
	}
	else
	{
		// If the host fails to fill-in the current time, we'll just clear it to a default..
		lastPosInfo.resetToDefault();
	}
}

//==============================================================================
bool PlugTestAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

AudioProcessorEditor* PlugTestAudioProcessor::createEditor()
{
    return new PlugTestAudioProcessorEditor (this);
}

//==============================================================================
void PlugTestAudioProcessor::getStateInformation (MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
}

void PlugTestAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
}

//==============================================================================
// This creates new instances of the plugin..
AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new PlugTestAudioProcessor();
}
