import core.time;
import core.thread;

import daemonize.d;

enum SettingsUpdatedSignal = "SettingsUpdated".customSignal;
enum LocationsUpdatedSignal = "LocationsUpdated".customSignal;

alias daemon = Daemon!(
	"keephdalive",

	KeyValueList!(
		Composition!(Signal.Terminate, Signal.Quit, Signal.Shutdown, Signal.Stop), (logger)
		{
			logger.logInfo("Exiting...");
			return false;
		},
		Signal.HangUp, (logger)
		{
			logger.logInfo("Hello World!");
			return true;
		},
		SettingsUpdatedSignal, (logger)
		{
			logger.logInfo("Updated settings...");
			return true;
		},
		LocationsUpdatedSignal, (logger)
		{
			logger.logInfo("Updated locations...");
			return true;
		}
	),

	(logger, shouldExit)
	{
		while(!shouldExit())
		{
			Thread.sleep( dur!("msecs")( 50 ) );
		}

		logger.logInfo("Exiting main function!");

		return 0;
	}
);

int main(string[] arguments)
{
	version(Windows) string logFilePath = "C:\\logfile.log";
	else string logFilePath = "logfile.log";

	auto logger = new shared DloggLogger(logFilePath);
	return buildDaemon!daemon.run(logger);
}
