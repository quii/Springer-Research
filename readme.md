# Features to do (prioritized)

- Design

- Make the tagging system more robust. Currently you can add the same tag twice, need to group them (or add count?) and then order them by number of hits

- Host it, probably on heroku
	- Sort out free mongodb hosting. 
	- https://devcenter.heroku.com/articles/mongohq

- Be able to export the list of tagged documents for an area to Instapaper (http://www.instapaper.com/api/simple).
	- Make it so when you press on "Export to Instapaper" that it comes up in a popup and you can deselect content you dont want sent

- Make the search better
	- Use Duncan's API
	- Show content type, authors, etc

# Refactoring required
- DRY the server's socket handler
- All the routes are in one file called index.coffee, which is stupid and misleading
- Make the cake file a little more configurable

# Bugs
- When a person leaves a research page, a client on the homepage doesn't recieve an update

# How to start mongo:
sudo mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf

# Tutorial on using express with mongo
http://howtonode.org/express-mongodb
