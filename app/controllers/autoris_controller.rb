class AutorisController < ApplicationController
    def index
      #@autori = Autori.all
      @autori = Autori.paginate(:page => params[:page], :per_page => 20)
    end
  end