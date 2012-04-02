(function() {
  var SearchResultCache, SpringerLite;

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

  SpringerLite = (function() {
    var loadMoreButton, resultsContainer, searchBox, searchButtonElement, stitchResults;

    function SpringerLite() {
      this.resultsCache = new SearchResultCache;
      this.handleSubmit();
      this.handleLoadMore();
      this.handleEmpty();
      this.handleAutoComplete();
    }

    SpringerLite.prototype.doSearch = function(page) {
      searchButtonElement.attr("value", "Searching");
      this.term = searchBox.val();
      if (this.resultsCache.exists(this.term)) {
        return this.renderResult(this.term);
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

    SpringerLite.prototype.handleAutoComplete = function() {
      var _this = this;
      return searchBox.autocomplete({
        source: this.resultsCache.keys(),
        select: function() {
          return _this.renderResult(searchBox.val());
        }
      });
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
    return site = new SpringerLite();
  });

}).call(this);
