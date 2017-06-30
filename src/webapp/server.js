'use strict';

const express = require('express');
const redis = require('redis');
const myip = require('quick-local-ip');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
const REDIS_PORT = 6379;
const REDIS_HOST = "redis.weave.local";

// Connect to Redis Server
const client = redis.createClient(REDIS_PORT, REDIS_HOST)

// Get IP Address
const ip = myip.getLocalIP4();

// App
const app = express();

app.get('/', function(req, res, next) {
  client.incr('counter', function(err, counter) {
    if(err) return next(err);
    res.send('[' + ip + '] This page has been viewed ' + counter + ' times!');
  });
});

app.listen(PORT, HOST);
console.log('Running on http://' + HOST + ':' + PORT);
