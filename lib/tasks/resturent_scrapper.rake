namespace :db do
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

        fileb.puts ", , ,#{ven.groups.collect(&:name).uniq.join(" ")}, #{ven.name}, #{ven.address.gsub(",", " ")}, , #{ven.state_code}, #{ven.postal_code}, #{ven.country}, #{ven.lat}, , #{ven.long}, ,#{ven.phone}" if common_groups.length > 0
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
