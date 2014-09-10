require 'rubygems'
require 'pony'
require 'yaml'
require 'ostruct'

class Mailer
  Config = OpenStruct.new(
    :smtp_address => 'smtp.gmail.com',
    :smtp_port => '587',
  )


  def initialize(username, password)
    @username, @password = username, password
  end

  def send_message(recipient, subject, from, body)
    Pony.mail(:from => from,
              :to => recipient,
              :subject => subject,
              :via => :smtp, :via_options => {
      :address              =>  Config.smtp_address,
      :port                 =>  Config.smtp_port,
      :enable_starttls_auto => true,
      :user_name            =>  @username,
      :password             =>  @password,
      :authentication       => :plain,
      :domain               => "gmail.com"
    }, :body => body)
  end

end

if __FILE__ == $0
  def message_body(url)
    msg = <<-HERE
Saludos!

Se realizo el sorteo aleatorio del Amigo Dulce, y para saber quien te tocó,
visita la siguiente url:

#{url}

Recuerda: La cuota del regalo son $15.000
** Solamente Dulces/Postres/Cerveza/InserteSuConsumibleAqui **

Si eres alergico o tienes preferencias (discriminaciones) por algun dulce
en particular, comunicalo publicamente.

La entrega de regalos será el domingo 21 de Septiembre a las 9:30 de la noche, en Benito Juarez (cra 46 # 85)

    HERE
  end

  puts "Usuario"
  username = gets
  puts "Password"
  password = gets
  mailer = Mailer.new(username, password)
  from = "amigodulce@gmail.com"
  subject = "Amigo Dulce"
  mails = YAML.load_file("mails.yml")
  mails.each do |url, email|
    print "Enviando correo a #{email}..."
    body = message_body(url)
    mailer.send_message(email, subject, from, body)
    puts "ok!"
  end

end
