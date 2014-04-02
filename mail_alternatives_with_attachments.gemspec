# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mail_alternatives_with_attachments/version"

Gem::Specification.new do |s|
  s.name        = "mail_alternatives_with_attachments"
  s.version     = MailAlternativesWithAttachments::VERSION
  s.authors     = ["James Coleman"]
  s.email       = ["jtc331@gmail.com"]
  s.homepage    = "https://github.com/jcoleman/mail_alternatives_with_attachments"
  s.summary     = %q{This gem makes it easy to send multipart alternative emails from ActionMailer 3}
  s.description = %q{ActionMailer 3 makes it much easier to send emails, but there is one case it doesn't handle well.\
 Specifically, it is difficult to send a message that has the proper MIME hiearchy for an email with both HTML and text alternatives\
 that also includes attachments. This gem solves that need.}
 s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "actionmailer", "~> 4.0"
end
