
const express = require("express");
const app = express(); 
var path = require('path');
const { exec } = require('child_process');

function runsh(scriptname, cb) {
	console.log("running shell" + scriptname);
	var runcmd = '/bin/bash ' + scriptname;
	exec(runcmd, (err, stdout, stderr) => {
		if (err) {
			console.log("Error occurred" + err);
			return;
		}
		console.log("-----output------");
		console.log(`stdout: ${stdout}`);
		console.log(`stderr: ${stderr}`);
		console.log("-----done------");
		if (cb) cb(stdout);
	});
}

function getFileContents(fname, nodata) { 
	try { 
		var fs = require('fs');
		var contents = fs.readFileSync(fname, 'utf8');
		return contents;
	}catch (e) { 
		return nodata
	} 
}
 
function run_web_site(port) {    
	app.use(express.static('html'));
	app.use("/", express.Router());   
	app.get("/health", function (req, res) { 
		res.send(JSON.stringify({},undefined, 4));
	});

	var status = {  
		"inprogress": false,
		"username": process.env.MY_GITHUB_USERNAME,
		"repo": process.env.MY_GITHUB_REPO,
		"email": process.env.MY_GITHUB_EMAIL,
		"ns": process.env.MY_EXPORT_NS, 
		"time": new Date().toISOString(),
		"tree": "no data",
		"stdout": "no data"
	} 

	function sendStatus (res) { 
		res.send(JSON.stringify(status),undefined, 4);
	}

	function generateScriptHandler (scriptName) { 
		var f = function (req, res) {
			console.log ("Running Script: " + scriptName)
			if (status.inprogress) {  
				sendStatus (res)
				return;
			}   
			status.inprogress=true
			status.time = new Date().toISOString()
			status.start = Date.now()
			status.elapsed = 0
			status.stdout="Pending ..." 
			status.tree = "Generating ..."  
			sendStatus (res)
			runsh(scriptName, function (stdout) {  
				status.inprogress=false;
				status.time = new Date().toISOString()
				status.elapsed = Date.now() - status.start
				status.stdout=stdout;
				status.tree = getFileContents('tree.txt', "no tree data") 
			}); 
		}
		return f;
	}

	app.get("/trigger", generateScriptHandler ( "scripts/export-current-ns.sh" ) );  
	app.get("/submitpr", generateScriptHandler ( "scripts/checkout-submit-pr.sh") );  

	app.get("/status", function (req, res) { 
		console.log ("getting /status")   
		status.time = new Date().toISOString()
		status.elapsed = Date.now() - status.start 
		status.tree = getFileContents('tree.txt', "no tree data")
		if (status.inprogress) {  
			status.stdout = getFileContents('stdout.txt', "no output") 
		}  
		res.send(JSON.stringify(status));  
	});    

	app.listen(port, function () {
		console.log("Static site hosted on port", port);
	});
} 
run_web_site(8080)  
 
 