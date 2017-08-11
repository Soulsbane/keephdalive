module keephdalive.writer;

import std.stdio;
import std.datetime;

import simpletimers.repeating;

class KeepAliveWriter : RepeatingTimer
{
	void addLocation(const string path)
	{
		locations_ ~= path;
	}

	override void onTimer()
	{
		immutable auto currentTime = Clock.currTime();
		immutable auto timeString = currentTime.toISOExtString();

		foreach(file; locations_)
		{
			auto f = File(file, "w+");
			f.write(timeString);
		}
	}

private:
	string[] locations_;
}
