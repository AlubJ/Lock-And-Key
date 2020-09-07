// Made by Alub

// Save file with encryption - With help from Juju Adams
function file_save_encrypted(_string, _file) {
	// Create the buffer
	var _buffer_0 = buffer_create(string_byte_length(_string)+1, buffer_fixed, 1);
	
	// Write string to said buffer
	buffer_write(_buffer_0, buffer_string, _string);
	
	// Compress buffer!
	var _buffer_1 = buffer_compress(_buffer_0, 0, buffer_tell(_buffer_0));
	
	// Here we edit the bytes for the first 50 bytes
	try {
		for(var _i = 0; _i < 50; _i++) {
			buffer_poke(_buffer_1, _i, buffer_u32, 0x12345678 ^ buffer_peek(_buffer_1, _i, buffer_u32)); // You can change "0x12345678" to any combo of numbers as long as it still starts with 0x
		}
	} catch (_exception){
		show_debug_message(_exception.message);
		show_debug_message(_exception.longMessage);
		show_debug_message(_exception.script);
		show_debug_message(_exception.stacktrace);
		show_debug_message("String too small!");
		return -1;
	}
	
	// Save the buffer
	buffer_save(_buffer_1, _file);

	// Memory management
	buffer_delete(_buffer_0);
	buffer_delete(_buffer_1);
	
	// Return back the file path
	return _file;
}

// Load file with encryption - With help from Juju Adams
function file_open_encrypted(_file) {
	// Load buffer
	var _buffer_1 = buffer_load(_file);
	
	// Here we un-edit the 50 bytes we edited before
	for(var _i = 0; _i < 50; _i++) {
		buffer_poke(_buffer_1, _i, buffer_u32, 0x12345678 ^ buffer_peek(_buffer_1, _i, buffer_u32)); // You can change "0x12345678" to any combo of numbers as long as it still starts with 0x
	}
	
	// Decompress buffer
	var _buffer_0 = buffer_decompress(_buffer_1);
	
	// Get string from buffer
	try {
		var _string = buffer_read(_buffer_0, buffer_string);
	} catch (_exception) {
		// This shouldn't error if the file hasn't been tampered with!
		show_debug_message(_exception.message);
		show_debug_message(_exception.longMessage);
		show_debug_message(_exception.script);
		show_debug_message(_exception.stacktrace);
		show_debug_message("File tampered with!");
		return "File tampered with!";
	}
	// Memory Cleanup
	buffer_delete(_buffer_0);
	buffer_delete(_buffer_1);

	// Return the string
	return _string;
}
