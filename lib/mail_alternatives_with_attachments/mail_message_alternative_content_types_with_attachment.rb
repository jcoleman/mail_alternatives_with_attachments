module MailAlternativesWithAttachments::MailMessageAlternativeWithAttachment

  def alternative_content_types_with_attachment(options, &block)
    text_alternative = Mail::Part.new do
      content_type "text/plain; charset=UTF-8"
      body options[:text]
    end

    html_alternative = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body options[:html]
    end

    html_container = Mail::Part.new { content_type 'multipart/related' }
    html_container.add_part html_alternative

    alternative_bodies = Mail::Part.new { content_type 'multipart/alternative' }
    alternative_bodies.add_part text_alternative
    alternative_bodies.add_part html_container

    add_part alternative_bodies

    if block_given?
      yield(html_container.attachments)
    end

    return self
  end

end

Mail::Message.send(:include, MailAlternativesWithAttachments::MailMessageAlternativeWithAttachment)