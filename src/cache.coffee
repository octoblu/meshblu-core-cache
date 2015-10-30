class Cache
  constructor: ({@client}) ->

  get: (key, callback) =>
    @client.get key, callback

  set: (key, value, callback) =>
    @client.set key, value, (error, ignored) => callback error

module.exports = Cache
