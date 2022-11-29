class BibliotekesController < ApplicationController
  def index
    @biblioteke = Biblioteke.all
  end
end
