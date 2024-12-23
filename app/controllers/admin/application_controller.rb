class Admin::ApplicationController < ApplicationController

  def index
    render template: "admin/index"
  end

  ActiveRecord::Base.connection.tables.each do |table_name|
    Admin.const_set "#{table_name.camelcase}Controller", Class.new(ApplicationController) do
      def index
      end
    end
  end

end
