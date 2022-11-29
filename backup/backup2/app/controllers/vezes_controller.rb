class VezesController < ApplicationController
    def index
      @veze = Veze.all
    end
end