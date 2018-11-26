# Pequeño script que cifra (opcionalmente, comprime+codifica) la data de tipo string.
# Está pensado para generar tokens SEGUROS de hashes (en formato json) pero también 
# puede ser utilizado para generar otro tipo de string (ej: XML) que requieran 
# ofuscado y/o reducción para persitencia/envío HTTP.
#
# Author:: Gino A. Barahona Maldonado
# Copyright:: Binarybag
# Date:: 2017-07-19 - Creado originalmente para sernac-compensacion-papel-tissue
#
#

class CipherPolNineService
  
  attr_accessor :data

  # Para más tipo de algoritmos de cifrado, ejecuta: OpenSSL::Cipher.ciphers
  AES256GCM = 'aes-256-cbc'

  
  def initialize(action,string,encode_decode=true,algorithm=nil)
    algorithm = ( algorithm.blank? ? AES256GCM : algorithm )
    actions = [:encrypt,:decrypt]
    if actions.include?(action.to_sym)
      string = string.to_json if string.is_a?(Hash)
      self.data=send("#{action.to_s}",OpenSSL::Cipher.new(algorithm),string,encode_decode)
      # Intentamos parsear la data como JSON, de ser JSON, podremos convertirlo 
      # en un hash de simbolos (so what?, it's a personal issue)
      json = JSON.parse(data) rescue nil
      if json.is_a?(Hash)
        self.data = CipherPolNineService.symbolized_hash(json)
      end
    else
      raise ArgumentError, 'El primer argumento debería ser encrypt ó decrypt'
    end
  end

  # Toma un string y devuelve la data que representa el contenido comprimido.
  # A pesar de no estar en el scope de esta clase; con la data obtenida de este
  # método, se puede crear un archivo zip en disco (no implementado).
  #
  def self.zip(string)
    Zlib::Deflate.new(nil,-Zlib::MAX_WBITS).deflate(string,Zlib::FINISH)
  end

  # Intenta descomprimir la data que fue obtenida de la función zip de esta misma
  # clase, si no es la misma, lanzará un Zlib::BufError.
  #
  def self.unzip(data)
    content = nil
    begin
      content = Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(data)
    rescue Zlib::Error => zlib_error
      puts "ZlibError - #{zlib_error.message}"
    rescue => exception
      puts "Exception - #{exception.message}"
    end
    content
  end

  def self.symbolized_hash(d)
    h={}
    d.each do |k,v|
      if v.is_a?(Hash)
        h[k.to_sym] = self.symbolized_hash(v)
      else
        h[k.to_sym]=v
      end
    end
    h
  end

  # IMPORTANTE: Si reutilizas esta clase, te recomiendo generar nuevamente el key y el iv 
  # Abre la consola de rails (rails c) y ejecuta lo siguiente: 
  #   => 
  #   => cert_key=cipher.random_key
  #   => cert_iv=cipher.random_iv
  # Reemplaza los strings generados. 
  # El largo de las llaves puede variar, elige la que más te acomode, [winky]
  def self.key_generator(algorithm=nil)
    algorithm = ( algorithm.blank? ? self::AES256GCM : algorithm )
    cipher=OpenSSL::Cipher.new(algorithm)
    {
      key: cipher.random_key,
      iv: cipher.random_iv
    }
  end

  private
  # La opción de encode=true procesa el source para comprimirlo, 
  # encriptarlo y devolverlo encodeado en base64. Este método 
  # no presentará problemas siempre y cuando @source sea un string. 
  # Si se utiliza encode=false, el método decrypt debe llamarse con
  # la opción decode=false
  #
  # Ejemplo:
  # => encr_cipher = CipherPolNineService.new("GABM")
  # (comprime, encripta y codifica)
  # => encr_cipher.encrypt
  #   => "BDgElye8uHqNWrUbv0lKvA=="
  # (sólo encripta)
  # => encr_cipher.encrypt(false)
  #   => "+\x06.n0\xC2\xD2?\x1A\x8F\xBF\x9A\x18\x85h\x19"
  #
  def encrypt(cipher,source,encode=true)
    cipher.encrypt
    set_certs(cipher)
    if encode
      encrypted = Base64.encode64( update( cipher, CipherPolNineService.zip( source ) ) ).encode('utf-8').strip!
    else
      encrypted = update( cipher, source )
    end
    encrypted
  end

  # A diferencia de encrypt este método presentará problemas si se entrega un string 
  # que no haya sido encriptado con los mismos parámetros. Lanzará una excepción con 
  # un string no encodeado sin decode=false, lo mismo sucederá al revés.
  #
  # Ejemplo:
  # => descr_cipher_zip_enc = CipherPolNineService.new("BDgElye8uHqNWrUbv0lKvA==")
  # (decodifica, desencripta y descomprime)
  # => descr_cipher_zip_enc.decrypt
  #   => "GABM"
  # => descr_cipher = CipherPolNineService.new("+\x06.n0\xC2\xD2?\x1A\x8F\xBF\x9A\x18\x85h\x19")
  # (sólo desencripta)
  # => descr_cipher.decrypt(false)
  #   => "GABM"
  #
  def decrypt(cipher,source,decode=true)
    cipher.decrypt
    set_certs(cipher)
    if decode
      decrypted = CipherPolNineService.unzip( update( cipher, Base64.decode64( source ) ) )
    else
      decrypted = update( cipher, source )
    end
    decrypted
  end

  # Implementé esta función sólo porque la llamada a cipher.update se realiza 
  # más de una vez y no me gusta repetir código >.>
  #
  def update(cipher,string)
    updated = nil
    begin
      updated = cipher.update(string) + cipher.final
    rescue OpenSSL::Cipher::CipherError => cipher_error
      puts "CipherError - #{cipher_error.message}"
    rescue => exception
      puts "Exception - #{exception.message}"
    end
    updated
  end

  # Aunque se puede utilizar la misma instancia para encriptar y desencriptar se debe 
  # llamar a estas llaves cada vez que se cambia de encript->decript y viceversa.
  # Este metodo facilita la (re)asignación cuando se requiera utilizar el mismo objeto.
  #
  def set_certs(cipher)
    cipher.key = "\x99\xFB\xDB\f\xF4^T*\xE2\x8C\xC0\xB4\xC5\x89\x84\x97\xFEp\xB2B1?8\x91\xACu\x0F\xCB\xE19\xEAM"
    cipher.iv  = "\x0F\xCF\x01\xFEt\xD2\x90\x1A\x84=\f\x85o\x91\x1C4"
  end

end