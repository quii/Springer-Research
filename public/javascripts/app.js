(function() {
  var SearchResultCache, SocketSupport, SpringerLite, Tagger;

  SocketSupport = (function() {

    function SocketSupport() {
      this.socket = io.connect('http://localhost');
    }

    SocketSupport.prototype.listen = function(name, callback) {
      return this.socket.on(name, function(data) {
        return callback(data);
      });
    };

    SocketSupport.prototype.sendSocketData = function(name, data) {
      return this.socket.emit(name, data);
    };

    return SocketSupport;

  })();

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

  Tagger = (function() {
    var renderTaggedDocuments;

    function Tagger() {
      this.areaName = $("#area-id").text();
      this.registerTagButtons();
      this.getTaggedDocuments();
      this.socketSupport = new SocketSupport();
      this.listenForTagAdded();
    }

    Tagger.prototype.registerTagButtons = function() {
      var _this = this;
      return $(".tag").live("click", function(event) {
        var tagData;
        tagData = {
          doi: $(event.currentTarget).attr('doi'),
          title: $(event.currentTarget).attr('title'),
          area: $(event.currentTarget).attr('area')
        };
        _this.socketSupport.sendSocketData('addTaggedDocument', tagData);
        console.log("posting tag data: " + tagData);
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
      console.log("trying to get from " + url);
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
