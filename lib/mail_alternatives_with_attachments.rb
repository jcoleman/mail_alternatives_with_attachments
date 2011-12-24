require "mail_alternatives_with_attachments/version"

module MailAlternativesWithAttachments
  require File.expand_path("../lib/action_mailer_prepare_message", __FILE__)
  require File.expand_path("../lib/mail_message_alternative_types_with_attachment", __FILE__)
end
