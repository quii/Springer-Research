class Chat

	constructor: ->
		if onChatPage
			@areaName = $("#area-id").text()
			@socketSupport = new SocketSupport()
			@numberOfUsers = 1
			@showHideChat
			@userName=""
			@hideChatForm()
			@listenForOtherUsers()
			@handleUsernameEntered()
			@handleChatEntered()
			@listenForChat()

	listenForOtherUsers: =>
		@socketSupport.listen("newResearchHappening", (data) =>
			@numberOfUsers = data[@areaName]
			@showHideChat()
			numberOfUsersSpan.text(@numberOfUsers-1)
			areaSpan.text(@areaName)
		)

	handleUsernameEntered: =>
		$("#chat .alias-form").submit (e) =>
			e.preventDefault() 
			@userName = $("#chat .alias").val()
			if @userName.length>0
				@showChatForm() 
				chatInput.focus()
				@hideAliasForm()

	handleChatEntered: =>
		$("#chat .chat-form").submit (e) =>
			e.preventDefault()
			message = $("#chat .text-input").val()
			if message.length>0 then @sendMessage(message)
			$("#chat .text-input").val("")

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
	hideChatForm: -> chatForm.hide()
	showChatForm: -> chatForm.show()
	hideAliasForm: -> $("#chat .alias-form").hide()


	chatWrapper = do -> $("section#chat")
	onChatPage = do -> chatWrapper.length>0
	chatInput = do -> $("section#chat .text-input")
	chatForm = do -> $("#chat .chat-form")
	aliasInput = do -> $("section#chat .alias")
	numberOfUsersSpan = do -> $("#chat .number-of-users")
	areaSpan = do -> $("#chat .chat-area")

$ ->
	chat = new Chat()