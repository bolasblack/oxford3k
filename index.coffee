
_ = require 'lodash'
Q = require 'q'
request = require 'request'
cheerio = require 'cheerio'

startPage = 'http://www.oxfordlearnersdictionaries.com/wordlist/english/oxford3000/'
q_request = Q.denodeify request
makeArray = Array::slice.call.bind Array::slice

module.exports = ->
  q_request(startPage).then ([res, body]) ->
    $ = cheerio.load body
    links = makeArray $('#relatedentries li a').map (index, elem) -> $(elem).attr 'href'
    links.unshift startPage
    links

  .then (links) ->
    Q.all links.map (link) -> q_request link

  .then (responses) ->
    requestPromises = _(responses).map ([res, body]) ->
      $ = cheerio.load body
      lastPageAnchor = $('.paging_links').first().find('a.Page').last()
      pageCount = parseInt lastPageAnchor.text(), 10
      baseLink = lastPageAnchor.attr('href').replace /\?.*$/, ''
      _.range(2, pageCount + 1).map (page) ->
        q_request "#{baseLink}?page=#{page}"
    .flatten()
    .value()

    Q.all responses.map(Q.when.bind Q).concat requestPromises

  .then (responses) ->
    results = {}

    responses.forEach ([res, body]) ->
      $ = cheerio.load body
      words = makeArray $('[title$=" definition"]').map (index, elem) -> $(elem).text()
      wordRange = $('.page_range').first().text().replace /:$/, ''
      results[wordRange] = (results[wordRange] or []).concat words

    results

  .then (results) ->
    console.log JSON.stringify results
    results

  .catch (err) ->
    console.log 'error!', err

if process.argv[1] is __filename
  module.exports()

