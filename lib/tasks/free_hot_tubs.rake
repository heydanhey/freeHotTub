desc 'Go get any new free hot tubs!'
task free_hot_tubs: :environment do
  require 'open-uri'
  require 'nokogiri'
  Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
  url = 'https://chicago.craigslist.org/search/zip?query=hot+tub'
  search = Nokogiri::HTML(open(url, 'User-Agent' => 'Nooby'))
  entries = search.css('.result-row')
  fhts = []
  entries.each do |entry|
    link = entry.css('a')[0]['href']
    page = Nokogiri::HTML(open(link, 'User-Agent' => 'Nooby'))
    image_link = page.css('img').empty? ? '' : page.css('img')[0]['src']
    description = page
                  .css('section#postingbody')
                  .text
                  .gsub!('QR Code Link to This Post', '')
    title = page.css('span#titletextonly').text
    next unless Fht.find_by(link: link).nil?
    fhts << Fht.create(
      link: link,
      image_link: image_link,
      title: title,
      description: description
    )
  end
end
