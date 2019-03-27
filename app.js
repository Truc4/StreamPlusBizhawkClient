const fs = require('fs');
const net = require('net');
const Hapi = require('hapi');
const fetch = require('node-fetch');

//var socket = io.connect("https://streamplusbizhawk-ebs.herokuapp.com");
//var socket = io.connect("http://localhost:8082");


const config = JSON.parse(fs.readFileSync("config.json"));
const ip = 'https://0vvb7ugcje.execute-api.us-west-1.amazonaws.com/dev';

const serverOptions = {
    host: '0.0.0.0',
    port: config.port || 8082,
    routes: {
        cors: {
            origin: ['*'],
        },
    },  
};

var groups = {};

// defaultHeaders = channelId:config.channelId, channelToken:config.channelToken, port:serverOptions.port

const server = new Hapi.Server(serverOptions);

(async () => {
    // Info from server

    server.route({
        method: 'GET',
        path: '/',
        handler: function(){
            return true;
        }
    });
  
    server.route({
      method: 'GET',
      path: '/info',
      handler: info
    });
  
    // Start the server.
    await server.start();

    sendReady(false, '{}');

    console.log('Server running at %s', server.info.uri);
  
})();

function info(res){
    console.log('Received ' + res.headers.buttonid + ' from ' + res.headers.sender);
    return true;
}

function sendReady(ready, groups){
    fetch(ip + '/readyClient', {headers:{ ready:ready, groups:groups, channelId:config.channelId, channelToken:config.channelToken, port:serverOptions.port}})
        .then(res => res.json())
        .then(body => {
            console.log(body);
        }).catch(err =>{
            console.log(err);
        });
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
            //socket.emit('ready', {luaChannel:luaChannel, luaToken:luaToken, groupId:data});
            //console.log('sending ready...');
            if (data) groups.data = true;
            // SEND READY TO SERVER
            sendReady(true, JSON.stringify(groups));
        }
        if (data.startsWith('luaNotReady')){
            data = data.slice(11);
            bizHawk = zSocket;
            //socket.emit('notReady', {luaChannel:luaChannel, luaToken:luaToken, groupId:data});
            if (data) groups.data = false;
            // SEND NOTREADY TO SERVER
            sendReady(false, JSON.stringify(groups));
        }
        if (data.startsWith('ping')){
            bizhawk = zSocket;
        }
        //zSocket.write("test");
    });
    zSocket.on('error', (err) => {
        zSocket.destroy();
        console.log("BizHawk disconnected");
        bizHawk = false;
        //socket.emit('notReady', {luaChannel:luaChannel, luaToken:luaToken});
        sendReady(false, JSON.stringify(groups));
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