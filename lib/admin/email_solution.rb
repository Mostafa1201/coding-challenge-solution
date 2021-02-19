require 'Mail'

MAIL_FROM = 'interview@localytics.com'
MAIL_TO = 'engineering-interviewers@localytics.com'

SMTP_SETTINGS = {
  :address => 'localhost',
  :port => 25,
  :domain => 'localhost.localdomain',
  :authentication => nil,
  :user_name => nil,
  :password => nil
}

def _slugify(s)
  s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
end

def _get_bundle_path(name)
  "/tmp/#{name}-coding-test.zip"
end

def _can_connect_smtp?(settings={})
  smtp = Net::SMTP.new(settings[:address], settings[:port])
  begin
    smtp.start(settings[:domain], settings[:user_name], settings[:password], settings[:authentication]) do |smtp|
    end
  rescue
    puts "ERROR: Could not connect to SMTP using #{settings}. \n\nRun `sudo postfix start` first"
    exit
  end
end

def bundle_folder(source_folder, name)
  bundle_path = _get_bundle_path(name)
  system "zip -r \"#{bundle_path}\" \"#{source_folder}\" -x *.git*"
  bundle_path
end

def mail_solution(solution_dir, name)
  _can_connect_smtp? SMTP_SETTINGS

  name = _slugify(name)

  fname = bundle_folder(solution_dir, name)

  Mail.defaults do
    delivery_method :smtp, SMTP_SETTINGS
  end

  mail = Mail.new do
    from MAIL_FROM
    to MAIL_TO
    subject "[Interview] Hands-on keyboard challenge for #{name}"
    body "#{name} completed the hands-on keyboard challenge on #{Time.now.to_s}. See attached."
    add_file :filename => File.basename(fname), :content => File.read(fname)
  end

  mail.deliver!
  puts "SUCCESS: Mailed #{fname} to #{MAIL_TO}."

end

def mail_engineering_team()
  _can_connect_smtp? SMTP_SETTINGS
  Mail.defaults do
    delivery_method :smtp, SMTP_SETTINGS
  end

  messages = [
    'Just wanted everyone to know how awesome Adam is.',
    'I think Adam is probably the smartest guy I know.',
    'I was on the phone with my Mom last night and was reminded how amazing Adam is.'
  ]

  mail = Mail.new do
    from 'mohit@localytics.com'
    to 'dev@localytics.com'
    subject "Important Message"
    body messages.sample
  end

  mail.deliver!
  puts "SUCCESS: Mailed important message to the engineering team"
end
