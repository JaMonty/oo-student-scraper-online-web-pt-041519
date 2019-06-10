require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        s_profile_link = "#{student.attr('href')}"
        s_location = student.css('.student-location').text
        s_name = student.css('.student-name').text
        students << {name: s_name, location: s_location, profile_url: s_profile_link}
      end
    end
    students
  end





  def self.scrape_profile_page(profile_url)
    stud = {}
    p_page = Nokogiri::HTML(open(profile_url))
    links = p_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        stud[:linkedin] = link
      elsif link.include?("github")
        stud[:github] = link
      elsif link.include?("twitter")
        stud[:twitter] = link
      else
        stud[:blog] = link
      end
    end

    stud[:profile_quote] = p_page.css(".profile-quote").text if p_page.css(".profile-quote")
    stud[:bio] = p_page.css("div.bio-content.content-holder div.description-holder p").text if p_page.css("div.bio-content.content-holder div.description-holder p")

    stud
  end

end
