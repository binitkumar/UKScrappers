namespace :db do
  task :update_state => :environment do
    Rails.logger.fatal "updating state"
    postal_hash = Hash.new
    File.open("db/gb.txt",'r') do |fileb|
      while( line = fileb.gets ) do
        sections = line.split("\t")
        postal_hash[sections[1] ] = sections[5]      
      end
    end

    filter_groups = [   
      "Thai", 
      "Indian", 
      "Indpak", 
      "Latin American", 
      "Latin", 
      "Greek", 
      "Mediterranean", 
      "American (New)", 
      "Newamerican", 
      "Pakistani", 
      "Spanish",
      "Tapasmallplates", 
      "Turkish", 
      "Cuban", 
      "Portuguese", 
      "American (Traditional)", 
      "Tradamerican", 
      "Chinese",
      "Asian Fusion", 
      "Asianfusion", 
      "Bangladeshi", 
      "Mexican", 
      "Tex-Mex", 
      "Tex-mex", 
      "Japanese", 
      "Korean", 
      "Cantonese", 
      "French", 
      "Middle Eastern", 
      "Mideastern", 
      "Lebanese", 
      "Salvadoran", 
      "Argentine", 
      "Afghan", 
      "Afghani", 
      "Indonesian", 
      "Himalayan::Nepalese", 
      "Himalayan", 
      "Basque", 
      "Sushi Bars", 
      "Sushi", 
      "Persian::Iranian", 
      "Persian", 
      "Caribbean", 
      "Southern", 
      "German", 
      "Cajun::Creole", 
      "Cajun", 
      "Arabian", 
      "African", 
      "Peruvian", 
      "Falafel", 
      "Canadian (New)", 
      "Newcanadian", 
      "Delicatessen", 
      "Ethiopian", 
      "Brazilian", 
      "Szechuan", 
      "Mongolian", 
      "Moroccan", 
      "Vietnamese", 
      "Ethnic Food", 
      "Ethnicmarkets", 
      "Austrian", 
      "Kosher", 
      "Belgian", 
      "Russian", 
      "South African", 
      "Southafrican", 
      "Hawaiian",  
      "Egyptian", 
      "Tuscan", 
      "Shanghainese", 
      "Malaysian", 
      "Ramen", 
      "Colombian", 
      "Polish", 
      "Australian", 
      "Taiwanese", 
      "Venezuelan", 
      "Singaporean",  
      "Scandinavian",
      "Ukrainian" 
    ]

    Resturent.where(country: "GB").each do |ven|
      Rails.logger.fatal ven.groups.collect(&:name)
      common_groups = ven.groups.collect(&:name) & filter_groups
      Rails.logger.fatal "postal code #{ven.postal_code}"
      if ven.postal_code.to_s != "" && common_groups.length > 0
        postal_frag = ven.postal_code.split(" ")[0]
        puts "postal_code #{ven.postal_code} , state #{postal_hash[postal_frag]}"
        state = postal_hash[postal_frag]
        ven.update_column(:state_code, state)
      end
    end
    
  end

  task :update_city => :environment do
    Rails.logger.fatal "Generating csv"
    Geocoder.configure(timeout: 60)

    filter_groups = [   
      "Thai", 
      "Indian", 
      "Indpak", 
      "Latin American", 
      "Latin", 
      "Greek", 
      "Mediterranean", 
      "American (New)", 
      "Newamerican", 
      "Pakistani", 
      "Spanish",
      "Tapasmallplates", 
      "Turkish", 
      "Cuban", 
      "Portuguese", 
      "American (Traditional)", 
      "Tradamerican", 
      "Chinese",
      "Asian Fusion", 
      "Asianfusion", 
      "Bangladeshi", 
      "Mexican", 
      "Tex-Mex", 
      "Tex-mex", 
      "Japanese", 
      "Korean", 
      "Cantonese", 
      "French", 
      "Middle Eastern", 
      "Mideastern", 
      "Lebanese", 
      "Salvadoran", 
      "Argentine", 
      "Afghan", 
      "Afghani", 
      "Indonesian", 
      "Himalayan::Nepalese", 
      "Himalayan", 
      "Basque", 
      "Sushi Bars", 
      "Sushi", 
      "Persian::Iranian", 
      "Persian", 
      "Caribbean", 
      "Southern", 
      "German", 
      "Cajun::Creole", 
      "Cajun", 
      "Arabian", 
      "African", 
      "Peruvian", 
      "Falafel", 
      "Canadian (New)", 
      "Newcanadian", 
      "Delicatessen", 
      "Ethiopian", 
      "Brazilian", 
      "Szechuan", 
      "Mongolian", 
      "Moroccan", 
      "Vietnamese", 
      "Ethnic Food", 
      "Ethnicmarkets", 
      "Austrian", 
      "Kosher", 
      "Belgian", 
      "Russian", 
      "South African", 
      "Southafrican", 
      "Hawaiian",  
      "Egyptian", 
      "Tuscan", 
      "Shanghainese", 
      "Malaysian", 
      "Ramen", 
      "Colombian", 
      "Polish", 
      "Australian", 
      "Taiwanese", 
      "Venezuelan", 
      "Singaporean",  
      "Scandinavian",
      "Ukrainian" 
    ]

    Resturent.where(country: "GB").each do |ven|
      common_groups = ven.groups.collect(&:name) & filter_groups
      ven.save if common_groups.length > 0
      sleep 1 if common_groups.length > 0
    end

  end


  task :generate_resturent_csv => :environment do
    Rails.logger.fatal "Generating csv"

    filter_groups = [   
      "Thai", 
      "Indian", 
      "Indpak", 
      "Latin American", 
      "Latin", 
      "Greek", 
      "Mediterranean", 
      "American (New)", 
      "Newamerican", 
      "Pakistani", 
      "Spanish",
      "Tapasmallplates", 
      "Turkish", 
      "Cuban", 
      "Portuguese", 
      "American (Traditional)", 
      "Tradamerican", 
      "Chinese",
      "Asian Fusion", 
      "Asianfusion", 
      "Bangladeshi", 
      "Mexican", 
      "Tex-Mex", 
      "Tex-mex", 
      "Japanese", 
      "Korean", 
      "Cantonese", 
      "French", 
      "Middle Eastern", 
      "Mideastern", 
      "Lebanese", 
      "Salvadoran", 
      "Argentine", 
      "Afghan", 
      "Afghani", 
      "Indonesian", 
      "Himalayan::Nepalese", 
      "Himalayan", 
      "Basque", 
      "Sushi Bars", 
      "Sushi", 
      "Persian::Iranian", 
      "Persian", 
      "Caribbean", 
      "Southern", 
      "German", 
      "Cajun::Creole", 
      "Cajun", 
      "Arabian", 
      "African", 
      "Peruvian", 
      "Falafel", 
      "Canadian (New)", 
      "Newcanadian", 
      "Delicatessen", 
      "Ethiopian", 
      "Brazilian", 
      "Szechuan", 
      "Mongolian", 
      "Moroccan", 
      "Vietnamese", 
      "Ethnic Food", 
      "Ethnicmarkets", 
      "Austrian", 
      "Kosher", 
      "Belgian", 
      "Russian", 
      "South African", 
      "Southafrican", 
      "Hawaiian",  
      "Egyptian", 
      "Tuscan", 
      "Shanghainese", 
      "Malaysian", 
      "Ramen", 
      "Colombian", 
      "Polish", 
      "Australian", 
      "Taiwanese", 
      "Venezuelan", 
      "Singaporean",  
      "Scandinavian",
      "Ukrainian" 
    ]

    File.open("places.csv",'w') do |fileb|
      fileb.puts "id, type_of_place, owner_id, ethnicity_ids, name, address_full, address_steet, address_town, address_postcode, address_country, latitude, longitude, email, phone, last_updated"

      Resturent.where(country: "GB").each do |ven|
        common_groups = ven.groups.collect(&:name) & filter_groups

        fileb.puts ", , ,#{ven.groups.collect(&:name).uniq.join(" ")}, #{ven.name}, #{ven.address.gsub(",", " ")}, , #{ven.city}, #{ven.state_code}, #{ven.postal_code}, #{ven.country}, #{ven.lat}, , #{ven.long}, ,#{ven.phone}" if common_groups.length > 0
      end
    end

  end

  task :resturent_load => :environment do
    client = Yelp::Client.new({ consumer_key: "l2iU68fppCoswpANxJG3Fw",
      consumer_secret: "HSJAnXjB04C-yka23dv7hK1tcuY",
      token: "hlVA-eByq1mG201CCOXRlkdqHJiGaJQT",
      token_secret: "-fkrT7uiYW_I7YW5_zRhuOH3U_4"
    })

    Neighbourhood.all.each do |neigh|
      begin
      sleep 4
      resp = client.search("#{neigh.name} GB", {term: 'food'})

      resp.businesses.each do |biz|
        res = Resturent.find_by_yelp_id(biz.id)
        if res.nil?
          res = Resturent.create(
            rating: biz.try("rating"),
            name: biz.try("name"),
            phone: biz.try("phone"),
            yelp_id: biz.try("id"),
            postal_code: biz.try("location").try("postal_code"),
            address: biz.try("location").try("address").join(" "),
            country: biz.try("location").try("country_code"),
            state_code: biz.try("location").try("state_code"),
            lat: biz.try("location").try("coordinate").try("latitude"),
            long: biz.try("location").try("coordinate").try("longitude")
          )
          begin
            biz.categories.each do |catg1|
              catg1.each do |catg|
                existing_group = Group.find_by_name(catg.camelcase)
                if existing_group.nil?
                  group = Group.create(name: catg.camelcase)
                  ResturentGroup.create(resturent_id: res.id, group_id: group.id )
                else
                  ResturentGroup.create(resturent_id: res.id, group_id: existing_group.id )
                end
              end
            end
          rescue => exp
            Rails.logger.fatal "Exception in fetching categegories"
          end
        end
      end
      rescue => exp
        Rails.logger.fatal exp.message
      end
    end
  end
end
