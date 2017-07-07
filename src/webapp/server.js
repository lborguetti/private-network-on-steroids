'use strict';

const express = require('express');
const redis = require('redis');
const os = require('os');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const REDIS_PORT = 6379;
const REDIS_HOST = "redis.weave.local";

// Connect to Redis Server
const client = redis.createClient(REDIS_PORT, REDIS_HOST)

// Get all IPv4 Address
const interfaces = os.networkInterfaces();
const addresses = [];
for (const k in interfaces) {
    for (const k2 in interfaces[k]) {
        const address = interfaces[k][k2];
            if (address.family === 'IPv4' && !address.internal) {
                addresses.push(address.address);
        }
    }
}

// App
const app = express();

app.get('/', function(req, res, next) {
  client.incr('counter', function(err, counter) {
    if(err) return next(err);
    res.send('[' + addresses + '] This page has been viewed ' + counter + ' times!');
  });
});

app.listen(PORT, HOST);
console.log('Running on http://' + HOST + ':' + PORT);
