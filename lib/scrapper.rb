require 'nokogiri'
require 'open-uri'

class Scrapper
  def url_to_email(url)
    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com#{url}"))
  	doc.css('td')[7].text
  end

  def get_urls
    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
    tab = doc.css('p > a').map { |link| link['href'] }
  end

  def annuaire
    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))

    names = doc.css('p > a').map{ |name| name.text }
    emails = get_urls.map{ |url| url_to_email(url) }

    res = []
    names.length.times do |i|
      res += [{ "name" => names[i] , "email" => emails[i] }]
      i += 1
    end

    return res
  end
end
