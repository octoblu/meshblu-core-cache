redis = require 'fakeredis'
uuid  = require 'uuid'
Cache = require '../src/cache'

describe 'Cache', ->
  beforeEach ->
    @clientKey = uuid.v1()
    @client = redis.createClient @clientKey
    @sut = new Cache client: redis.createClient(@clientKey)

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
