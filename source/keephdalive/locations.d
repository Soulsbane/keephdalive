module keephdalive.locations;
import std.algorithm.searching : canFind;

struct Locations
{
	void insert(const string location)
	{
		locations_ ~= location;
	}

	bool exists(const string path) const
	{
		return locations_.canFind(path);
	}

	@property bool empty() const
	{
		return locations_.length == 0;
	}

	@property ref string front()
	{
		return locations_[0];
	}

	void popFront()
	{
		locations_ = locations_[1 .. $];
	}

	@property ref string back()
	{
		return locations_[$ - 1];
	}

	void popBack()
	{
		locations_ = locations_[0 .. $ - 1];
	}

	string opIndex(size_t index)
	{
		return locations_[index];
	}

	@property Locations save()
	{
		return this;
	}

	string[] getLocations()
	{
		return locations_;
	}

private:
	string[] locations_;
}
