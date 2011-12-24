Why?
====

Spam filters often require that an HTML email also have a Text alternative that is generally the same as the HTML message. This means you need to send an email with a MIME type of `multipart/alternative` containing `text/html` and `text/plain` parts. ActionMailer 3 supports this scenario, but it falls apart when you need to add (inline) attachments to that mix. The property MIME hierarchy for an email like this is:

* `multipart/mixed`
    * `multipart/alternative`
        * `multipart/related`
            * `text/html`
            * `image/png` (e.g. for an inline attachment; pdf would be another good example)
        * `text/plain`
    * `application/zip` (e.g for an attachment--not inline)

If this seems more complicated then it should be, that's because it is. Thankfully, this gem allows you to create this entire hierarchy without all the hard work.

Installation:
=============

Either include 

    gem "mail_alternatives_with_attachments"

in your Gemfile (if using Bundler) or run

    gem install mail_alternatives_with_attachments

Usage:
======

Including the `mail_alternatives_with_attachments` gem in your project will patch ActionMailer with the following two methods:

* `ActionMailer::Base#prepare_message(headers={})`: This method does exactly what `ActionMailer::Base#mail(headers={})` does; however it doesn't automatically rendering of templates so that we add our own custom message parts.
* `Mail::Message#alternative_content_types_with_attachment(options, &block)`: This method allows you to conveniently add all of the different parts of complex email with alternatives and attachments.

Typically when using ActionMailer 3, you would create a message with the following code:

    class MyEmailerClass < ActionMailer::Base
      def my_email_method(address)
        mail :to => address, 
             :from => "noreply@myemail.com",
             :subject => "My Subject"
      end
    end

Using this gem to create an email with both alternatives and attachments you would use the following code:

    class MyEmailerClass < ActionMailer::Base
      def my_email_method(address, attachment, logo)
        message = prepare_message to: address, subject: "My Subject", :content_type => "multipart/mixed"
        
        message.alternative_content_types_with_attachment(
          :text => render_to_string(:template => "my_template.text"),
          :html => render_to_string(:template => "my_template.html")
        ) do |inline_attachments|
          inline_attachments.inline['logo.png'] = logo
        end
        
        attachments['attachment.pdf'] = attachment
        
        message
      end
    end
