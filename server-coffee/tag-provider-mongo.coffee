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
		@db = new Db('springer-research', new Server(host, port, {auto_reconnect: true}, {}))
		@db.open(->);

	getByTag: (name, callback) ->
		@getTags( (error, tagCollection) ->
			if(error?)
				console.log("failed to get by tag")
			else
				console.log("trying to find tags with area of #{name}")
				tagCollection.find({areas: name}).sort("createdAt", -1).toArray((error, articles) ->
					if(error? || !articles?)
						console.log("error finding documents matching #{name}")
					else
						documents = 
							results: articles
						callback(documents)
				)
		)

	insert: (tagJson, callback) =>
		@getTags( (error, tagCollection) =>
			if(error?) 
				callback(false)
			else
				tagCollection.find({doi: tagJson.doi}).toArray( (error, articles) =>
					if articles.length==0 
						tagJson["createdAt"] = new Date();
						tagCollection.insert(tagJson)
						callback(true)
					else
						if tagJson.areas[0] in articles[0].areas
							callback(false)
						else
							articles[0].areas.push tagJson.areas[0]
							tagCollection.update({_id: articles[0]._id}, articles[0])
							callback(true)
				)
		)
