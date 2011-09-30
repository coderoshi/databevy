# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')

# This method is called automatically when the websocket connection is established. Do not rename/delete
exports.init = ->
  
  # respond to server events
  SS.events.on 'alert', (resp) -> displayAlert(resp.status, resp.message)
  SS.events.on 'setCount', (bucket) -> displayCount(bucket)
  
  SS.server.app.init (resp) -> displayAlert(resp.status, resp.message)
  
  # respond to client events
  # $('ul.tabs a[href=#stats]').click (e) -> displayStats()
  $('ul.tabs a[href=#buckets]').click (e) -> displayBuckets()
  displayStats()


displayStats = ->
  if window.__displayStats? then return true else window.__displayStats = true
  SS.server.app.stats (stats) ->
    $('#templates-profile').tmpl({stats: JSON.stringify(stats, null, '\t')}).hide().appendTo('#profile').fadeIn()
    # $('#profile').append(stats)

displayBuckets = ->
  if window.__displayBuckets? then return true else window.__displayBuckets = true
  SS.server.app.buckets (buckets) ->
    $('#templates-buckets').tmpl(buckets).hide().appendTo('#buckets').fadeIn()
    $("#buckets table.buckets").tablesorter({ sortList: [[0,0]] })

displayCount = (bucket) ->
  $("td.name:contains('#{bucket.bucket}') ~ td.count").html(bucket.count)

displayAlert = (status, message) ->
  $('#templates-alert').tmpl({status: status, message: message}).hide().appendTo('#alerts').fadeIn()
