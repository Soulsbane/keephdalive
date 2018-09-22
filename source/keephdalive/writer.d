module writer;

import std.stdio;
import std.path;
import std.file;
import std.algorithm;

import dpathutils;
import dfileutils;
import simpletimers.repeating;
import keephdaliveapi;

class KeepAliveWriter : RepeatingTimer
{
	this()
	{
		path_.create(COMPANY_NAME, PROGRAM_NAME);
		loadLocations();
	}

	bool addLocation(const string path, const Flag!"shouldWrite" shouldWrite = Yes.shouldWrite)
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
		locations_.each!(file => touchFile(file));
	}

private	void loadLocations()
	{
		immutable string locationsPath =  path_.getDir("config");
		immutable string locationsFile = buildNormalizedPath(path_.getDir("config"), WRITE_TO_LOCATIONS_FILENAME);

		if(!locationsPath.exists)
		{
			locationsPath.mkdirRecurse;
		}

		ensureFileExists(locationsFile, DEFAULT_LOCATIONS_DATA);
		immutable auto lines = locationsFile.readText.splitLines();

		foreach(filePath; lines)
		{
			addLocation(filePath, No.shouldWrite);
		}
	}

private:
	Locations locations_;
	ConfigPath path_;
	string writeToFileName_ = DEFAULT_WRITE_TO_FILENAME;
}
