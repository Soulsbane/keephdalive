module keephdalive.writer;

import std.stdio;
import std.datetime;

import simpletimers.repeating;

class KeepAliveWriter : RepeatingTimer
{
	this()
	{

	}

	void addLocation(const string path)
	{
		locations_ ~= path;
	}

		void loadWriteToLocations()
	{
		immutable string locationsFile = buildNormalizedPath(path_.getDir("config"), WRITE_TO_LOCATIONS_FILENAME);

		ensureFileExists(locationsFile, DEFAULT_LOCATIONS_DATA);
		immutable auto lines = locationsFile.readText.splitLines();

		foreach(filePath; lines)
		{
			addPath(filePath);
		}
	}

	bool addPath(const string path, const bool shouldWrite = false)
	{
		if(path.exists)
		{
			immutable string normalizedFilePath = buildNormalizedPath(path, writeToFileName_);
			immutable string locationsFile = buildNormalizedPath(path_.getDir("config"), WRITE_TO_LOCATIONS_FILENAME);
			immutable bool alreadyKnownLocation = locationAlreadyExists(path);

			if(!alreadyKnownLocation)
			{
				if(shouldWrite)
				{
					auto f = File(locationsFile, "a");
					f.writeln(path);
				}

				locations_ ~= path;
				writer_.addLocation(normalizedFilePath);

				writeln("Added new path: ", path);
			}
			else
			{
				writeln("That path already exists!");
			}

			return true;
		}
		else
		{
			return false;
		}
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
	ConfigPath path_;
}
