# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_modal-kombat_session',
  :secret      => 'b2086c2a0f49420c57fc58e26806864570952db38837427fadd099debd43b8318e61ce9485f3df4755e565533ab6d5b4a84be6b4e0d7db940ec1401d74757af5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
