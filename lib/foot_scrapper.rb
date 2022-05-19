require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

def scrap_page(table,page)
  n = 1
  p = 0

  while n < 21
    position = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[1]"
    club = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[2]/span[1]"
    points= "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[3]"
    joues = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[4]"
    gagnes = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[5]"
    nuls = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[6]"
    perdus= "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[7]"
    buts_pour= "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[8]"
    buts_contre = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[9]"
    diff = "/html/body/main/div[2]/div[2]/div[2]/div/div/div/div[2]/div[2]/ul/li[#{n.to_s}]/a/div[10]"
    name_list = [position, club, points, joues, gagnes, nuls, perdus, buts_pour, buts_contre, diff]

    while p < name_list.length
      page.xpath(name_list[p]).each do |node|
        table[p] << node.text
      end
      p = p + 1
    end
    p = 0
    n = n + 1
  end
  return table
end

def new_csv(table,c)

  columns = table.transpose
  l = 0
  report = "journee_#{c}"

  CSV.open("day_csv/#{report}.csv", "w") do |csv|
    while l < 21
      csv << columns[l]
      l = l + 1
    end
  end

end

def perform()
  c = 1

  while c < 39
    url = "https://www.ligue1.fr/classement?matchDay=#{c.to_s}&seasonId=2021-2022"
    page = Nokogiri::HTML(URI(url).open())

    array_position = ["POSITION"]
    array_club = ["CLUB"]
    array_points= ["POINTS"]
    array_joues= ["JOURNEE"]
    array_gagnes= ["GAGNES"]
    array_nuls= ["NULS"]
    array_perdus= ["PERDUS"]
    array_buts_pour= ["BUTS_POUR"]
    array_buts_contre= ["BUTS_CONTRE"]
    array_diff= ["DIFF"]
    table = [array_position, array_club, array_points, array_joues, array_gagnes, array_nuls, array_perdus, array_buts_pour,array_buts_contre, array_diff]

    results = scrap_page(table,page)
    new_csv(results,c)
    c = c + 1
  end

end

perform()
