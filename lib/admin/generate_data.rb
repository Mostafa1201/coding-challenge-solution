require 'time'
require 'json'
require 'rubystats'
require 'securerandom'

GENDERS = ['M', 'F']
DEVICES = ['iOS', 'android']

# event name => dependencies, max count
EVENTS = {
  'Visited home page' => {:prob => 0.20},
  'Visited about page' => {:prob => 0.10},
  'Visited blog post' => {:prob => 0.15},
  'Visited signup page' => {:prob => 0.05},
  'Signed up' => {:depends => 'Visited signup page', :maxcount => 1, :prob => 0.15},
  'Visited product page' => {:prob => 0.20},
  'Added item to cart' => {:depends => 'Visited product page', :prob => 0.075},
  'Purchased items in cart' => {:depends => 'Added item to cart', :prob => 0.075}
}

START_DATE = '2014-05-12'
END_DATE = '2014-05-19'

def _rand_time(from=0.0, to=Time.now)
  # generate a random time in range
  Time.at(from + rand * (to.to_f - from.to_f))
end

def _gen_event_prob_distribution
  cum_prob = 0.0
  probs = []
  EVENTS.keys.sort.each do |event_name|
    cum_prob += EVENTS[event_name][:prob]
    probs << [cum_prob, event_name]
  end
  probs
end

def _rand_event(prob_distr)
  r = rand()
  prob_distr.each do |prob, event_name|
    if r <= prob
      return [event_name, EVENTS[event_name]]
    end
  end
  cum_prob, last_key = prob_distr.reverse[0]
  return [last_key, EVENTS[last_key]]
end

def _get_next_event_time(event_time)
  # the next event occurs within 30 minutes of the previous one
  _rand_time(event_time, event_time + 60 * 30)
end

def _random_normal(mean, std, min=1)
  gen = Rubystats::NormalDistribution.new(mean, std)
  [gen.rng.to_i, min].max
end

def generate_users(num_users)
  # return a hash of {users => {uuid => user profile data}}
  users = {}
  num_users.times do
    uuid = SecureRandom.uuid()
    users[uuid] = {
      :age => _random_normal(30, 5, 18),
      :gender => GENDERS.sample,
      :device => DEVICES.sample
    }
  end
  users
end

def generate_events(users, events_per_user)
  # return a hash of {events => [{uuid: user uuid, name, timestamp}]}
  events = []
  event_time = _rand_time(Time.parse(START_DATE), Time.parse(END_DATE))
  prob_distr = _gen_event_prob_distribution()

  # add ~events_per_user events for each user,
  # sampling randomly from EVENTS and
  # honoring :depends and :maxcount settings
  users.keys.each do |uuid|
    user_events = []
    num_events = _random_normal(events_per_user, events_per_user/2)
    while user_events.length < num_events do
      event, event_settings = _rand_event(prob_distr)
      # check if maxcount has already been satisified
      if (event_settings[:maxcount] and
          user_events.collect { |h| h[:name] }.count(event) >= event_settings[:maxcount])
        next
      end

      # add a dependency event first
      unless event_settings[:depends].nil?
        user_events << {
          :name => event_settings[:depends],
          :timestamp => event_time.to_i,
          :user_id => uuid
        }
        event_time = _get_next_event_time(event_time)
      end

      # add the actual event
      user_events << {
        :name => event,
        :timestamp => event_time.to_i,
        :user_id => uuid
      }
      event_time = _get_next_event_time(event_time)
    end
    events.concat user_events
  end
  events.sort_by { |h| h[:timestamp] }
end

def serialize_to_file(fname, hsh)
  File.open(fname, 'w') do |f|
    f.write(JSON.pretty_generate(hsh))
  end
end

def generate_users_and_events(num_users, events_per_user, output_folder)
  rand_num_users = _random_normal(num_users, num_users/8, num_users/2)
  users = generate_users(rand_num_users)
  events = generate_events(users, events_per_user)

  serialize_to_file(File.join(output_folder, 'users.json'), {'users' => users})
  serialize_to_file(File.join(output_folder, 'events.json'), {'events' => events})
end

if __FILE__ == $0
  genereate_all(10, 8, 'data')
end
