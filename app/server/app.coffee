# Server-side Code

exports.actions =
  
  init: (cb) ->
    pingRiak(cb)
    setInterval(pingRiak, 5000) unless @alive_ping?
  
  stats: (cb) ->
    global.Riak.stats( (err, stats, meta)->
      return cb(err) if err
      cb(stats)
    )
  
  buckets: (cb) ->
    global.Riak.buckets( (err, value)->
      return cb(false) if err
      
      # @session.setUserId('user')
      
      for bucket in value.buckets
        global.Riak.count(bucket, (err, count, meta) ->
          SS.publish.broadcast 'setCount', { bucket : meta.bucket, count : count }
          # SS.publish.user @session.user_id, 'setCount', { bucket : meta.bucket, count : count }
        )
      
      cb value
    )


pingRiak = (cb) ->
  global.Riak.ping( (err, value, meta)->
    altered_ping = false
    if value
      message = {status: 'success', message: "Riak is up and running"}
      altered_ping = @alive_ping == false
      @alive_ping = true
    else
      message = {status: 'warning', message: "Cannot connect to the Riak server"}
      altered_ping = @alive_ping == true
      @alive_ping = false
    
    cb message if cb?
    SS.publish.broadcast 'alert', message if !cb? and altered_ping
  )





  # signIn: (user, cb) ->
  #   @session.setUserId(user)
  #   cb user
  #
  # init: (cb) ->
  #   # cb "SocketStream version #{SS.version} is up and running. This message was sent over Socket.IO so everything is working OK."
  #   cb "Riak is up and running"
  #   
  #   SS.publish.broadcast 'bucket', 'Bucket: message'
  #   
  #   # SS.publish.broadcast 'key', 'Bucket: message'
  #   
  #   # stream out keys
  #   global.Riak.keys('messages', { keys: 'stream' }).on('keys', (keys)->
  #     for v in keys
  #       # todo: don't broadcast... only individuals
  #       SS.publish.broadcast 'newMessage', v
  #   ).start()
  # 
  # # db.buckets();
  # 
  # getData: (key, cb) ->
  #   global.Riak.get('messages', key, (err, value, meta)->
  #     # SS.publish.broadcast 'viewData', value
  #     cb value #true
  #   )
  # 
  # deleteKey: (key, cb) ->
  #   global.Riak.remove('messages', key, (err, value, meta)->
  #     return cb(false) if err
  #     # console.log(err)
  #     SS.publish.broadcast 'removeData', key
  #     cb true
  #   )
  # 
  # sendMessage: (message, cb) ->
  #   if message.length > 0 
  #     # SS.publish.broadcast 'newMessage', message      # Broadcast the message to everyone
  #     global.Riak.save('messages', undefined, { text: message }, { returnbody: true, method: 'POST' }, (err, value, meta)->
  #       SS.publish.broadcast 'newMessage', meta.key
  #     )
  #     cb true                                         # Confirm it was sent to the originating client
  #   else
  #     cb false

  # http://riakjs.org/
