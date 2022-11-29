class KnjigesController < ApplicationController
    def index
      @knjige = Knjige.paginate(:page => params[:page], :per_page => 20)
      @biblioteke = Biblioteke.all
      @veze = Veze.all
      @autori = Autori.all
    end


  #def show_image
  #  @sl = Knjige.find(params[:id])
  #  send_data @sl.slika, :type => 'image/jpg',:disposition => 'inline'
  #end

  def detalji
      if (params[:id].nil?)
          @knjiga = nil
      else
          @knjiga = Knjige.find(params[:id])
      end
      @biblioteka = params[:biblioteka]
      @autori = params[:autori]
  end

  def pok
  end

  def pokus
    #@knjige = Knjige.paginate(:page => params[:page], :per_page => 20)  
    #@naslov = params[:naslov]
    if params[:naslov].nil?
      @naslov = ""
    else 
      @naslov = Knjige.sanitize_sql_like(params[:naslov])
    end
    
    if params[:autor].nil?
      @autor = ""
    else 
      @autor = Knjige.sanitize_sql_like(params[:autor])
    end

    if params[:godina].nil? or params[:godina] == ""
      @godina = ""
      @uvjet = ""
    else 
      @godina = Knjige.sanitize_sql_like(params[:godina])
      @uvjet = " AND knjiges.godina = " + @godina
    end

    if params[:bibliotekaID].nil?
      @uvjet1 = ""
      @bibliotekaID = 0
    else
      case params[:bibliotekaID]
      when "4"
        @uvjet1 = " AND knjiges.biblioteka_id = 4"
        @bibliotekaID = 4
      when "5"
        @uvjet1 = " AND knjiges.biblioteka_id = 5"
        @bibliotekaID = 5
      when "6"
        @uvjet1 = " AND knjiges.biblioteka_id = 6"
        @bibliotekaID = 6
      when "7"
        @uvjet1 = " AND knjiges.biblioteka_id = 7"
        @bibliotekaID = 7
      when "8"
        @uvjet1 = " AND knjiges.biblioteka_id = 8"
        @bibliotekaID = 8
      when "9"
        @uvjet1 = " AND knjiges.biblioteka_id = 9"
        @bibliotekaID = 9
      else
        @uvjet1 = ""
        @bibliotekaID = 0
      end
    end

    velStranice = 20
    if params[:aktivnaStranica].nil?
      @aktivnaStranica = 1
      @uvjet2 = " LIMIT " + velStranice.to_s
    else
      @aktivnaStranica = params[:aktivnaStranica]
      br = @aktivnaStranica.to_i;
      if br < 2
        @uvjet2 = " LIMIT " + velStranice.to_s
      else
        @uvjet2 = " LIMIT " + ((br-1)*velStranice).to_s + ", " + velStranice.to_s
      end  
    end

    if @autor == ""
      @knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges WHERE knjiges.naslov LIKE '%" + @naslov + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id" + @uvjet2)
      @brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges WHERE knjiges.naslov LIKE '%" + @naslov + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id").length
    else
      @knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id" + @uvjet2)
      @brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id").length
    end
    #@knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id" + @uvjet2)
    #@brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id").length
    
    @autori1 = Knjige.connection.select_all("SELECT knjiges.id, autoris.autor FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora")
    @biblioteke = Knjige.connection.select_all("SELECT * FROM bibliotekes");

    #@brojKnjiga = @uvjet1
    if @brojKnjiga == 0
      @brojStranica = 1
    else
      @brojStranica = (@brojKnjiga-1).div(velStranice) + 1
    end

      #@biblioteke = Biblioteke.all
      #@veze = Veze.all
      #@autori = Autori.all
  end

end