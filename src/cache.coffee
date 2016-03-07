_ = require 'lodash'

class Cache
  constructor: ({@client}) ->

  del: (key, callback) =>
    @client.del key, callback

  exists: (key, callback) =>
    @client.exists key, (error, result) =>
      callback error, (result == 1)

  get: (key, callback) =>
    @client.get key, callback

  lpush: (key, value, callback) =>
    @client.lpush key, value, callback

  publish: (key, message, callback) =>
    @client.publish key, message, callback

  set: (key, value, callback) =>
    @client.set key, value, (error, ignored) => callback error

  setex: (key, time, value, callback) =>
    @client.setex key, time, value, (error, ignored) => callback error

  expire: (key, time, callback) =>
    @client.expire key, time, (error, ignored) => callback error

module.exports = Cache
