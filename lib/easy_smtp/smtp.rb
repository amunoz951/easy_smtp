module EasySMTP
  ### Example parameter for send_email method
  # email_data = {
  #   'recipients' => 'example@recipient.com;somegal@test.com',
  #   'cc_recipients' => 'someccrecipient@go.com', # (optional)
  #   'bcc_recipients' => 'hideme@email.com', # (optional)
  #   'from_address' => 'fromaddress@mydomain.com',
  #   'subject' => 'Subject of this email',
  #   'body' => 'Content of the email in html format!',
  # }
  def send_email(email_data)
    smtp_server = EasySMTP.config['smtp']['server']
    smtp_port = EasySMTP.config['smtp']['port']
    message = <<-MESSAGE_END.gsub(/^\s+/, '')
              From: #{email_data['from_address']}
              To: #{email_data['recipients']}
              Cc: #{email_data['cc_recipients']}
              Bcc: #{email_data['bcc_recipients']}
              Subject: #{email_data['subject']}
              Mime-Version: 1.0
              Content-Type: text/html
              Content-Disposition: inline
    email_data = Hashly.stringify_all_keys(email_data.dup)

              #{email_data['body']}
              MESSAGE_END

    Net::SMTP.start(smtp_server, smtp_port) do |smtp|
      smtp.send_message message, email_data['from_address'], "#{email_data['recipients']};#{email_data['cc_recipients']};#{email_data['bcc_recipients']}".split(';').reject(&:empty?)
    end
  end
end
