<!DOCTYPE html> 
<html> 
<head> 
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"> 
    <title>test form</title>
<style type="text/css">
body
{
	font-family: "Segoe UI", Tahoma, Helvetica, freesans, sans-serif;
	font-size: 90%;
	margin: 10px;
	color: #333;
	background-color: #fff;
	width: 40%;
}

h1, h2
{
	font-size: 1.5em;
	font-weight: normal;
}

h2
{
	font-size: 1.3em;
}

legend
{
	font-weight: bold;
	color: #333;
}

#filedrag
{
	display: none;
	font-weight: bold;
	text-align: center;
	padding: 1em 0;
	margin: 1em 0;
	color: #555;
	border: 2px dashed #555;
	border-radius: 7px;
	cursor: default;
}

#filedrag.hover
{
	color: #f00;
	border-color: #f00;
	border-style: solid;
	box-shadow: inset 0 3px 4px #888;
}

img
{
	max-width: 100%;
}

pre
{
	width: 95%;
	height: 8em;
	font-family: monospace;
	font-size: 0.9em;
	padding: 1px 2px;
	margin: 0 0 1em auto;
	border: 1px inset #666;
	background-color: #eee;
	overflow: auto;
}

#messages
{
	padding: 0 10px;
	margin: 1em 0;
	border: 1px solid #999;
}

#progress p
{
	display: block;
	width: 240px;
	padding: 2px 5px;
	margin: 2px 0;
	border: 1px inset #446;
	border-radius: 5px;
	background: #eee url("progress.png") 100% 0 repeat-y;
}

#progress p.success
{
	background: #0c0 none 0 0 no-repeat;
}

#progress p.failed
{
	background: #c00 none 0 0 no-repeat;
}
</style>
</head> 
<body>
<form id="upload" action="html2pdf/1.15.1" method="post" enctype="multipart/form-data">
    <fieldset align="left">
    <legend>HTML TO PDF</legend>

    <div>
        <select id="version">
            {% for option in options %}
            <option value="{{ option }}">{{ option }}</option>
            {% endfor %}
        </select>
    </div>
    <div>
        <label for="fileselect">Files to upload:</label>
        <input type="file" id="fileselect" name="fileselect" value="" />
        <div id="filedrag">or drop files here</div>
    </div>
    <div id="submitbutton">
        <button type="submit">Upload</button>
    </div>
    </fieldset>
</form>
<div id="messages">
    <p>Status Messages</p>
</div>

<script>
(function() {

	// getElementById
	function $id(id) {
		return document.getElementById(id);
	}

	// output information
	function Output(msg) {
		var m = $id("messages");
		m.innerHTML = msg;
	}

	// file drag hover
	function FileDragHover(e) {
		e.stopPropagation();
		e.preventDefault();
		e.target.className = (e.type == "dragover" ? "hover" : "");
	}

	// file selection
	function FileSelectHandler(e) {

		// cancel event and hover styling
		FileDragHover(e);

		// fetch FileList object
		var files = e.target.files || e.dataTransfer.files;

		// process all File objects
		for (var i = 0, f; f = files[i]; i++) {
			ParseFile(f);
		}

		var fs = $id("fileselect");
		fs.files[0] = files[0];
	}

	// output file information
	function ParseFile(file) {
		Output(
			"<p>File information: <strong>" + file.name +
			"</strong> type: <strong>" + file.type +
			"</strong> size: <strong>" + file.size +
			"</strong> bytes</p>"
		);
	}

	// initialize
	function Init() {

		var fileselect = $id("fileselect"),
			filedrag = $id("filedrag"),
			submitbutton = $id("submitbutton");

		// file select
		fileselect.addEventListener("change", FileSelectHandler, false);

		// is XHR2 available?
		var xhr = new XMLHttpRequest();
		if (xhr.upload) {

			// file drop
			filedrag.addEventListener("dragover", FileDragHover, false);
			filedrag.addEventListener("dragleave", FileDragHover, false);
			filedrag.addEventListener("drop", FileSelectHandler, false);
			filedrag.style.display = "block";

			// remove submit button
			//submitbutton.style.display = "none";
		}
	}

	$id("version").onchange = function(e) {
		document.forms[0].action = "html2pdf/" + e.target.value;
	}

	// call initialization file
	if (window.File && window.FileList && window.FileReader) {
		Init();
	}
})();
</script>

</body> 
</html>