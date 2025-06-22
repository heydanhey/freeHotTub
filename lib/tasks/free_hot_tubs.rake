desc 'Go get any new free hot tubs!'
task free_hot_tubs: :environment do
  require 'open-uri'
  require 'nokogiri'
  require "net/http"
  require 'json'
  Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
  fhts = []
  locations = ['chicago']
  locations.each do |location|
    url = "https://#{location}.craigslist.org/search/zip?query=hot+tub"
    search = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'Nooby'))
    listings = search.css('li.cl-static-search-result')

    listings.each do |listing|

      title = listing.at_css('.title').text
    
      price = listing.at_css('.price').text
    
      location = listing.at_css('.location').text
    
      link = listing.at_css('a')['href']

      page = Nokogiri::HTML(URI.open(link, 'User-Agent' => 'Nooby'))
      image_link = page.css('img').empty? ? '' : page.css('img')[0]['src']
      description = page
                    .css('section#postingbody')
                    .text
                    .gsub!('QR Code Link to This Post', '')

      fhts << Fht.create(
        link: link.strip,
        image_link: image_link.strip,
        title: title.strip,
        description: description.strip,
        location: location.strip
      )
    
      puts "#{title} #{price} #{location} #{link}"
    
    end





    # entries = search.css('.result-row')
    # entries.each do |entry|
    #   link = entry.css('a')[0]['href']
    #   page = Nokogiri::HTML(open(link, 'User-Agent' => 'Nooby'))
    #   image_link = page.css('img').empty? ? '' : page.css('img')[0]['src']
    #   description = page
    #                 .css('section#postingbody')
    #                 .text
    #                 .gsub!('QR Code Link to This Post', '')
    #   title = page.css('span#titletextonly').text
    #   next unless Fht.find_by(link: link).nil?
    #   fhts << Fht.create(
    #     link: link,
    #     image_link: image_link,
    #     title: title,
    #     description: description,
    #     location: location
    #   )
    # end
  end
  # AdminNotifier.free_hot_tub_notification(fhts.count).deliver
end

desc 'Remove expired free hot tubs.'
task remove_hot_tubs: :environment do
  require 'open-uri'
  require 'nokogiri'
  Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
  fhts = Fht.where(is_active: true)
  fhts.each do |fht|
    link = fht.link
    begin
      page = Nokogiri::HTML(open(link, 'User-Agent' => 'Nooby'))
      if page.css('div#userbody').to_s.include?('removed')
        puts 'REMOVING POST'
        fht.is_active = false
        fht.save
      else
        puts 'POST STILL ACTIVE'
      end
    rescue OpenURI::HTTPError => e
      puts e
      puts 'REMOVING POST'
      fht.is_active = false
      fht.save
    end
  end
end
