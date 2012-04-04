class Chat

	constructor: ->
		if onChatPage
			@areaName = $("#area-id").text()
			@socketSupport = new SocketSupport()
			@numberOfUsers = 1
			@showHideChat
			@userName=""
			@disableChatInput()
			@listenForOtherUsers()
			@handleUsernameEntered()
			@handleChatEntered()
			@listenForChat()

	listenForOtherUsers: =>
		@socketSupport.listen("newResearchHappening", (data) =>
			@numberOfUsers = data["coffee"]
			@showHideChat()
		)

	handleUsernameEntered: =>
		$("#chat .alias-form").submit (e) =>
			e.preventDefault() 
			@userName = $("#chat .alias").val()
			if @userName.length>0
				@enableChatInput() 
				console.log("disabling alias input")
			else 
				@disableChatInput()

	handleChatEntered: =>
		$("#chat .chat-form").submit (e) =>
			e.preventDefault()
			message = $("#chat .text-input").val()
			if message.length>0 then @sendMessage(message)

	sendMessage: (message) ->
		payload = 
			user: @userName
			message: message
			area: @areaName

		@socketSupport.sendSocketData('chatMessage', payload)

	listenForChat: =>
		@socketSupport.listen('recieveChat', (data) =>
			if data["area"] is @areaName then @addChatLine(data["user"], data["message"])
		)

	addChatLine: (name, message) ->
		$("#chat ul").append("<li><strong>#{name}</strong>: #{message}</li>")

	showHideChat: -> if @numberOfUsers > 1 then @displayChat() else @hideChat()
	
	displayChat: -> chatWrapper.show()
	hideChat: -> chatWrapper.hide()
	disableChatInput: -> chatInput.attr('disabled', 'disabled')
	enableChatInput: -> chatInput.removeAttr('disabled');

	chatWrapper = do -> $("section#chat")
	onChatPage = do -> chatWrapper.length>0
	chatInput = do -> $("section#chat .text-input")
	aliasInput = do -> $("section#chat .alias")

$ ->
	chat = new Chat()