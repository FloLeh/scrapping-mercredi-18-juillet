require 'bundler'
require "google_drive"

require 'csv'

Bundler.require
$:.unshift File.expand_path("./../lib", __FILE__)
require 'scrapper'

def scrapping_mails_townhalls
  Scrapper.new.annuaire
end

def write_to_json
  File.open("./db/emails.JSON","w") do |f|
    f.write(scrapping_mails_townhalls.to_json)
  end
end

def write_to_spreadsheet
  session = GoogleDrive::Session.from_config("config.json")

  ws = session.spreadsheet_by_key("1zTfcqIIQE4ET-VMLnxPemD-HwprsBU4fjXCzC0-uNQQ").worksheets[0]

  ws[1,1] = "name"
  ws[1,2] = "email"
  i = 1
  scrapping_mails_townhalls.each do |c|
    ws[i+1, 1] = c["name"]
    ws[i+1, 2] = c["email"]
    i += 1
  end
  ws.save
end

def write_to_csv
  list = scrapping_mails_townhalls
  CSV.open("./db/emails.csv", "w") do |csv|
    list.each{ |h| csv << [h]}
  end
end

def get_from_csv
  arr_of_arrs = CSV.read("./db/emails.csv")
end
