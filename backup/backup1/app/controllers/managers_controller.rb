class ManagersController < ApplicationController
    def manager1
        #@knjige = Knjige.paginate(:page => params[:page], :per_page => 20)  
      #@naslov = params[:naslov]
      if params[:id].nil? or params[:id] == ""
        @id = ""
        @uvjet3 = ""
      else 
        @id = params[:id]
        @uvjet3 = Knjige.sanitize_sql_for_conditions([" AND knjiges.id = ?",params[:id]])
      end

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

      if params[:isbn].nil? or params[:isbn] == ""
        @isbn = ""
        @uvjet4 = ""
      else 
        @isbn = params[:isbn]
        @uvjet4 = Knjige.sanitize_sql_for_conditions([" AND knjiges.isbn = ?",params[:isbn]])
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
    
      @knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + @uvjet4 + @uvjet3 + " GROUP BY knjiges.id" + @uvjet2)
      #@knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, bibliotekes.biblioteka, knjiges.slika FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora INNER JOIN bibliotekes ON bibliotekes.biblioteka_id = knjiges.biblioteka_id WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id" + @uvjet2)
      @brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + @uvjet4 + @uvjet3 + " GROUP BY knjiges.id").length
      #@brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora INNER JOIN bibliotekes ON bibliotekes.biblioteka_id = knjiges.biblioteka_id WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + " GROUP BY knjiges.id").length
      @autori1 = Knjige.connection.select_all("SELECT knjiges.id, autoris.autor FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora")
      @biblioteke = Knjige.connection.select_all("SELECT * FROM bibliotekes");

      #@uu = ("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + @uvjet3 + @uvjet4 + " GROUP BY knjiges.id" + @uvjet2).html_safe
      

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
    def modificiraj_knjigu
        idKnjige = params[:id]   # 1607 je platonov nauk o dusi sa vise autora
        knjiga = Knjige.find(idKnjige)

        @naslov = knjiga[:naslov]
        @godina = knjiga[:godina]
        @cijena = knjiga[:cijena]
        @idKnjige = idKnjige
        @brojStranica = knjiga[:brojstranica]
        @isbn = knjiga[:isbn]
        @slika = knjiga[:slika]
        bibid = knjiga[:biblioteka_id]
        @biblioteke = Biblioteke.all
        @sviautori = Autori.all.order(:autor)
        @autoriKnjige = Veze.connection.select_all("SELECT autoris.autor FROM autoris INNER JOIN vezes ON autoris.id = vezes.kodautora WHERE vezes.kodknjige = " + Veze.sanitize_sql_for_conditions(["?",idKnjige]) + " ORDER BY autoris.autor");
        @pocetniIspisAutora = ""
        for el in @autoriKnjige
            @pocetniIspisAutora += el["autor"] + "; "
        end
        @pocetniIspisAutora = @pocetniIspisAutora.chop.chop


        @ss2 = @autoriKnjige.length
        if !bibid.nil?
            @biblioteka = Biblioteke.find_by(biblioteka_id: bibid).biblioteka
        else
            @biblioteka = ""
        end
      
      @akcija = "akcija je nil"
      if !params[:akcija].nil?
       if params[:akcija] == "dodaj"
        @akcija = "dodaj"
        if Autori.find_by(autor:params[:modificirajAutora]).nil?
            autor = Autori.new
            autor[:autor] = params[:modificirajAutora]
            autor.save
            @sviautori = Autori.all.order(:autor)
        end
       elsif params[:akcija] == "oduzmi"
        @akcija = "oduzmi"
        autor = Autori.find_by(autor:params[:modificirajAutora])
        if !autor.nil? && Veze.find_by(kodautora:autor.id).nil?
            #Veze.where(:kodautora => autor.id).delete_all
            autor.delete
            @sviautori = Autori.all.order(:autor)
        end
       else
        @akcija = "modificiraj "
        sw = false

        @a1 = 0
        @ss = "false"
        if !params[:naslov].nil? && !params[:naslov].to_s.strip.empty?
            # ako nije nil i ako nije prazan string
            knjiga[:naslov] = params[:naslov]
            sw = true
            @a1 = 1
        end

        if !params[:cijena].nil? && !params[:cijena].to_s.strip.empty?
            knjiga[:cijena] = params[:cijena].to_i
            sw = true
        end

        if !params[:godina].nil?
            if !params[:godina].to_s.strip.empty?
                knjiga[:godina] = params[:godina].to_i.to_s
            else
                knjiga[:godina] = nil
            end
            sw = true
        end

        if !params[:brojStranica].nil? 
            if !params[:brojStranica].to_s.strip.empty?
                knjiga[:brojstranica] = params[:brojStranica].to_i
            else
                knjiga[:brojstranica] = nil
            end
            sw = true
        end

        if !params[:isbn].nil? && !params[:isbn].to_s.strip.empty?
            knjiga[:isbn] = params[:isbn]
            sw = true
        end

        @idbb = "n"
        if !params[:biblioteka].nil? 
            idb = Biblioteke.find_by(biblioteka:params[:biblioteka])
            if idb.nil?
                knjiga[:biblioteka_id] = nil
                @idbb = nil
            else
                knjiga[:biblioteka_id] = idb.biblioteka_id
                @idbb = idb.biblioteka_id
            end
            sw = true
        end

        if !params[:autori].nil?
            if params[:autori] == ""
                @obavijestAutori = "prazan string"
            else
                @obavijestAutori = ""
                Veze.where(:kodknjige => idKnjige).delete_all
                for el in params[:autori]
                    ida = Autori.find_by(autor: el).id
                    Veze.create(kodautora: ida, kodknjige: idKnjige)
                    @obavijestAutori += ida.to_s + "; "          
                end
                @sviautori = Autori.all
                @autoriKnjige = Veze.connection.select_all("SELECT autoris.autor FROM autoris INNER JOIN vezes ON autoris.id = vezes.kodautora WHERE vezes.kodknjige = " + Veze.sanitize_sql_for_conditions(["?",idKnjige])  + " ORDER BY autoris.autor");
                @pocetniIspisAutora = ""
                for el in @autoriKnjige
                    @pocetniIspisAutora += el["autor"] + "; "
                end
                @pocetniIspisAutora = @pocetniIspisAutora.chop.chop
            end
        else
            @obavijestAutori = "nema autora"
        end
        

        if sw
            knjiga.save
            @ss = "true"
            #knjiga = Knjige.find(idKnjige)
            @naslov = knjiga[:naslov]
            @godina = knjiga[:godina]
            @cijena = knjiga[:cijena]
            @idKnjige = idKnjige
            @brojStranica = knjiga[:brojstranica]
            @isbn = knjiga[:isbn]
            @slika = knjiga[:slika]
            bibid = knjiga[:biblioteka_id]
            if !bibid.nil?
                @biblioteka = Biblioteke.find_by(biblioteka_id: bibid).biblioteka
            else
                @biblioteka = ""
            end
        end
       end  # if ... elsif ... end petlja
      end  # !params[:action].nil?
      
      if params[:slikaAkcija] == "no"
          knjiga[:slika] = nil
          knjiga.save
          @slika = nil
          @sl = "postavio sam sliku u bazi podataka na nil"
      else
        if !params[:image].nil?
            @slika = params[:image].read
            knjiga[:slika] = @slika
            knjiga.save
            @sl = "ucitao sliku iz paramsa"
        else 
            @slika = knjiga[:slika]
            @sl = "params je nil"
        end
      end

    end

    def manager2
        #flash.now[:danger] = "Dogodila se pogreska!"
        #flash.now[:success] = "proslo!"
        @skladista = Skladista.all
        @auti = params[:skladista]

        if params[:skladiste].nil? || params[:skladiste] == ""
            @odabrani1 = 0;
            uvjet = '""';
        else 
            @odabrani1 = params[:skladiste]
            uvjet = '"' + @odabrani1 + '"';
        end

        if params[:adresa].nil? || params[:adresa] == ""
            @odabrani2 = 0;
        else 
            @odabrani2 = params[:adresa]
        end

        @adrese = Skladista.connection.select_all("SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = " + uvjet)

    end

    def dodaj_skladiste
        s = Skladista.new(skladiste:params[:novo_skladiste])
        if s.valid?
            s.save
            flash[:success] = "Dodano novo skladište!"
        else
            flash[:danger] = "Pogreška! Pokušaj ponovo."
        end
        redirect_to "/manager2"
    end
    def dodaj_adresu
        s1 = "-"
        if !params[:nova_adresa].nil?
            s1 = params[:nova_adresa]
        else 
            flash[:danger] = "Dogodila se pogreska sa adresom!"
        end
        s2 = "-"
        if !params[:skladiste].nil?
            s2 = params[:skladiste]
        else 
            flash[:danger] = "Nisi odabrao skladište!"
        end
        
        id = nil
        if s1 != "-" && s2 != "-"
            skl = Skladista.find_by(skladiste: s2)
            if !skl.nil?
                id = skl.id
            else
                flash[:danger] = "Nisi odabrao skladište!"
            end
        end

        if !id.nil?
            s = Adrese.new(adresa:s1, kodskladista: id)
            s.save
            
            flash[:success] = "Ubačena je nova adresa!"
            redirect_to manager2_url(skladiste:s2)
        else
            #flash[:danger] = "nekakva pogreska!"
            redirect_to "/manager2"
        end
    end
    def oduzmi_skladiste
        #redirect_to manager2_url
        s = ""
        if !params[:skladiste].nil?
            s = params[:skladiste]
        end
        #@s1 = sanitize_sql_for_conditions(["?",s])
        #uvjet = '"' + s + '"';
        uvjet = Skladista.sanitize_sql_for_conditions(["?",s])
        adrese = Skladista.connection.select_all("SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = " + uvjet)
        if adrese.length == 0
            Skladista.destroy_by(skladiste: s)
            flash[:success] = "Skladište je obrisano!"
            redirect_to manager2_url
        else 
            flash[:danger] = "Skladište NIJE obrisano! U njemu postoje adrese. Prvo njih obrisi."
            redirect_to manager2_url
        end
    end
    def oduzmi_adresu
        s = ""
        if !params[:adresa].nil?
            s = params[:adresa]
        end

        uvjet = Adrese.sanitize_sql_for_conditions(["?",s])
        adrese = Adrese.connection.select_all("SELECT veze1.kodknjige FROM adrese INNER JOIN veze1 ON veze1.kodadrese = adrese.id WHERE adrese.adresa = " + uvjet)
        if adrese.length == 0
            Adrese.destroy_by(adresa: s)
            flash[:success] = "Adresa je obrisana!"
            redirect_to manager2_url(skladiste: params[:skladiste])
        else 
            flash[:danger] = "Adresa NIJE obrisana! Na njoj postoje artikli. Prvo njih izbrisi."
            redirect_to manager2_url(adresa: s, skladiste: params[:skladiste])
        end
    end
    def manager3
    end

    def modificiraj_knjigu_pokus

    end
end