class TagProvider

	Db = require('mongodb').Db;
	Connection = require('mongodb').Connection;
	Server = require('mongodb').Server;
	BSON = require('mongodb').BSON;
	ObjectID = require('mongodb').ObjectID;

	getTags = ->
		db.collection('tags', (error, tagCollection) ->
			if(error?) callback(error)
			else callback(null, tagCollection)
		)

	constructor: (host, port) ->
		Db = new Db('node-mongo-blog', new Server(host, port, {auto_reconnect: true}, {}))
		db.open(->);

	getByTag: (name) ->
		console.log("going to retrieve #{name}")

	insert: (tagJson) ->
		console.log("going to insert #{tagJson}")