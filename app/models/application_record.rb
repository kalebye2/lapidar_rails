class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_initialize :test

  before_save :normalize_blank_values
  
  def normalize_blank_values
    attributes.each do |k,v|
      self[k].present? || self[k] = nil
    end
  end

  def test
    puts "Lorem ipsum dolor sit amet"
  end
end
