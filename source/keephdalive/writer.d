module keephdalive.writer;

import std.stdio;
import std.datetime;
import std.path;
import std.file;
import std.string;
import std.algorithm;

import simpletimers.repeating;
import dpathutils;
import dfileutils;
import keephdalive.locations;

immutable string WRITE_TO_LOCATIONS_FILENAME = "locations.dat";
immutable string DEFAULT_LOCATIONS_DATA = "./\n";
immutable string DEFAULT_WRITE_TO_FILENAME = "keephdalive.txt"; // TODO: Perhaps make it hidden.

class KeepAliveWriter : RepeatingTimer
{
	this()
	{
		path_.create("Raijinsoft", "keephdalive");
		loadLocations();
	}

	bool addLocation(const string path, const bool shouldWrite = true)
	{
		if(path.exists)
		{
			immutable string normalizedFilePath = buildNormalizedPath(path, writeToFileName_);
			immutable string locationsFile = buildNormalizedPath(path_.getDir("config"), WRITE_TO_LOCATIONS_FILENAME);
			immutable bool alreadyKnownLocation = locations_.exists(path);

			if(!alreadyKnownLocation)
			{
				if(shouldWrite)
				{
					auto f = File(locationsFile, "a");
					f.writeln(path);
				}

				locations_.insert(normalizedFilePath);
				return true;
			}
			else
			{
				return false;
			}
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
	void loadLocations()
	{
		immutable string locationsFile = buildNormalizedPath(path_.getDir("config"), WRITE_TO_LOCATIONS_FILENAME);

		ensureFileExists(locationsFile, DEFAULT_LOCATIONS_DATA);
		immutable auto lines = locationsFile.readText.splitLines();

		foreach(filePath; lines)
		{
			addLocation(filePath, false);
		}
	}

private:
	Locations locations_;
	ConfigPath path_;
	string writeToFileName_ = DEFAULT_WRITE_TO_FILENAME;
}
