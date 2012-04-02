root = exports ? this

class root.TagProvider

	Db = require('mongodb').Db;
	Connection = require('mongodb').Connection;
	Server = require('mongodb').Server;
	BSON = require('mongodb').BSON;
	ObjectID = require('mongodb').ObjectID;

	getTags: (callback) ->
		@db.collection('tags', (error, tagCollection) ->
			if(error?) 
				callback(error)
			else 
				callback(null, tagCollection)
		)

	constructor: (host, port) ->
		@db = new Db('node-mongo-blog', new Server(host, port, {auto_reconnect: true}, {}))
		@db.open(->);

	getByTag: (name) ->
		console.log("going to retrieve #{name}")

	insert: (tagJson) ->
		@getTags( (error, tagCollection) ->
			if(error?) 
				console.log("error")
			else
				tagCollection.insert(tagJson, ->
					# callback(null, tagJson)
					console.log("inserted", tagJson)
				)
		)
