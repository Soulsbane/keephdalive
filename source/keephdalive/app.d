import simpleserver;

class KeepAliveApp : CommandServer
{
	override void onCommand(const string command)
	{
		switch(command)
		{
			case "restart": break;
			case "start": break;
			case "pause": break;
			case "resume": break;
			default: break;
		}
	}

	override void onCommand(const string command, const string subCommand)
	{
	}

	override void onCommand(const string command, const string subCommand, const string value)
	{
		if(command == "add" && subCommand == "location")
		{
			import std.stdio : writeln;
			writeln(value);
			// Add value
		}

	}

	override void onNoCommands(){}
}

int main(string[] arguments)
{
	auto app = new KeepAliveApp;
	app.start();

	return 0;
}
