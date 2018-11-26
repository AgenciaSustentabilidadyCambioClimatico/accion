Hashid::Rails.configure do |config|
  # The salt to use for generating hashid. Prepended with table name.
  config.salt = "aVvwhxIgGPcJKQq6o4qhyHEp0t9lFGhDRqnLVEmo9sLCGm9gQ112Lo0bdrabjo"
  # The minimum length of generated hashids
  config.min_hash_length = 28
  # The alphabet to use for generating hashids
  config.alphabet = "abcdefghijklmnopqrstuvwxyz" \
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                    "1234567890" \
                    #"1234567890あきせそちのひほもゆらるれろわИЛДПЫБЯЬГЧЖШЮЦЭЩФabcdefghojklmnopqrstuvwxyz"
  # Whether to override the `find` method
  config.override_find = true
  # Whether to sign hashids to prevent conflicts with regular IDs (see https://github.com/jcypret/hashid-rails/issues/30)
  config.sign_hashids = true
end