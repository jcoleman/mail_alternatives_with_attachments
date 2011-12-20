module MailAlternativesWithAttachments::ActionMailerPrepareMessage

  # Copied directly from ActionMailer::Base#mail but without
  # the automatic rendering of templates.
  def prepare_message(headers={})
    # Guard flag to prevent both the old and the new API from firing
    # Should be removed when old API is removed
    @mail_was_called = true
    m = @_message

    # At the beginning, do not consider class default for parts order neither content_type
    content_type = headers[:content_type]
    parts_order  = headers[:parts_order]

    # Call all the procs (if any)
    default_values = self.class.default.merge(self.class.default) do |k,v|
      v.respond_to?(:call) ? v.bind(self).call : v
    end

    # Handle defaults
    headers = headers.reverse_merge(default_values)
    headers[:subject] ||= default_i18n_subject

    # Apply charset at the beginning so all fields are properly quoted
    m.charset = charset = headers[:charset]

    # Set configure delivery behavior
    wrap_delivery_behavior!(headers.delete(:delivery_method))

    # Assign all headers except parts_order, content_type and body
    assignable = headers.except(:parts_order, :content_type, :body, :template_name, :template_path)
    assignable.each { |k, v| m[k] = v }

    # Setup content type, reapply charset and handle parts order
    m.content_type = set_content_type(m, content_type, headers[:content_type])
    m.charset      = charset

    if m.multipart?
      parts_order ||= headers[:parts_order]
      m.body.set_sort_order(parts_order)
      m.body.sort_parts!
    end

    m
  end

end

ActionMailer::Base.send(:include, MailAlternativesWithAttachments::ActionMailerPrepareMessage)