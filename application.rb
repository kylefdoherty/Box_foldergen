#require 'rails/all'
require 'ruby-box'
require 'sinatra'
require 'yaml'
require 'json'


CONFIG_FILE = 'application.yml'
ENV = YAML.load_file(CONFIG_FILE)





session = RubyBox::Session.new({
    client_id: ENV['client_id'],
    client_secret: ENV['client_secret'],
    access_token: ENV['access_token']
})

# grabs refresh token if access token is expired
@token = session.refresh_token(ENV['refresh_token'])

#creates a new session class and assigns it to client var
client = RubyBox::Client.new(session)




ENV["access_token"] = @token.token
ENV["refresh_token"] = @token.refresh_token

File.open(CONFIG_FILE, "w") do |file|
  file.write(YAML.dump(ENV))
  puts "Wrote new configuration with access_token and refresh_token to #{CONFIG_FILE}"
end
  


client.folder.create_subfolder('Test27')
puts "I created a new folder with the script"

eresp = client.event_response(stream_position=0, stream_type=:all, limit=500)
p eresp.chunk_size



eresp.events.each_with_index do |ev, index|
	if ev.created_by.name == "Kyle D"
		
		if ev.event_type == "ITEM_CREATE"
			if ev.source.parent.name == "SFDC"
				f_id = ev.source.id
				f_name = ev.source.name
				p f_name

				f_status = ev.item_status
					begin 
					#add an if statement to check for file already existing 
				 	client.folder("SFDC/#{f_name}").create_subfolder('CLIENT-FOLDER')
				    rescue
				    end 
		    end
  		end 

  	end 
  end 



# post '/log' do
#   # Retrieve the request's body and parse it as JSON
#   event_json = JSON.parse(request.body.read)
#   p event_json

#   # Do something with event_json
# end





