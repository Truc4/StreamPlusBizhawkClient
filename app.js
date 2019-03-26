const fs = require('fs');
//const io = require('socket.io-client');
const net = require('net');

const Hapi = require('hapi');

//var socket = io.connect("https://streamplusbizhawk-ebs.herokuapp.com");
//var socket = io.connect("http://localhost:8082");


const config = JSON.parse(fs.readFileSync("config.json"));

const serverOptions = {
    host: '0.0.0.0',
    port: config.port || 8080,
    routes: {
        cors: {
            origin: ['*'],
        },
    },  
};

const server = new Hapi.Server(serverOptions);

(async () => {
    // Info from server
  
    server.route({
      method: 'GET',
      path: '/info',
      handler: info
    });
  
    // Start the server.
    await server.start();

    console.log('Server running at %s', server.info.uri);
  
})();

function info(res){
    console.log(res);
}

/*
const luaChannel = config.channel;
const luaToken = config.token;*/


setInterval(function () {
    if (bizHawk) bizHawk.write('ping\rping\n');
    //socket.emit('ping');
}, 10000)

// Data from server
/*
socket.on('command', function(data){
    console.log(`recieved ${data.commandNumber} from ${socket.id}`);
    if (data.transactionObject){
        if (!data.transactionObject["transactionObject[product][inDevelopment]"]){
            saveTransaction(data.transactionObject);
        }
        else{
            console.log(JSON.stringify(data.transactionObject));
        }
    }
    
    if (bizHawk){
        bizHawk.write(data.commandNumber+ "\r" + data.commandSender + '\n');
        //bizHawk.write('test\rsecond value\n');
    }
    else {
        console.log("BizHawk not connected");
    }
});*/

// Connect to BizHawk

var bizHawk = false;

const zServer = net.createServer(function (zSocket) {
    console.log("Connected to BizHawk!");
    bizHawk = zSocket;
    zSocket.setEncoding('ascii');
    zSocket.on('data', function (data) {
        //console.log(data);
        if (data.startsWith('luaReady')){
            data = data.slice(8);
            //console.log(data);
            luaBusy = false;
            bizHawk = zSocket;
            socket.emit('ready', {luaChannel:luaChannel, luaToken:luaToken, groupId:data});
            //console.log('sending ready...');
        }
        if (data.startsWith('luaNotReady')){
            data = data.slice(11);
            bizHawk = zSocket;
            socket.emit('notReady', {luaChannel:luaChannel, luaToken:luaToken, groupId:data});
        }
        //zSocket.write("test");
    });
    zSocket.on('error', (err) => {
        zSocket.destroy();
        console.log("BizHawk disconnected");
        bizHawk = false;
        socket.emit('notReady', {luaChannel:luaChannel, luaToken:luaToken});
        console.log('sending notReady...');
    });
    zSocket.on('end', zSocket.end);
    //zSocket.pipe(zSocket);
});

zServer.listen(8081, '0.0.0.0', function(){
    console.log('Awaiting connection... please load a .lua file in Bizhawk');
});

/*
// Save transaction data
function saveTransaction(transactionObject){
    fs.readFile('transactions.json', function (err, data) {
        var json = JSON.parse(data);
        json.push(transactionObject);
    
        fs.writeFile("transactions.json", JSON.stringify(json, null, 2), (err) => {
            if (err){
                console.log(err);
            }
            console.log("Transaction has been saved");
        });
    });
}*/