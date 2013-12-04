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




config["access_token"] = @token.token
config["refresh_token"] = @token.refresh_token

File.open(CONFIG_FILE, "w") do |file|
  file.write(YAML.dump(config))
  puts "Wrote new configuration with access_token and refresh_token to #{CONFIG_FILE}"
end
  


# client.folder.create_subfolder('Test27')
# puts "I created a new folder with the script"

eresp = client.event_response(stream_position=0, stream_type=:all, limit=500)
p eresp.chunk_size



eresp.events.each_with_index do |ev, index|
	if ev.created_by.name == "Kyle D"
		
		if ev.event_type == "ITEM_CREATE"
			if ev.source.parent.name == "SFDC"
				f_id = ev.source.id
				f_name = ev.source.name
				p f_name
				#add an if statement to check for file already existing 
				 client.folder("SFDC/#{f_name}").create_subfolder('CLIENT-FOLDER')
  			end
  		end 

  	end 

end




