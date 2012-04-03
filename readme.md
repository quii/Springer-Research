# Features to do (prioritized)

- Design

- Home page. Show top tags and a searchbox with "I want to research: ". Possibly later show what is being researched in realtime

- Make the tagging system more robust. Currently you can add the same tag twice, need to group them (or add count?) and then order them by number of hits

- Basic chat on research area when more than one client is connected and viewing that area

- Be able to export the list of tagged documents for an area to Instapaper (http://www.instapaper.com/api/simple).
	- Make it so when you press on "Export to Instapaper" that it comes up in a popup and you can deselect content you dont want sent

- Make the search better
	- Use Duncan's API
	- Show content type, authors, etc

# Refactoring required
- Refactor jade files, layout has too much stuff in it

# Bugs
- Only works on coffeescript?

# How to start mongo:
sudo mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf

# Tutorial on using express with mongo
http://howtonode.org/express-mongodb
