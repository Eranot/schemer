extends Node

signal read_completed
signal load_completed(image)

var js_callback = JavaScriptBridge.create_callback(load_handler);
var js_interface;


func _ready():
	if OS.has_feature("web"):
		setup_js()
		js_interface = JavaScriptBridge.get_interface("_HTML5FileExchange");


func setup_js():
	JavaScriptBridge.eval("""
		var _HTML5FileExchange = {};
		_HTML5FileExchange.upload = function(gd_callback) {
			canceled = true;
			var input = document.createElement('INPUT'); 
			input.setAttribute("type", "file");
			input.setAttribute("accept", "application/json");
			input.click();
			input.addEventListener('change', event => {
				if (event.target.files.length > 0){
					canceled = false;}
				var file = event.target.files[0];
				var reader = new FileReader();
				this.fileType = file.type;
				// var fileName = file.name;
				reader.readAsArrayBuffer(file);
				reader.onloadend = (evt) => {
					if (evt.target.readyState == FileReader.DONE) {
						this.result = evt.target.result;
						gd_callback();
					}
				}
			});
		}
	""", true)


func load_handler(_args):
	read_completed.emit()


func open_file() -> String:
	js_interface.upload(js_callback);

	await read_completed
	
	var data: PackedByteArray = JavaScriptBridge.eval("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason
	return data.get_string_from_utf8()


func save_file(content: String, file_name: String):
	JavaScriptBridge.download_buffer(content.to_ascii_buffer(), file_name, "application/json")
