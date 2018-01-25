class FhtsController < ApplicationController

  def index
    @fhts = Fht.all
  end

  def scrape_craigslist
    require 'open-uri'
    require 'nokogiri'
    url = 'https://chicago.craigslist.org/search/zip?query=hot+tub'
    search = Nokogiri::HTML(open(url, 'User-Agent' => 'Nooby'))

    entries = search.css('.result-row')
    @fhts = []
    entries.each do |entry|
      link = entry.css('a')[0]['href']
      puts entry.css('.result-date')[0].text
      page = Nokogiri::HTML(open(link, 'User-Agent' => 'Nooby'))
      image_link = page.css('img').empty? ? '' : page.css('img')[0]['src']
      description = page.css('section#postingbody').text.gsub!('QR Code Link to This Post', '')
      title = page.css('span#titletextonly').text
      unless Fht.find_by(link: link)
        @fhts << Fht.create(
          link: link,
          image_link: image_link,
          title: title,
          description: description
        )
      end
    end
  end

end
