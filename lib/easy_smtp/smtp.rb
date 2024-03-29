module EasySMTP
  module_function

  ### Example parameter for send_email method
  # email_data = {
  #   recipients: 'example@recipient.com;somegal@test.com',
  #   cc_recipients: 'someccrecipient@go.com', # (optional)
  #   bcc_recipients: 'hideme@email.com', # (optional)
  #   from_address: 'fromaddress@mydomain.com',
  #   subject: 'Subject of this email',
  #   body: 'Content of the email!',
  #   html_body: '<html><head></head><body>Content of the email in HTML format!</body></html>', # (optional)
  #   attachments: ['Array of paths to files']
  #   server: smtp.somedomain.com, # (optionally override config)
  #   port: 25, # (optionally override config)
  # }
  def send_email(email_data)
    smtp_server = email_data['server'] || EasySMTP.config['smtp']['server']
    smtp_port = email_data['port'] || EasySMTP.config['smtp']['port']
    raise "SMTP server missing from config. Add the entry to the #{EasySMTP.config.path} \"smtp\": { \"server\": \"hostname_or_ip\" }" if smtp_server.nil? || smtp_server.empty?

    email_data = Hashly.stringify_all_keys(email_data.dup)
    part_boundary = 'PART_BOUNDARY'
    leading_horizontal_whitespace = /^[^\S\n\r]+/
    message = <<-MESSAGE_END.gsub(leading_horizontal_whitespace, '')
                From: #{email_data['from_address']}
                To: #{email_data['recipients']}
                Cc: #{email_data['cc_recipients']}
                Bcc: #{email_data['bcc_recipients']}
                Subject: #{email_data['subject']}
                Mime-Version: 1.0
                Content-Type: multipart/mixed; boundary=#{part_boundary}
                --#{part_boundary}
                Content-Transfer-Encoding: 7bit
                Content-Type: text/plain; charset=us-ascii

                #{email_data['body']}
                --#{part_boundary}
                Content-Transfer-Encoding: 7bit
                Content-Type: text/html; charset=us-ascii

                #{email_data['html_body'] || email_data['body']}
              MESSAGE_END

    unless email_data['attachments'].nil?
      email_data['attachments'].each do |attachment_path|
        file_content = [File.binread(attachment_path)].pack('m') # Encode contents into base64
        message += <<-ATTACHMENT_END.gsub(leading_horizontal_whitespace, '')
          --#{part_boundary}
          Content-Type: application/octet-stream; name="#{File.basename(attachment_path)}"
          Content-Transfer-Encoding:base64
          Content-Disposition: attachment; filename="#{File.basename(attachment_path)}"; size=#{File.size(attachment_path)}

          #{file_content}
        ATTACHMENT_END
      end
    end
    message += "--#{part_boundary}--"

    Net::SMTP.start(smtp_server, smtp_port) do |smtp|
      smtp.send_message message, email_data['from_address'], "#{email_data['recipients']};#{email_data['cc_recipients']};#{email_data['bcc_recipients']}".split(';').reject(&:empty?)
    end
  end
end
