# 
# (C) 2008 Los Angeles Times
# 
require 'set'

# An object for storing keywords and their associated url's, as well
# as for creating hyperlinks when the decorate method is called.
# KeywordLinker stores these strategy objects in KeywordProspector's
# Aho-Corasick trees, and uses the returned objects to generate links
# around the matched keywords.
#
# Use the options to create html attributes.  For example:
#   strategy.options = {"title" => "How cool!"}
#
# ...this will add a title tag containing "How cool!" to all links
# generated by this strategy object.
class HyperlinkStrategy
  # The url which will be linked when the strategy is activated.
  attr_reader :url

  # The html attributes to add to the link.
  attr_reader :options

  # Takes the url to link to, and the options for creating html
  # attributes on each link.
  def initialize(url=nil, options={})
    @keywords = Set.new
    self.options = options
    self.url = url
  end

  # The set of keywords for which this strategy should be activated.
  # This is used only when adding the strategy to a linker, and not
  # referenced when keywords are linked.
  def keywords=(*keywords)
    @keywords = Set.new(keywords.flatten)
  end

  # Return the set of keywords to be linked by this strategy.
  def keywords
    @keywords
  end

  # Assign the url
  def url=(url)
    @url = url
    merge_options(@options)
  end

  # Assign the options to be used for generating html attributes.
  def options=(options)
    merge_options(options)
  end

  # Add a keyword to the list of keywords for this strategy.
  def add_keyword(keyword)
    @keywords.add(keyword)
    self
  end

  # Return a hyperlink for this keyword.
  def decorate(keyword)
    attributes = ""
    options.each_pair do |key, value|
      attributes += " " unless attributes.length == 0
      attributes += "#{key}=\"#{value}\""
    end

    "<a " + attributes + ">#{keyword}</a>"
  end

  private
  # Merge the url with the options provided for html attributes.
  # href is an attribute as well.  If provided in options, the
  # href provided in options will override the url value specified.
  def merge_options(options)
    if @url
      @options = {:href => @url}.merge(options)
    else
      @options = options
    end
  end
end
