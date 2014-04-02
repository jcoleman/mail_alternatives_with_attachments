module MailAlternativesWithAttachments::ActionMailerPrepareMessage

  # Copied directly from ActionMailer::Base#mail but without
  # the automatic rendering of templates.
  def prepare_message(headers = {}, &block)
    return @_message if @_mail_was_called && headers.blank? && !block

    @_mail_was_called = true
    m = @_message

    # At the beginning, do not consider class default for content_type
    content_type = headers[:content_type]

    # Call all the procs (if any)
    default_values = {}
    self.class.default.each do |k,v|
      default_values[k] = v.is_a?(Proc) ? instance_eval(&v) : v
    end

    # Handle defaults
    headers = headers.reverse_merge(default_values)
    headers[:subject] ||= default_i18n_subject

    # Apply charset at the beginning so all fields are properly quoted
    m.charset = charset = headers[:charset]

    # Set configure delivery behavior
    wrap_delivery_behavior!(headers.delete(:delivery_method), headers.delete(:delivery_method_options))

    # Assign all headers except parts_order, content_type and body
    assignable = headers.except(:parts_order, :content_type, :body, :template_name, :template_path)
    assignable.each { |k, v| m[k] = v }

    # Setup content type, reapply charset and handle parts order
    m.content_type = set_content_type(m, content_type, headers[:content_type])
    m.charset      = charset

    if m.multipart?
      m.body.set_sort_order(headers[:parts_order])
      m.body.sort_parts!
    end

    m
  end

end

ActionMailer::Base.send(:include, MailAlternativesWithAttachments::ActionMailerPrepareMessage)