import std.stdio : writeln;

import writer;
import simpleserver;

class KeepAliveApp : CommandServer
{
	override void onStart()
	{
		writeln("Server started. Waiting for commands!");
	}

	override void onStop()
	{
		writeln("Server shutting down...");
	}

	override void onCommand(Socket client, const string command)
	{
		switch(command)
		{
			case "restart": break; // Reloads locations.dat and restarts writing.
			case "start": writer_.start(); break; // Seems pretty obvious.
			case "stop": writer_.stop(); break; // Stops all writing to files.
			case "quit": break; // Makes keephdalive process quit.
			default: writeln("Invalid Command: ", command); break;
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
		else if(command == "set")
		{
			handleSetCommand(subCommand, value);
		}
		else
		{
			writeln("Invalid command: ", command);
		}
	}

	override void onNoCommands(){}

	private void handleSetCommand(const string subCommand, const string value)
	{
		if(subCommand == "delay")
		{

		}

		if(subCommand == "filename")
		{

		}
	}

private:
	KeepAliveWriter writer_;
}

int main(string[] arguments)
{
	auto app = new KeepAliveApp;
	app.start();
	return 0;
}
