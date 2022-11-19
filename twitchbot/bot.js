var tmi = require("tmi.js")
var channelname = "your name"
var prefix = "!"

var config = {
    options: {
        debug: true
    },
    connection: {
        cluster: "aws",
        reconnect: true
    },
    identity: {
        username: "error_pro12",
        // get yours at http://twitchapps.com/tmi
        password: "you tmi"
    },
    channels: [channelname]
}

var client = new tmi.client(config)
client.connect();

client.on("connected", (address, port) => {
    client.action(channelname, "The bot has connected on" + address + ":" + port)
})

client.on("chat", (channel, user, message, self) => {
    if (self) return;
    if (message == "!discord") {
        client.say(channelname, "lets join to my discord:https://discord.gg/8UZUzTkt")
    };
    if (self) return;
    if (message == "!youtube") {
        client.say(channelname, " lets dubscribe to my youtube :https://www.youtube.com/channel/UCJWf53V2utb4dnmpNB7YmWg")
    };
    if (self) return;
    if (message == "!github") {
        client.say(channelname, "my github :https://github.com/ErrorProOfficial/ErrorRP")
    }
    //cmd handler code
    const args = message.slice(prefix.length).trim().split(/ +/g);
    const cmd = args.shift().toLowerCase();
    try {
        let commandFile = require(`./commands/${cmd}.js`)
        commandFile.run(client, message, args, user, channel, self)
    } catch (err) {
        return;
    }
})
