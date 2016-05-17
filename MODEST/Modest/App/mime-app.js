const electron = require("electron");
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
var mainWindow = null;

// Quit when all windows are closed.
app.on("window-all-closed", function()
{
	app.quit();
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on("ready", function()
{
	// Parse command line
	var port = null;
	for(var i = 0; i < process.argv.length; ++i)
	{
		var arg = process.argv[i];
		if(arg.length > 7 && arg.substr(0, 7) == "--port=") port = arg.substr(7);
	}

	// Set app menu on Mac
	if(process.platform == "darwin")
	{
		var name = app.getName();
		var template =
		[{
			label: name,
			submenu: [
				{
					label: "About " + name,
					role: "about"
				},
				{
					type: "separator"
				},
				{
					label: "Quit",
					accelerator: "Command+Q",
					click: function() { app.quit(); }
				},
			]
		}];
		var Menu = require("menu");
		Menu.setApplicationMenu(Menu.buildFromTemplate(template));
	}

	// Open browser window
	mainWindow = new BrowserWindow({ width: 960, height: 700, icon: __dirname + "/mime-app.png" });
	if(process.platform != "darwin") mainWindow.setMenu(null);
	mainWindow.loadURL("file://" + __dirname + "/../Main.html?" + port);
	mainWindow.on("closed", function()
	{
		// Dereference the window object, usually you would store windows
		// in an array if your app supports multi windows, this is the time
		// when you should delete the corresponding element.
		mainWindow = null;
	});
});