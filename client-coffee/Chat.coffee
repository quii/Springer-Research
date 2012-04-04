class Chat

	constructor: ->
		if onChatPage
			@socketSupport = new SocketSupport()
			@numberOfUsers = 1
			@showHideChat
			@listenForOtherUsers()

	listenForOtherUsers: =>
		@socketSupport.listen("newResearchHappening", (data) =>
			@numberOfUsers = data["coffee"]
			@showHideChat()
		)

	showHideChat: -> if @numberOfUsers > 1 then @displayChat() else @hideChat()
	
	displayChat: -> chatWrapper.show()
	hideChat: -> chatWrapper.hide()

	chatWrapper = do -> $("section#chat")
	onChatPage = do -> chatWrapper.length>0

$ ->
	chat = new Chat()