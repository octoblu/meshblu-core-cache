redis = require 'redis'
RedisNS = require '@octoblu/redis-ns'

r = new RedisNS 'ns', redis.createClient()

r.multi().set('foo', 'bar').expire('foo', 20).exec (error) ->
  console.error error
  r.get 'foo', (error, foo) ->
    console.error error
    console.log foo
    process.exit 0
