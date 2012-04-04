(function() {
  var Chat, Home, SearchResultCache, SocketSupport, SpringerLite, Tagger,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SocketSupport = (function() {

    function SocketSupport() {
      this.socket = io.connect('http://ec2-184-73-142-156.compute-1.amazonaws.com');
    }

    SocketSupport.prototype.listen = function(name, callback) {
      return this.socket.on(name, function(data) {
        return callback(data);
      });
    };

    SocketSupport.prototype.sendSocketData = function(name, data) {
      return this.socket.emit(name, data);
    };

    SocketSupport.prototype.sendRecieveData = function(name, data, callback) {
      return this.socket.emit(name, data, function(recievedData) {
        return callback(recievedData);
      });
    };

    return SocketSupport;

  })();

  Home = (function() {

    function Home() {
      this.displayCurrentResearch = __bind(this.displayCurrentResearch, this);      this.socketSupport = new SocketSupport();
      this.currentResearch = [];
      this.askForRealtimeInfo();
      this.listenForNewAreasBeingResearched();
      this.tellServerImHome();
    }

    Home.prototype.askForRealtimeInfo = function() {
      return this.socketSupport.sendRecieveData("whatsBeingResearched", {}, this.displayCurrentResearch);
    };

    Home.prototype.tellServerImHome = function() {
      return this.socketSupport.sendSocketData("whereAmI", "home");
    };

    Home.prototype.listenForNewAreasBeingResearched = function() {
      return this.socketSupport.listen("newResearchHappening", this.displayCurrentResearch);
    };

    Home.prototype.displayCurrentResearch = function(data) {
      var areas, key, renderedHTML, val;
      console.log("data recieved = ", data);
      areas = [];
      for (key in data) {
        val = data[key];
        areas.push({
          name: key,
          number: val
        });
      }
      if (areas.length > 0) {
        this.currentResearch = {
          results: areas
        };
        renderedHTML = Mustache.to_html($('#current-research-template').html(), this.currentResearch);
        return $('#current-research-container').html(renderedHTML);
      } else {
        return $('#current-research-container').html('');
      }
    };

    return Home;

  })();

  $(function() {
    var home;
    if ($("#isHome").length > 0) return home = new Home();
  });

  SearchResultCache = (function() {

    function SearchResultCache() {}

    SearchResultCache.prototype.addResultToCache = function(term, renderedHTML) {
      if (this.exists(term)) {
        return localStorage.setItem(term, this.getHtml(term) + renderedHTML);
      } else {
        return localStorage.setItem(term, renderedHTML);
      }
    };

    SearchResultCache.prototype.getHtml = function(term) {
      return this.findResult(term);
    };

    SearchResultCache.prototype.exists = function(term) {
      return this.findResult(term) != null;
    };

    SearchResultCache.prototype.findResult = function(term) {
      return localStorage.getItem(term);
    };

    SearchResultCache.prototype.keys = function() {
      return Object.keys(localStorage);
    };

    return SearchResultCache;

  })();

  Chat = (function() {
    var aliasInput, areaSpan, chatForm, chatInput, chatWrapper, numberOfUsersSpan, onChatPage;

    function Chat() {
      this.listenForChat = __bind(this.listenForChat, this);
      this.handleChatEntered = __bind(this.handleChatEntered, this);
      this.handleUsernameEntered = __bind(this.handleUsernameEntered, this);
      this.listenForOtherUsers = __bind(this.listenForOtherUsers, this);      if (onChatPage) {
        this.areaName = $("#area-id").text();
        this.socketSupport = new SocketSupport();
        this.numberOfUsers = 1;
        this.showHideChat;
        this.userName = "";
        this.hideChatForm();
        this.listenForOtherUsers();
        this.handleUsernameEntered();
        this.handleChatEntered();
        this.listenForChat();
      }
    }

    Chat.prototype.listenForOtherUsers = function() {
      var _this = this;
      return this.socketSupport.listen("newResearchHappening", function(data) {
        _this.numberOfUsers = data[_this.areaName];
        _this.showHideChat();
        numberOfUsersSpan.text(_this.numberOfUsers - 1);
        return areaSpan.text(_this.areaName);
      });
    };

    Chat.prototype.handleUsernameEntered = function() {
      var _this = this;
      return $("#chat .alias-form").submit(function(e) {
        e.preventDefault();
        _this.userName = aliasInput.val();
        if (_this.userName.length > 0) {
          _this.showChatForm();
          chatInput.focus();
          return _this.hideAliasForm();
        }
      });
    };

    Chat.prototype.handleChatEntered = function() {
      var _this = this;
      return $("#chat .chat-form").submit(function(e) {
        var message;
        e.preventDefault();
        message = chatInput.val();
        chatInput.val("");
        if (message.length > 0) return _this.sendMessage(message);
      });
    };

    Chat.prototype.sendMessage = function(message) {
      var payload;
      payload = {
        user: this.userName,
        message: message,
        area: this.areaName
      };
      return this.socketSupport.sendSocketData('chatMessage', payload);
    };

    Chat.prototype.listenForChat = function() {
      var _this = this;
      return this.socketSupport.listen('recieveChat', function(data) {
        if (data["area"] === _this.areaName) {
          return _this.addChatLine(data["user"], data["message"]);
        }
      });
    };

    Chat.prototype.addChatLine = function(name, message) {
      return $("#chat ul").append("<li><strong>" + name + "</strong>: " + message + "</li>");
    };

    Chat.prototype.showHideChat = function() {
      if (this.numberOfUsers > 1) {
        return this.displayChat();
      } else {
        return this.hideChat();
      }
    };

    Chat.prototype.displayChat = function() {
      return chatWrapper.show();
    };

    Chat.prototype.hideChat = function() {
      return chatWrapper.hide();
    };

    Chat.prototype.hideChatForm = function() {
      return chatForm.hide();
    };

    Chat.prototype.showChatForm = function() {
      return chatForm.show();
    };

    Chat.prototype.hideAliasForm = function() {
      return $("#chat .alias-form").hide();
    };

    chatWrapper = (function() {
      return $("section#chat");
    })();

    onChatPage = (function() {
      return chatWrapper.length > 0;
    })();

    chatInput = (function() {
      return $("#chat .text-input");
    })();

    chatForm = (function() {
      return $("#chat .chat-form");
    })();

    aliasInput = (function() {
      return $("#chat .alias");
    })();

    numberOfUsersSpan = (function() {
      return $("#chat .number-of-users");
    })();

    areaSpan = (function() {
      return $("#chat .chat-area");
    })();

    return Chat;

  })();

  $(function() {
    var chat;
    return chat = new Chat();
  });

  Tagger = (function() {
    var renderTaggedDocuments;

    function Tagger() {
      this.areaName = $("#area-id").text();
      this.registerTagButtons();
      this.getTaggedDocuments();
      this.socketSupport = new SocketSupport();
      this.listenForTagAdded();
      this.socketSupport.sendSocketData("whereAmI", this.areaName);
    }

    Tagger.prototype.registerTagButtons = function() {
      var _this = this;
      return $(".tag").live("click", function(event) {
        var tagData;
        tagData = {
          doi: $(event.currentTarget).attr('doi'),
          title: $(event.currentTarget).attr('title'),
          area: _this.areaName
        };
        console.log("tag data = ", tagData);
        _this.socketSupport.sendSocketData('addTaggedDocument', tagData);
        $.ajax({
          type: 'POST',
          data: tagData,
          url: '/tag'
        });
        return false;
      });
    };

    Tagger.prototype.getTaggedDocuments = function() {
      var url;
      url = "/tag/" + this.areaName;
      return $.ajax({
        url: url,
        dataType: 'json',
        type: 'GET',
        success: function(json) {
          return renderTaggedDocuments(json);
        }
      });
    };

    renderTaggedDocuments = function(json) {
      var renderedHTML;
      renderedHTML = Mustache.to_html($('#tagged-template').html(), json);
      return $('#tagged-container').html(renderedHTML);
    };

    Tagger.prototype.listenForTagAdded = function() {
      return this.socketSupport.listen('taggedDocumentAdded', function(data) {
        return $("#tagged-container ol").append("<li><a href='http://rd.springer.com/" + data.doi + "'>" + data.title + "</a></li>");
      });
    };

    return Tagger;

  })();

  $(function() {
    var tagger;
    if ($("#tagged-container").length > 0) return tagger = new Tagger();
  });

  SpringerLite = (function() {
    var loadMoreButton, resultsContainer, searchBox, searchButtonElement, stitchResults;

    function SpringerLite() {
      this.resultsCache = new SearchResultCache;
      this.handleSubmit();
      this.handleLoadMore();
      this.handleEmpty();
      loadMoreButton.hide();
    }

    SpringerLite.prototype.doSearch = function(page) {
      searchButtonElement.attr("value", "Searching");
      this.term = searchBox.val();
      if (this.resultsCache.exists(this.term)) {
        this.renderResult(this.term);
        return loadMoreButton.show();
      } else {
        return this.getResult(this.term);
      }
    };

    SpringerLite.prototype.getResult = function(term, page) {
      var startIndex, url,
        _this = this;
      if (page == null) page = 1;
      page = parseInt(page);
      if (page === 1) {
        startIndex = 1;
      } else {
        startIndex = page * 10;
      }
      url = "http://api.springer.com/metadata/jsonp?q=" + term + "&api_key=ueukuwx5guegu4ahjc6ajq8w&s=" + startIndex + "&callback=?";
      console.log(url);
      return $.ajax({
        url: url,
        dataType: 'jsonp',
        type: 'GET',
        success: function(json) {
          var renderedHTML;
          searchButtonElement.attr("value", "Search");
          renderedHTML = Mustache.to_html($('#template').html(), json);
          _this.resultsCache.addResultToCache(term, renderedHTML);
          return _this.renderResult(term);
        }
      });
    };

    SpringerLite.prototype.renderResult = function(term) {
      resultsContainer.html(this.resultsCache.getHtml(term));
      stitchResults();
      searchButtonElement.attr("value", "Search");
      loadMoreButton.text("Load more");
      return loadMoreButton.show();
    };

    SpringerLite.prototype.handleSubmit = function() {
      var _this = this;
      return $("#search-form").submit(function(e) {
        e.preventDefault();
        return _this.doSearch();
      });
    };

    SpringerLite.prototype.handleLoadMore = function() {
      var _this = this;
      return loadMoreButton.click(function() {
        var nextPageNumber, numberOfResultsOnPage;
        numberOfResultsOnPage = $("li").length - 1;
        nextPageNumber = (numberOfResultsOnPage / 10) + 1;
        loadMoreButton.text("Loading more...");
        _this.getResult(_this.term, nextPageNumber);
        return false;
      });
    };

    SpringerLite.prototype.handleEmpty = function() {
      return $("#empty-cache").click(function() {
        localStorage.clear();
        return false;
      });
    };

    stitchResults = function() {
      var numberOfLists;
      numberOfLists = resultsContainer.find("ol").length;
      if (numberOfLists > 1) {
        return resultsContainer.find("li").each(function() {
          resultsContainer.find("ol:first").append($(this));
          return resultsContainer.find("ol").not(":first").remove();
        });
      }
    };

    loadMoreButton = (function() {
      return $("#load-more");
    })();

    searchButtonElement = (function() {
      return $("#search-button");
    })();

    resultsContainer = (function() {
      return $("#results");
    })();

    searchBox = (function() {
      return $("#search");
    })();

    return SpringerLite;

  })();

  $(function() {
    var site;
    if ($("#search").length > 0) return site = new SpringerLite();
  });

}).call(this);
