require 'sinatra'
require 'google/cloud/firestore'
require 'pry'

require_relative 'database'
require_relative 'firebase_verifier'
require_relative 'compare_symbols'

before '/*' do
  content_type :json
end

get '/' do
  'Awake'
end

post '/sign_or_create_user' do
  # Perhaps move data to JWT
  db = Database.client
  params = JSON.parse(request.body.read)

  # Check for invalid params
  halt 400, { error: 'Bad Request', message: 'Invalid params' }.to_json if params.nil?

  payload = FirebaseVerifier.verify_firebase_token(params['did_token'])

  halt 404, { error: 'Not Found', message: 'User not found' }.to_json if payload.nil?

  # Query Firestore to check if the user already exists
  user_query = db.collection('users').where('uid', '==', payload['user_id']).get
  existing_user = user_query.first

  if existing_user
    # User already exists, return a JSON response
    halt 200, existing_user.data.to_json
  else
    # Create a new user in Firestore
    new_user_ref = db.collection('users').add({
                                                uid: payload['user_id'],
                                                email: payload['email'],
                                                name: params['name'],
                                                username: payload['email'].split('@').first,
                                                created_at: Time.now,
                                                photo_url: payload['picture'],
                                                refreshToken: params['refreshToken']
                                              })

    # Return the new user details as a JSON response
    content_type :json
    halt 201, new_user_ref.get.data.to_json
  end
end

get '/ranking' do
  db = Database.client

  db.collection('ranking').get.map(&:data).to_json
end

get '/symbols' do
  db = Database.client

  db.collection('symbols').get.map(&:data).to_json
end

post '/compare_symbols' do
  db = Database.client

  db.collection('symbols').get.map(&:data).each do |symbol|
    is_pump = CompareSymbols.compare_24hr_change(symbol[:coingecko_id])

    db.collection('symbol_comparisons').add({
                                            pump: is_pump,
                                            symbol: symbol[:symbol],
                                            date: Time.now
                                          })
  end
end

post '/vote' do
  db = Database.client
  params = JSON.parse(request.body.read)
  halt 400, { error: 'Bad Request', message: 'Invalid params' }.to_json if params.nil?

  payload = FirebaseVerifier.verify_firebase_token(params['did_token'])

  db.collection('user_choices').add({
                                      date: Time.now,
                                      pump: params['pump'],
                                      symbol: params['symbol'],
                                      user_uid: payload['user_id']
                                    })
  content_type :json
  halt 201
rescue StandardError
  content_type :json
  halt 500,
       { error: 'Server Error',
         message: 'Could not process vote' }.to_json
end

post '/all_seen' do
  db = Database.client
  params = JSON.parse(request.body.read)
  halt 400, { error: 'Bad Request', message: 'Invalid params' }.to_json if params.nil?

  payload = FirebaseVerifier.verify_firebase_token(params['did_token'])

  db.collection('users').where('uid', '==', payload['user_id']).get.first.reference.update(
    {
      allPairsSeen: true,
      allPairsSeenAt: Time.now
    }
  )
  content_type :json
  halt 201
rescue StandardError => e
  puts e
  content_type :json
  halt 500,
       { error: 'Server Error',
         message: 'Could not process vote' }.to_json
end

post '/all_unseen' do
  db = Database.client
  params = JSON.parse(request.body.read)
  halt 400, { error: 'Bad Request', message: 'Invalid params' }.to_json if params.nil?

  payload = FirebaseVerifier.verify_firebase_token(params['did_token'])

  db.collection('users').where('uid', '==', payload['user_id']).get.first.reference.update({ allPairsSeen: false })
  content_type :json
  halt 201
rescue StandardError
  content_type :json
  halt 500,
       { error: 'Server Error',
         message: 'Could not process vote' }.to_json
end
