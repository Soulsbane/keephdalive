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

	bool addLocation(const string path, const bool shouldWrite = false)
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

				locations_ ~= normalizedFilePath;
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
	void loadLocations()
	{
		immutable string locationsFile = buildNormalizedPath(path_.getDir("config"), WRITE_TO_LOCATIONS_FILENAME);

		ensureFileExists(locationsFile, DEFAULT_LOCATIONS_DATA);
		immutable auto lines = locationsFile.readText.splitLines();

		foreach(filePath; lines)
		{
			addLocation(filePath);
		}
	}

	bool locationAlreadyExists(const string path) const
	{
		return locations_.canFind(path);
	}

private:
	string[] locations_;
	ConfigPath path_;
	string writeToFileName_ = DEFAULT_WRITE_TO_FILENAME;
}
