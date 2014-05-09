#
# # Metal
#
# Our metalsmith build code.
#
path        = require 'path'
metalsmith  = require 'metalsmith'
collections = require 'metalsmith-collections'
markdown    = require 'metalsmith-markdown'
permalinks  = require 'metalsmith-permalinks'
templates   = require 'metalsmith-templates'
paginate    = require './plugins/paginate'



# ## build
#
# Build our metalsmith project. Exported as a module.
#
# - callback(err, files): A function which is given an error
#   or a list of files when metalsmith is done.
module.exports = build = (callback=->) ->
  metalsmith __dirname
    .source '..'
    .destination 'build'
    .ignore ['.git', '.metalsmith', 'legacy']
    .options remove: false
    .use markdown()
    .use collections
      faq:
        pattern: 'faq/*.html'
        sortBy: 'importance'
      video: {}
      guide: 
        pattern: 'guides/*.html'
    .use paginate
      collection: 'faq'
      limit: 10
      output: 'faq/index'
      metadata: template: 'faq.toffee'
    .use paginate
      collection: 'video'
      output: 'videos/index'
      metadata: template: 'videos.toffee'
    .use paginate
      collection: 'guide'
      output: 'guides/index'
      metadata: template: 'guides.toffee'
    .use permalinks()
    .use templates 'toffee'
    .build callback



# If this file is executed directly, run the build script.
if require.main is module then build()