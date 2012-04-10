# Features to do (prioritized

- Add a "foo has left"

- Be able to export the list of tagged documents for an area to Instapaper (http://www.instapaper.com/api/simple).
	- Make it so when you press on "Export to Instapaper" that it comes up in a popup and you can deselect content you dont want sent

- Make the search better
	- Use Duncan's API
	- Show content type, authors, etc

# Refactoring required
- Too much markup being made in tagger.coffee. Need to 'tache it up instead
- DRY the server's socket handler, move some of it into user?
- All the routes are in one file called index.coffee, which is stupid and misleading
- Make the cake file a little more configurable

# Bugs
- 

# How to start mongo:
sudo mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf

# Tutorial on using express with mongo
http://howtonode.org/express-mongodb


# Need to automate deployment! 
scp -r -i ~/Downloads/aws.pem SpringerResearch ubuntu@ec2-184-73-142-156.compute-1.amazonaws.com:/home/ubuntu/SpringerResearch
