/*
==============================================================================

	Ed Foley's Amplifier-Distorter-Canceller-Doer
	CSC 344: Music Programming Lab 3
	February 12, 2014

	Plugin editor header

==============================================================================
*/

#ifndef __PLUGINEDITOR_H_4ACCBAA__
#define __PLUGINEDITOR_H_4ACCBAA__

#include "../JuceLibraryCode/JuceHeader.h"
#include "PluginProcessor.h"


//==============================================================================
/** This is the editor component that our filter will display.
*/
class PlugTestAudioProcessorEditor : public AudioProcessorEditor,
	public SliderListener,
	public Timer
{
public:
	PlugTestAudioProcessorEditor(PlugTestAudioProcessor* ownerFilter);
	~PlugTestAudioProcessorEditor();

	//==============================================================================
	void timerCallback() override;
	void paint(Graphics&) override;
	void resized() override;
	void sliderValueChanged(Slider*) override;

private:
	Label infoLabel, gainLabel, freqLabel, distortionLabel;
	Slider gainSlider, freqSlider, distortionSlider;
	ScopedPointer<ResizableCornerComponent> resizer;
	ComponentBoundsConstrainer resizeLimits;

	AudioPlayHead::CurrentPositionInfo lastDisplayedPosition;

	PlugTestAudioProcessor* getProcessor() const
	{
		return static_cast <PlugTestAudioProcessor*> (getAudioProcessor());
	}

	void displayPositionInfo(const AudioPlayHead::CurrentPositionInfo& pos);
};


#endif  // __PLUGINEDITOR_H_4ACCBAA__
