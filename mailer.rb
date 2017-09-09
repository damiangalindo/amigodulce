require 'rubygems'
require 'pony'
require 'yaml'
require 'ostruct'
require 'sendgrid-ruby'
include SendGrid
require 'json'

class Mailer
  def self.send_message(recipient, subject, from, body)
    from = Email.new(email: from)
    to = Email.new(email: recipient)
    content = Content.new(type: 'text/plain', value: body)
    mail = SendGrid::Mail.new(from, subject, to, content)
    # puts JSON.pretty_generate(mail.to_json)
    # puts mail.to_json

    sg = SendGrid::API.new(api_key: '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', host: 'https://api.sendgrid.com')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

end

if __FILE__ == $0
  def message_body(url)
    msg = <<-HERE
Saludos!

Se realizo el sorteo aleatorio del Amigo Dulce, y para saber quien te tocó,
visita la siguiente url:

#{url}

Recuerda: La cuota del regalo son $30.000
** Solamente Dulces/Postres/Cerveza/InserteSuConsumibleAqui **

Si eres alergico o tienes preferencias (discriminaciones) por algun dulce
en particular, comunicalo publicamente.

    HERE
  end

  from = "amigodulcer4us@gmail.com"
  subject = "Amigo Dulce"
  mails = YAML.load_file("mails.yml")
  mails.each do |url, email|
    print "Enviando correo a #{email}..."
    body = message_body(url)
    Mailer.send_message(email, subject, from, body)
    puts "ok!"
  end

end
