class ApplicationController < ActionController::Base
  def render_error(code)
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/#{code}.html", :layout => false, :status => :not_found }
      format.xml { head :not_found}
      format.any { head :not_found }
    end
  end
end
