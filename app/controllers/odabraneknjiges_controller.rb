class OdabraneknjigesController < ApplicationController
    def index
      #@knjige = Knjige.paginate(:page => params[:page], :per_page => 20)
      @knjige = Knjige.all
      @biblioteke = Biblioteke.all
      @veze = Veze.all
      @autori = Autori.all
      @odabraneknjige = Odabraneknjige.all
    end


end