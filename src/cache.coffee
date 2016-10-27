_ = require 'lodash'

class Cache
  constructor: ({@client}) ->

  del: (key, callback=->) =>
    @client.del key, callback

  exists: (key, callback) =>
    @client.exists key, (error, result) =>
      callback error, (result == 1)

  hset: (key, field, value, callback=->) =>
    @client.hset key, field, value, (error, result) =>
      callback error, (result == 1)

  hget: (key, field, callback) =>
    @client.hget key, field, callback

  get: (key, callback) =>
    @client.get key, callback

  llen: (key, callback) =>
    @client.llen key, callback

  lpush: (key, value, callback=->) =>
    @client.lpush key, value, callback

  publish: (key, message, callback=->) =>
    @client.publish key, message, callback

  set: (key, value, callback=->) =>
    @client.set key, value, (error, ignored) => callback error

  setex: (key, time, value, callback=->) =>
    @client.setex key, time, value, (error, ignored) => callback error

  ttl: (key, callback) =>
    @client.ttl key, callback

  expire: (key, time, callback=->) =>
    @client.expire key, time, (error, ignored) => callback error

  hincrby: (key, field, increment, callback=->) =>
    @client.hincrby key, field, increment, callback

module.exports = Cache
