class Admin::AdminController < ApplicationController

  def index
    @table_name = params[:table]
    render template: "admin/index"
  end

  ActiveRecord::Base.connection.tables.each do |table_name|
    Admin.const_set "#{table_name.camelcase}Controller", Class.new(ApplicationController) do
      define_method :index do
      end
      
      define_method :teste do
        12
      end
    end
  end

end
