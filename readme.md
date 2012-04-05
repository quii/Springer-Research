# Features to do (prioritized)

- Dont hide previous chat transcript when a user leaves

- Stop duplicate tags

- Order by most recently added

- Validation on the inputs

- Add a "foo has left"

- Add tag count

- Show other tags for a given document


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
- 

# How to start mongo:
sudo mongod run --config /usr/local/Cellar/mongodb/2.0.3-x86_64/mongod.conf

# Tutorial on using express with mongo
http://howtonode.org/express-mongodb


# Need to automate deployment! 
scp -r -i ~/Downloads/aws.pem SpringerResearch ubuntu@ec2-184-73-142-156.compute-1.amazonaws.com:/home/ubuntu/SpringerResearch
