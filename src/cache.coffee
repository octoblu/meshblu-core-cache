class Cache
  constructor: ({@client}) ->

  exists: (key, callback) =>
    @client.exists key, (error, result) =>
      callback error, (result == 1)

  get: (key, callback) =>
    @client.get key, callback

  set: (key, value, callback) =>
    @client.set key, value, (error, ignored) => callback error

module.exports = Cache
