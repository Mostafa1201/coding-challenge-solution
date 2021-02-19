# rake generate -- call once to generate user/event data
# rake email_solution name="Joe Interviewee"
# rake clean

require 'rake'
require './lib/admin.rb'

directory 'data'

desc "Show help"
task :help do
  puts "\nRake example usage: "
  puts "## email this folder to the interviewers@loc list"
  puts "rake email_solution name=\"Joe Interviewee\""

  puts "\n\n## clean up all new/extra files to original state for next candidate"
  puts "rake clean\n\n"
end

desc "Generate Data"
task :generate => 'data' do
  base_num_users = ENV['NUM_USERS'] || 5000
  num_events_per_user = ENV['EVENTS_PER_USER'] || 8
  generate_users_and_events(base_num_users, num_events_per_user, 'data')
end

desc "Remove data and clean (warning: this deletes the test data)"
task :clean_generate do
  rm_rf 'data'
end

desc "Email solution: rake email_solution name=\"Bob Dole\""
task :email_solution do
  if ENV['name'].nil?
    puts "Usage: rake email_solution name=\"Bob Dole\""
    exit
  end
  if ENV['dir'].nil?

  end
  mail_solution('.', ENV['name'])
end

task :email_engineering_team do
  mail_engineering_team
end

desc "Reset exercise to master"
task :clean do
  STDOUT.puts "Files that will be reverted / removed:\n\n"
  system "git --no-pager diff"
  system "git clean -f -d --dry-run"
  STDOUT.puts "Are you sure you want to reset the coding interview? Make sure you call `rake mail_solution` first. (y/n)"
  input = STDIN.gets.strip
  if input == 'y'
    system "git reset --hard HEAD"
    system "git clean -f -d"
  else
    STDOUT.puts "doing nothing"
  end
end
