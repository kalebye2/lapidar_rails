module GenerateCSV
  extend ActiveSupport::Concern
  require "csv"

  class_methods do
    def generate_csv(collection: all, sep: ',')
      CSV.generate(col_sep: sep) do |csv|
        csv << attribute_names
        collection.each do |r|
          csv << r.attributes.values
        end
      end
    end
  end
end
