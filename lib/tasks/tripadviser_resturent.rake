namespace :db do
  task :resturent_links => :environment do
    b = Watir::Browser.new :chrome

    cities = File.new("uk_city_links.txt", "r")
    while( line = cities.gets ) do 
      puts line
      b.goto line
      b.links(class: 'property_title').each do |res_link|
        TripadviserResturent.create(link: res_link.href)
        puts res_link.href      
      end
      while b.link(class: 'sprite-pageNext').exist?
        puts "#################################################################"
        b.link(class: 'sprite-pageNext').click
        sleep 5
        b.links(class: 'property_title').each do |res_link|
          TripadviserResturent.create(link: res_link.href)
          puts res_link.href      
        end
      end
    end
  end
end
