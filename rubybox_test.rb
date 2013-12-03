require 'ruby-box'
require 'yaml'


CONFIG_FILE = 'box_test.yml'
config = YAML.load_file(CONFIG_FILE)





session = RubyBox::Session.new({
    client_id: config['client_id'],
    client_secret: config['client_secret'],
    access_token: config['access_token']
})

# grabs refresh token if access token is expired
@token = session.refresh_token(config['refresh_token'])

#creates a new session class and assigns it to client var
client = RubyBox::Client.new(session)

client.folder.create_subfolder('Test23')
puts "I created a new folder with the script"


config["access_token"] = @token.token
config["refresh_token"] = @token.refresh_token

File.open(CONFIG_FILE, "w") do |file|
  file.write(YAML.dump(config))
  puts "Wrote new configuration with access_token and refresh_token to #{CONFIG_FILE}"
end
  









