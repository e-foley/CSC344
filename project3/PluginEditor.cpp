/*
==============================================================================

	Ed Foley's Amplifier-Distorter-Canceller-Doer
	CSC 344: Music Programming Lab 3
	February 12, 2014

	Plugin editor

==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
PlugTestAudioProcessorEditor::PlugTestAudioProcessorEditor(PlugTestAudioProcessor* ownerFilter)
: AudioProcessorEditor(ownerFilter),
infoLabel(String::empty),
gainLabel("", "Throughput level:"),
freqLabel("", "Kill frequency (Hz):"),
distortionLabel("", "Distortion:"),
gainSlider("gain"),
freqSlider("freq"),
distortionSlider("distortion")
{
	// add some sliders..
	addAndMakeVisible(gainSlider);
	gainSlider.setSliderStyle(Slider::LinearVertical);
	gainSlider.addListener(this);
	gainSlider.setRange(0.0, 1.0, 0.01);

	addAndMakeVisible(freqSlider);
	freqSlider.setSliderStyle(Slider::LinearVertical);
	freqSlider.addListener(this);
	freqSlider.setRange(10.0, 1760.0, 0.01);

	addAndMakeVisible(distortionSlider);
	distortionSlider.setSliderStyle(Slider::LinearVertical);
	distortionSlider.addListener(this);
	distortionSlider.setRange(-1.0, 50.0, 0.01);

	// add some labels for the sliders..
	gainLabel.attachToComponent(&gainSlider, false);
	gainLabel.setFont(Font(11.0f));

	freqLabel.attachToComponent(&freqSlider, false);
	freqLabel.setFont(Font(11.0f));

	distortionLabel.attachToComponent(&distortionSlider, false);
	distortionLabel.setFont(Font(11.0f));

	// add a label that will display the current timecode and status..
	addAndMakeVisible(infoLabel);
	infoLabel.setColour(Label::textColourId, Colours::blue);

	// add the triangular resizer component for the bottom-right of the UI
	addAndMakeVisible(resizer = new ResizableCornerComponent(this, &resizeLimits));
	resizeLimits.setSizeLimits(150, 150, 800, 600);

	// set our component's initial size to be the last one that was stored in the filter's settings
	setSize(ownerFilter->lastUIWidth,
		ownerFilter->lastUIHeight);

	startTimer(50);
}

PlugTestAudioProcessorEditor::~PlugTestAudioProcessorEditor()
{
}

//==============================================================================
void PlugTestAudioProcessorEditor::paint(Graphics& g)
{
	g.setGradientFill(ColourGradient(Colours::white, 0, 0,
		Colours::lightsteelblue, 0, (float)getHeight(), false));
	g.fillAll();
}

void PlugTestAudioProcessorEditor::resized()
{
	infoLabel.setBounds(10, 4, 400, 25);
	gainSlider.setBounds(20, 60, 150, 400);
	freqSlider.setBounds(200, 60, 150, 400);
	distortionSlider.setBounds(380, 60, 150, 400);

	resizer->setBounds(getWidth() - 16, getHeight() - 16, 16, 16);

	getProcessor()->lastUIWidth = getWidth();
	getProcessor()->lastUIHeight = getHeight();
}

//==============================================================================
// This timer periodically checks whether any of the filter's parameters have changed...
void PlugTestAudioProcessorEditor::timerCallback()
{
	PlugTestAudioProcessor* ourProcessor = getProcessor();

	AudioPlayHead::CurrentPositionInfo newPos(ourProcessor->lastPosInfo);

	if (lastDisplayedPosition != newPos)
		displayPositionInfo(newPos);

	gainSlider.setValue(ourProcessor->gain, dontSendNotification);
	freqSlider.setValue(ourProcessor->freq, dontSendNotification);
	distortionSlider.setValue(ourProcessor->distortion, dontSendNotification);
}

// This is our Slider::Listener callback, when the user drags a slider.
void PlugTestAudioProcessorEditor::sliderValueChanged(Slider* slider)
{
	if (slider == &gainSlider)
	{
		// It's vital to use setParameterNotifyingHost to change any parameters that are automatable
		// by the host, rather than just modifying them directly, otherwise the host won't know
		// that they've changed.
		getProcessor()->setParameterNotifyingHost(PlugTestAudioProcessor::gainParam,
			(float)gainSlider.getValue());
	}
	else if (slider == &freqSlider)
	{
		getProcessor()->setParameterNotifyingHost(PlugTestAudioProcessor::freqParam,
			(float)freqSlider.getValue());
	}
	else if (slider == &distortionSlider)
	{
		getProcessor()->setParameterNotifyingHost(PlugTestAudioProcessor::distortionParam,
			(float)distortionSlider.getValue());
	}
}

//==============================================================================
// quick-and-dirty function to format a timecode string
static const String timeToTimecodeString(const double seconds)
{
	const double absSecs = fabs(seconds);

	const int hours = (int)(absSecs / (60.0 * 60.0));
	const int mins = ((int)(absSecs / 60.0)) % 60;
	const int secs = ((int)absSecs) % 60;

	String s(seconds < 0 ? "-" : "");

	s << String(hours).paddedLeft('0', 2) << ":"
		<< String(mins).paddedLeft('0', 2) << ":"
		<< String(secs).paddedLeft('0', 2) << ":"
		<< String(roundToInt(absSecs * 1000) % 1000).paddedLeft('0', 3);

	return s;
}

// quick-and-dirty function to format a bars/beats string
static const String ppqToBarsBeatsString(double ppq, double /*lastBarPPQ*/, int numerator, int denominator)
{
	if (numerator == 0 || denominator == 0)
		return "1|1|0";

	const int ppqPerBar = (numerator * 4 / denominator);
	const double beats = (fmod(ppq, ppqPerBar) / ppqPerBar) * numerator;

	const int bar = ((int)ppq) / ppqPerBar + 1;
	const int beat = ((int)beats) + 1;
	const int ticks = ((int)(fmod(beats, 1.0) * 960.0 + 0.5));

	String s;
	s << bar << '|' << beat << '|' << ticks;
	return s;
}

// Updates the text in our position label.
void PlugTestAudioProcessorEditor::displayPositionInfo(const AudioPlayHead::CurrentPositionInfo& pos)
{
	lastDisplayedPosition = pos;
	String displayText;
	displayText.preallocateBytes(128);

	displayText << String(pos.bpm, 2) << " bpm, "
		<< pos.timeSigNumerator << '/' << pos.timeSigDenominator
		<< "  -  " << timeToTimecodeString(pos.timeInSeconds)
		<< "  -  " << ppqToBarsBeatsString(pos.ppqPosition, pos.ppqPositionOfLastBarStart,
		pos.timeSigNumerator, pos.timeSigDenominator);

	if (pos.isRecording)
		displayText << "  (recording)";
	else if (pos.isPlaying)
		displayText << "  (playing)";

	infoLabel.setText(displayText, dontSendNotification);
}
