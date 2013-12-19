# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://jasonlally.com"

			# The default title of our website
			title: "Jason Lally"

			# The website description (for SEO)
			description: """
				The official website of Jason Lally-urban planner, programmer and dabbler in design.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				jason lally,urban planning,node.js,node,docpad,planning technology,civic technology,civic innovation,planning innovation
				"""

			# The website author's name
			author: "Jason Lally"

			# The website author's email
			email: "jason@jasonlally.com"

			# Styles
			styles: [
				"/styles/bootstrap.css"
                "/vendor/lightbox/css/lightbox.css"
				"/styles/style.css"
			]

			# Scripts
			scripts: [
				"//cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"
				"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js"
				"/vendor/bootstrap/dist/js/bootstrap.min.js"
        "/vendor/lightbox/js/lightbox-2.6.min.js"
				"/scripts/script.js"
			]



		# -----------------------------
		# Helper Functions
		parseMarkdown: (str) ->
      marked(str)

    generateSummary: (post) -> 
      description = post.description
      if description then @parseMarkdown(description) else @contentTrim(@parseMarkdown(post.content))

    formatDate: (date) -> 
    	moment(date).format('Do MMMM YYYY')

    contentTrim: (str) -> 
    	if str.length > 300 then str.slice(0, 297) + '...' else str

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

    # =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: ->
            @getCollection("html").findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: ->
            @getCollection("html").findAllLive({tags:$has:'post'}, [date:-1])

        projects: ->
            @getCollection("html").findAllLive({layout:'project'})


	# =================================
	# Plugins

	plugins:
        ghpages:
            deployRemote: 'origin'
            deployBranch: 'master'
		downloader:
			downloads: [
				{
					name: 'Twitter Bootstrap'
					path: 'src/files/vendor/bootstrap'
					url: 'https://codeload.github.com/twbs/bootstrap/tar.gz/master'
					tarExtractClean: true
				}
			]


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}

# Export our DocPad Configuration
module.exports = docpadConfig