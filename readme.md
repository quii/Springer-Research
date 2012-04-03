# Features to do (prioritized)

- Design

- Basic chat on research area when more than one client is connected and viewing that area

- Make the tagging system more robust. Currently you can add the same tag twice, need to group them (or add count?) and then order them by number of hits

- Host it, probably on heroku
	- Sort out free mongodb hosting. 

- Be able to export the list of tagged documents for an area to Instapaper (http://www.instapaper.com/api/simple).
	- Make it so when you press on "Export to Instapaper" that it comes up in a popup and you can deselect content you dont want sent

- Make the search better
	- Use Duncan's API
	- Show content type, authors, etc

# Refactoring required
- DRY the server's socket handler
- All the routes are in one file called index.coffee, which is stupid and misleading

# Bugs
- Adding tags is still sometimes dodgy, seems to be using a previous area name sometimes, or something

# How to start mongo:
sudo mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf

# Tutorial on using express with mongo
http://howtonode.org/express-mongodb
