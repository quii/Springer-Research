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
			# if(InputValidation.validate(aliasInput))
			if(aliasInput.val().length>0)
				@userName = aliasInput.val()
				@showChatForm() 
				chatInput.focus()
				@hideAliasForm()

	handleChatEntered: =>
		$("#chat .chat-form").submit (e) =>
			e.preventDefault()
			message = chatInput.val()
			chatInput.val("")
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
		chatBox.append("<li><strong>#{name}</strong>: #{message}</li>")
		chatBox[0].scrollTop = chatBox[0].scrollHeight

	showHideChat: -> 
		if @numberOfUsers > 1
			@displayChat() 
		else unless @hasBeenChat
			@hideChat()
	
	displayChat: -> chatWrapper.show()
	hideChat: -> chatWrapper.hide()
	hideChatForm: -> chatForm.hide()
	showChatForm: -> chatForm.show()
	hideAliasForm: -> $("#chat .alias-form").hide()
	hasBeenChat: -> chatBox.find("li").length>0

	chatWrapper = do -> $("section#chat")
	onChatPage = do -> chatWrapper.length>0
	chatInput = do -> $("#chat .text-input")
	chatForm = do -> $("#chat .chat-form")
	aliasInput = do -> $("#chat .alias")
	numberOfUsersSpan = do -> $("#chat .number-of-users")
	areaSpan = do -> $("#chat .chat-area")
	chatBox = do -> $("#chat ul")

$ ->
	chat = new Chat()