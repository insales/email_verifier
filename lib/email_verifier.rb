require "email_verifier/version"

module EmailVerifier
  require 'email_verifier/checker'
  require 'email_verifier/exceptions'
  require 'email_verifier/config'
  require "email_verifier/validates_email_realness"

  if defined?(Rails::Railtie)
    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'rails-i18n' do |app|
        locale_files = Dir[File.join(File.expand_path(File.dirname(__FILE__) + '/../locales'), '*.yml')]
        I18n.load_path.push *locale_files
      end
    end
  end

  def self.check(email)
    return true if config.test_mode

    v = EmailVerifier::Checker.new(email)
    v.connect
    v.verify
  end

  def self.config(&block)
    if block_given?
      block.call(EmailVerifier::Config)
    else
      EmailVerifier::Config
    end
  end
end

