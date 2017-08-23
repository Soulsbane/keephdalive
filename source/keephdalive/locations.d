module keephdalive.locations;
import std.algorithm.searching : canFind;

struct Locations
{
	void insert(const string location)
	{
		locations_ ~= location;
	}

	void clear()
	{
		locations_ = [];
	}

	size_t length()
	{
		return locations_.length;
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

unittest
{
	import fluent.asserts;

	Locations locations;
	locations.insert("Paul");
	locations.insert("Mom");
	locations.insert("Ben");
	locations.insert("Tisha");

	locations.front.should.equal("Paul");
	locations.popFront();
	locations.front.should.equal("Mom");

	locations.back.should.equal("Tisha");
	locations.popBack();
	locations.back.should.equal("Ben");
	locations[0].should.equal("Mom");

	locations.length.should.equal(2);
	locations.clear();
	locations.length.should.equal(0);
}
