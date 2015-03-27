namespace :db do
  task :neighbourhood_load => :environment do
    file = File.new("db/uk_locations.txt", "r")
    while (line = file.gets)
      details = line.split("\t")
      name = details[0]
      lat_lang = "#{details[1].gsub("'N", "")},-#{details[2].gsub("'W", "")}"
      ll_join = lat_lang.gsub("°", ".")
      lat = ll_join.split(",")[0]
      lan = ll_join.split(",")[1]
      Neighbourhood.create(name: name, latitude: lat, longitude: lan, status: nil)
    end
  end


  task :load_venue => :environment do
    school_counter = 0
    
    keyword_array = ['Protest Church', 'Orthodox church', "Hindu Temple", "Synagogue", "Baha'i temple", "Buddhist temple", 'Church', 'Mosque', 'Gurdwara', 'Jain temple', 'shinto shrine', 'Taoist temple']
    
    forsquare_client = Foursquare2::Client.new(:client_id => 'QV2WZGZLT5C2MMV2VFROO1AEDVHHXAOV0J4DFJLSKISIBQMA', :client_secret => 'KNDA2W4RX1T3NF0UKEFLINT51AWZGKABWWDL42SH14G25EOO')

    keys = ["AIzaSyArD9T3KBItaZikoLGkXxSDAcDAjGprsFM", "AIzaSyA82Gg8TWg6I05NuDw8CzTgPmp6L5P3Bmk", "AIzaSyC62G93zfOCls3aGIbInUQ_S0cPS6b4NWo", "AIzaSyDFuAhJ8xVoNbWGPqWv1OaifKOKKlEr4Hw"]
    key_rotator = 0

    keyword_array.each do |key|

      Neighbourhood.all.each do |neighbourhood|
        begin
          query = "#{key}+in+#{neighbourhood.name}+ United+Kingdom".gsub(" ","+")
          next_page = 'firstpage'
          while next_page != ""
            next_page_query = next_page == "firstpage" ? "" : "&pagetoken=#{next_page}"

            key_rotator += 1

            current_key = keys[ key_rotator % keys.length ]
            query_string = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{query}&sensor=true&key=#{current_key}#{next_page_query}"
        
            Rails.logger.fatal query_string
            resp_string = RestClient.get(query_string)
            resp = JSON.parse(resp_string)

            resp["results"].each do |result|
              current_venue = nil
              begin
                if Venue.find_by_google_id(result["id"]).nil?
                  Rails.logger.fatal "Loading venue : #{result["name"]}"
                              
                  current_venue = Venue.create(
                    google_id: result["id"],
                    name: result["name"],
                    lat: result["geometry"]["location"]["lat"],
                    lang: result["geometry"]["location"]["lng"],
                    address: result["formatted_address"],
                    city: neighbourhood.name
                  )

                  result["types"].each do |type|
                    category = nil
                    ctg = Category.find_by_name type
                    if ctg
                      category = ctg
                    else
                      category = Category.create(name: type)
                    end
                    current_venue.categories.push category  
                  end
                  res = forsquare_client.search_venues(:ll => "#{current_venue.lat},#{current_venue.lang}", :query => current_venue.name, :v=>20151113, limit: 500)
                  if res.venues.count > 0
                    location = res.venues.first
                    current_venue.update_attributes(
                      forsquare_id: location.id,
                      #name:         location.name,
                      phone:        location.contact.phone,
                      twitter:      location.contact.twitter,
                      facebook:     location.contact.facebook,
                      facebook_name:location.contact.facebookName,
                      checkins_count:location.stats.checkinsCount,
                      tips_count:   location.stats.tipsCount,
                      users_count:  location.stats.usersCount,
                      url:          location.url,
                      store_id:     location.store_id,
                      referal_id:   location.referal_id,
                      #address:      location.location.address,
                      #lat:          location.location.lat,
                      #lang:         location.location.lng,
                      postal_code:  location.location.postal_code,
                      cc:           location.location.cc,
                      city:         location.location.city,
                      state:        location.location.state,
                      country:      location.location.country 
                    )                     
                    location.categories.each do |categ|
                      associated_category = Category.find_by_forsquare_id categ.id
                    
                      if associated_category
                        VenueCategory.create(venue_id: current_venue.id, category_id: associated_category.id, primary: categ.primary)
                      else
                        associated_category = Category.create(forsquare_id: categ.id, name: categ.name)
                        VenueCategory.create(venue_id: current_venue.id, category_id: associated_category.id, primary: categ.primary)
                      end
                    end
                  end 
                end
              rescue => exp
                Rails.logger.fatal "Exception in processing #{result} --- #{exp}"
              end
            end
            next_page = resp["next_page_token"] ? resp["next_page_token"] : ""
            sleep 375
          end

        rescue => exp
          puts "Exception in processing #{exp.message}"
        end
        neighbourhood.update_attribute(:status, "Loaded")
      end
    end
  end

  task :generate_csv => :environment do
    Rails.logger.fatal "Generating csv"
    venues = Category.find_by_name("church").venues
    File.open("places.csv",'w') do |fileb|
      fileb.puts "Type, Name, Address, Phone, Email, Latitude, Longitude"
      venues.each do |ven|
        fileb.puts "#{ven.categories.collect(&:name).join(" ")}, #{ven.name}, #{ven.address.gsub(",", " ")}, #{ven.phone}, , #{ven.lat}, #{ven.lang}"
      end
    end
  end

  task :category_load => :environment do
    Rails.logger.fatal "Loading categories.............."

    client = Foursquare2::Client.new(:client_id => 'QV2WZGZLT5C2MMV2VFROO1AEDVHHXAOV0J4DFJLSKISIBQMA', :client_secret => 'KNDA2W4RX1T3NF0UKEFLINT51AWZGKABWWDL42SH14G25EOO')

    categories = client.venue_categories(:v=>20151113)
    categories.each do |catg|
      load_category(catg)
    end  
  end

  task :place_load => :environment do 
    Rails.logger.fatal "----------------------"
    counter = 0
    file = File.new("db/usa_locations.txt", "r")
    client = Foursquare2::Client.new(:client_id => 'QV2WZGZLT5C2MMV2VFROO1AEDVHHXAOV0J4DFJLSKISIBQMA', :client_secret => 'KNDA2W4RX1T3NF0UKEFLINT51AWZGKABWWDL42SH14G25EOO')
    while (line = file.gets)
      counter += 1
      break if counter == 2
      details = line.split("\t")
      lat_lang = "#{details[1].gsub("'N", "")},-#{details[2].gsub("'W", "")}"
    
      ll = lat_lang.gsub("°", ".")
      
      begin
        sleep 30
        Rails.logger.fatal "Fetching info for #{line}"
        res = client.search_venues(:ll => ll, :query => 'Church', :v=>20151113, limit: 500)
        
        res.venues.each do |location|
          venue = Venue.find_by_forsquare_id location.id

          if venue.nil?
            venue = Venue.create
          end
          venue.update_attributes(
            forsquare_id: location.id,
            name:         location.name,
            phone:        location.contact.phone,
            twitter:      location.contact.twitter,
            facebook:     location.contact.facebook,
            facebook_name:location.contact.facebookName,
            checkins_count:location.stats.checkinsCount,
            tips_count:   location.stats.tipsCount,
            users_count:  location.stats.usersCount,
            url:          location.url,
            store_id:     location.store_id,
            referal_id:   location.referal_id,
            address:      location.location.address,
            lat:          location.location.lat,
            lang:         location.location.lng,
            postal_code:  location.location.postal_code,
            cc:           location.location.cc,
            city:         location.location.city,
            state:        location.location.state,
            country:      location.location.country 
          )
          
          location.categories.each do |categ|
            associated_category = Category.find_by_forsquare_id categ.id
          
            if associated_category
              VenueCategory.create(venue_id: venue.id, category_id: associated_category.id, primary: categ.primary)
            else
              associated_category = Category.create(forsquare_id: categ.id, name: categ.name)
              VenueCategory.create(venue_id: venue.id, category_id: associated_category.id, primary: categ.primary)
            end
          end
        end
      rescue => exp
        Rails.logger.fatal "Failed to fetch info for #{line} due to #{exp.message}"
      end
    end
    file.close
  end
end

def load_category(category)
  if Category.find_by_forsquare_id(category.id).nil?
    puts "#{category.id} : #{category.name} "
    Category.create(forsquare_id: category.id, name: category.name)

    unless category.categories.nil?
      category.categories.each do |catg|
        load_category(catg)
      end
    end
  end
end
