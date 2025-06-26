# DZC 2018-11-16 18:52:22 por si decidimos agregar configuraciones a carrierwave
# CarrierWave.configure do |config|
# 	config.ignore_integrity_errors = true
# 	config.move_to_cache = false
# 	config.move_to_store = true
# end

CarrierWave.configure do |config|

    config.storage    = :aws
    config.aws_bucket = ENV["S3_BUCKET_NAME"]

    config.aws_authenticated_url_expiration = 60 * 30 # 30 minutos
    config.aws_credentials = {
      access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region:            ENV["AWS_REGION"] # Required
    }

    #sftp en local requiere ssh -L1234:10.10.1.240:22 200.27.19.173 -l ext-rialis
    # config.storage = :sftp
    # config.cache_storage = :file

    # config.sftp_host = ENV["FTP_HOST"]
    # config.sftp_user = ENV["FTP_USER"]
    # config.sftp_folder = ENV["FTP_FOLDER"]
    # config.sftp_url = ENV["FTP_URL"]
    # config.sftp_options = {
    #   :password => ENV["FTP_PASSWD"],
    #   :port => ENV["FTP_PORT"],
    # }
    #
end
