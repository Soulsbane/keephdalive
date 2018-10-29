import std.stdio : writeln;

import writer;
import simpleserver;

class KeepAliveApp : CommandServer
{
	override void onCommand(Socket client, const string command)
	{
		switch(command)
		{
			case "restart": break; // Reloads locations.dat and restarts writing.
			case "start": writer_.start(); break; // Seems pretty obvious.
			case "stop": writer_.stop(); break; // Stops all writing to files.
			case "quit": break; // Makes keephdalive process quit.
			default: break;
		}
	}

	override void onCommand(Socket client, const string command, const string subCommand)
	{
	}

	override void onCommand(Socket client, const string command, const string subCommand, const string value)
	{
		if(command == "add" && subCommand == "location")
		{
			writeln(value);
		}
		else if(command == "set" && subCommand == "delay")
		{
			writeln(value);
		}
		else
		{
			writeln("Invalid command: ", command);
		}
	}

	override void onNoCommands(){}

private:
	KeepAliveWriter writer_;
}

int main(string[] arguments)
{
	auto app = new KeepAliveApp;
	app.start();
	return 0;
}
