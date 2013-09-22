/*global Module:true, $:true, app:true*/
(function(){
  $(document).ready(function(){
    app = {
      create_dict: Module.cwrap("create_dict", "void", []),
      add_string_to_dict: Module.cwrap("add_string_to_dict", "void", ["number", "string"]),
      add_uint8_to_dict: Module.cwrap("add_uint8_to_dict", "void", ["number", "number"]),
      add_uint16_to_dict: Module.cwrap("add_uint16_to_dict", "void", ["number", "number"]),
      add_uint32_to_dict: Module.cwrap("add_uint32_to_dict", "void", ["number", "number"]),
      add_int8_to_dict: Module.cwrap("add_int8_to_dict", "void", ["number", "number"]),
      add_int16_to_dict: Module.cwrap("add_int16_to_dict", "void", ["number", "number"]),
      add_int32_to_dict: Module.cwrap("add_int32_to_dict", "void", ["number", "number"]),
      send_dict_to_pebble: Module.cwrap("send_dict_to_pebble", "void", []),

      add_bytes_to_dict: function(id, bytes) {
        var buf = Module._malloc(bytes.length);
        console.log("Adding bytes: ", bytes);
        Module.HEAPU8.set(bytes, buf);
        Module.ccall('add_bytes_to_dict', 'void', ['number', 'number', 'number'],
                     [id, buf, bytes.length]);
        Module._free(buf);
      }
    };
  });
})();
