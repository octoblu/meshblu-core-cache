_ = require 'lodash'
redis = require 'fakeredis'
uuid  = require 'uuid'
Cache = require '../src/cache'

describe 'Cache', ->
  beforeEach ->
    @clientKey = uuid.v1()
    @client = redis.createClient @clientKey
    @sut = new Cache client: redis.createClient(@clientKey)

  describe '->del', ->
    describe 'when there is something', ->
      beforeEach (done) ->
        @client.set 'some-extant-key', 'voracious-animals', done

      beforeEach (done) ->
        @sut.del 'some-extant-key', (error) => done error

      it 'should not exist', (done) ->
        @client.exists 'some-extant-key', (error, result) =>
          expect(result).to.equal 0
          done()

  describe '->exists', ->
    describe 'when there is nothing', ->
      beforeEach (done) ->
        @sut.exists 'rolling-pin', (error, @result) => done error

      it 'should yield false', ->
        expect(@result).to.be.false

    describe 'when there is something', ->
      beforeEach (done) ->
        @client.set 'tray-table-in-wrong-position', 'up-your-nose-qualifies-as-wrong-position', done

      beforeEach (done) ->
        @sut.exists 'tray-table-in-wrong-position', (error, @result) => done error

      it 'should yield the TRUTH', ->
        expect(@result).to.be.true

  describe '->get', ->
    describe 'when there is nothing', ->
      beforeEach (done) ->
        @sut.get 'some-non-extant-key', (error, @result) => done error

      it 'should yield nothing', ->
        expect(@result).not.to.exist

    describe 'when there is something', ->
      beforeEach (done) ->
        @client.set 'some-extant-key', 'voracious-animals', done

      beforeEach (done) ->
        @sut.get 'some-extant-key', (error, @result) => done error

      it 'should yield voracious-animals', ->
        expect(@result).to.deep.equal 'voracious-animals'

  describe '->set', ->
    describe 'trying too hard', ->
      beforeEach (done) ->
        sirJohnEtAl = 'here-lies-the-rev-lt-col-dr-sir-john-doe-mba-phd-esq'
        @sut.set 'trying-too-hard', sirJohnEtAl, (error, @result) => done error

      beforeEach (done) ->
        @client.get 'trying-too-hard', (error, @record) => done error

      it 'should yield NOTHING!', ->
        expect(@result).not.to.exist

      it 'should exist', ->
        expect(@record).to.equal 'here-lies-the-rev-lt-col-dr-sir-john-doe-mba-phd-esq'

  describe '->expire', ->
    describe 'when a value is set, and we later expire it (shoulda probably used setex)', ->
      beforeEach (done) ->
        sirJohnEtAl = 'here-lies-the-rev-lt-col-dr-sir-john-doe-mba-phd-esq'
        @sut.set 'trying-too-hard', sirJohnEtAl, (error, @result) =>
          @sut.expire 'trying-too-hard', 1, done

      it 'should have a ttl of 1', (done) ->
        @client.ttl 'trying-too-hard', (error, ttl) =>
          return done error if error?
          expect(ttl).to.equal 1
          done()

  describe '->lpush', ->
    describe 'when there is something', ->
      beforeEach (done) ->
        @sut.lpush 'hanged-by-the-british', 'gallows-humour', (error) => done error

      it 'should yield the TRUTH', (done) ->
        @client.rpop 'hanged-by-the-british', (error, result) =>
          expect(result).to.equal 'gallows-humour'
          done error

  describe '->publish', ->
    describe 'when there is something', ->
      beforeEach (done) ->
        @client.subscribe 'hanged-by-the-british', (error, @message) => done error

      beforeEach (done) ->
        @client.on 'message', (channel, @message) => done()
        @sut.publish 'hanged-by-the-british', 'gallows-humour', (error) =>
          throw error if error?

      it 'should deliver a message', ->
        expect(@message).to.equal 'gallows-humour'

  describe '->ttl', ->
    describe 'when a record has no ttl', ->
      beforeEach (done) ->
        @client.set 'record', 'dark-side-of-the-moon', done

      it 'should have a ttl of -1', (done) ->
        @sut.ttl 'record', (error, ttl) =>
          return done error if error?
          expect(ttl).to.equal -1
          done()

    describe 'when a record has a ttl of 86400', ->
      beforeEach (done) ->
        @client.setex 'record', 86400, 'dark-side-of-the-moon', done

      it 'should have a ttl of 86400', (done) ->
        @sut.ttl 'record', (error, ttl) =>
          return done error if error?
          expect(ttl).to.equal 86400
          done()
