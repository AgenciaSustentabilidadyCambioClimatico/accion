class EmailInterceptor
  def self.delivering_email(message)
    message.to = ['sistemaaccion@accl.cl']
  end
end
