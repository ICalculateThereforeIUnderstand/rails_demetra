class ManagersController < ApplicationController
    def nova_knjiga
      flash.delete(:danger)
      flash.delete(:success)

      @uputstvaSw = true
      @uputstvaLink = "/nova_knjiga_help"

      @slika = nil
      @idKnjige = nil
      @naslov = nil
      @pocetniIspisAutora = nil
      @autoriKnjige = []
      @cijena = nil
      @biblioteka = nil
      @godina = nil
      @brojStranica = nil
      @isbn = nil
      
      @biblioteke = Biblioteke.all
      @sviautori = Autori.all.order(:autor)
    if params[:akcija] == "dodaj" 
      if params[:modificirajAutora].nil? || params[:modificirajAutora].to_s.strip.empty?
        flash.now[:danger] = "Ime autora ne može biti prazan string!"
      elsif Autori.find_by(autor:params[:modificirajAutora]).nil?
        autor = Autori.new
        autor[:autor] = params[:modificirajAutora]
        autor.save
        flash.now[:success] = "Dodan je novi autor!"
        @sviautori = Autori.all.order(:autor)
      else 
        flash.now[:danger] = "Navedenog autora vec imaš u bazi podataka!"
      end 
    elsif params[:akcija] == "oduzmi" 
      autor = Autori.find_by(autor:params[:modificirajAutora])
      if autor.nil?
        flash.now[:danger] = "Navedeni autor nije pronađen!"
      elsif Veze.find_by(kodautora:autor.id).nil?
        #Veze.where(:kodautora => autor.id).delete_all
        autor.delete
        @sviautori = Autori.all.order(:autor)
        flash.now[:success] = "Navedeni autor je obrisan!"
      else
        flash.now[:danger] = "Navedeni autor ima pridružene knjige! Prvo ga ukloni kao autora tih knjiga, pa ga onda možes izbrisati."
      end
    else

      if !params[:akcija].nil? && params[:akcija] == "nova"
        @sakrijGumb = false  
      else
        @sakrijGumb = true  # sakriva submit button i otkriva link button na manager1
      end

      @pocetniIspisAutora = ""


      sw = false;
      knjiga = Knjige.new
      if !params[:naslov].nil?
        if !params[:naslov].to_s.strip.empty?
          # ako nije nil i ako nije prazan string
          knjiga[:naslov] = params[:naslov]
          sw = true
        else
          flash.now[:danger] = "Ime autora ne može biti prazan string!"
        end
      end

      if !params[:cijena].nil? && !params[:cijena].to_s.strip.empty?
        knjiga[:cijena] = params[:cijena].to_i
      end

      if !params[:godina].nil?
        if !params[:godina].to_s.strip.empty?
            knjiga[:godina] = params[:godina].to_i.to_s
        else
            #knjiga[:godina] = nil
        end
      end

      if !params[:brojStranica].nil? 
        if !params[:brojStranica].to_s.strip.empty?
            knjiga[:brojstranica] = params[:brojStranica].to_i
        else
            #knjiga[:brojstranica] = nil
        end
      end

      if !params[:isbn].nil? && !params[:isbn].to_s.strip.empty?
        knjiga[:isbn] = params[:isbn]
      end

      @val = knjiga.valid?
      if @val && !params[:biblioteka].nil? 
        idb = Biblioteke.find_by(biblioteka:params[:biblioteka])
        if idb.nil?
          #knjiga[:biblioteka_id] = nil
          #@idbb = nil
        else
          knjiga[:biblioteka_id] = idb.biblioteka_id
          @val = knjiga.valid?
        end
      end

      if @val && sw
        if params[:slikaAkcija] == "no"
          knjiga[:slika] = nil
          knjiga.save
          @slika = nil
        else
          if !params[:image].nil?
            @slika = params[:image].read
            knjiga[:slika] = @slika
            knjiga.save
          else 
            @slika = knjiga[:slika]
          end
        end
        @val = knjiga.valid?
      end

      if sw
        knjiga.save
        flash.now[:success] = "Nova knjiga je unesena!"
      end

      if @val && sw
        if !params[:autori].nil?
          #Veze.where(:kodknjige => idKnjige).delete_all
          for el in params[:autori]
            if !el.to_s.strip.empty?
              ida = Autori.find_by(autor: el).id  
              if !ida.nil?
                Veze.create(kodautora: ida, kodknjige: knjiga[:id])
              end 
            end 
          end
        end
      end

      if @val
        @idKnjige = knjiga[:id]
        @naslov = knjiga[:naslov]
        @cijena = knjiga[:cijena]
        @godina = knjiga[:godina]
        @brojStranica = knjiga[:brojstranica]
        @isbn = knjiga[:isbn]
        #@biblioteka = knjiga[:biblioteka_id]
        @biblioteka = params[:biblioteka]

        @autoriKnjige = Veze.connection.select_all("SELECT autoris.autor FROM autoris INNER JOIN vezes ON autoris.id = vezes.kodautora WHERE vezes.kodknjige = " + Veze.sanitize_sql_for_conditions(["?",@idKnjige]) + " ORDER BY autoris.autor");
        @pocetniIspisAutora = ""
        for el in @autoriKnjige
          @pocetniIspisAutora += el["autor"] + "; "
        end
        @pocetniIspisAutora = @pocetniIspisAutora.chop.chop
      end
    end # if params[:akcija] == "dodaj"
    end
    def manager1
        #@knjige = Knjige.paginate(:page => params[:page], :per_page => 20)  
      #@naslov = params[:naslov]
      store_last_index_page  # sprema ovaj URL za back button
      @uputstvaSw = true
      @uputstvaLink = "/manager1_help"

      @skladista = Skladista.all
      if params[:skladiste].nil? || params[:skladiste] == ""
          @odabrani1 = 0;
          @uvjet5 = ""
          strQuery = ""
          @adrese = Skladista.connection.select_all("SELECT adrese.adresa FROM adrese WHERE FALSE");
      else 
          @odabrani1 = params[:skladiste]
          @uvjet5 = Skladista.sanitize_sql_for_conditions([" AND skladista.skladiste = ?",@odabrani1]);
          strQuery = " INNER JOIN veze1 ON veze1.kodknjige = knjiges.id INNER JOIN adrese ON veze1.kodadrese = adrese.id INNER JOIN skladista ON skladista.id = adrese.kodskladista"
          @adrese = Skladista.connection.select_all("SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE TRUE" + @uvjet5);
      end
    
      if params[:adresa].nil? || params[:adresa] == "" || @odabrani1 == 0
        @odabrani2 = 0;
        @uvjet6 = ""
      else 
        @odabrani2 = params[:adresa]
        @uvjet6 = Skladista.sanitize_sql_for_conditions([" AND adrese.adresa = ?",@odabrani2]);
      end
      @strQuery = strQuery

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
      
      if params[:autor].nil? || params[:naslov].to_s.strip.empty?
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
      
      if @autor == ""
        @knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges" + strQuery + " WHERE knjiges.naslov LIKE '%" + @naslov + "%'" + @uvjet + @uvjet1 + @uvjet4 + @uvjet3 + @uvjet5 + @uvjet6 + " GROUP BY knjiges.id" + @uvjet2)
        @brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges"  + strQuery + " WHERE knjiges.naslov LIKE '%" + @naslov + "%'" + @uvjet + @uvjet1 + @uvjet4 + @uvjet3 + @uvjet5 + @uvjet6 + " GROUP BY knjiges.id").length
      else 
        @knjige = Knjige.connection.select_all("SELECT knjiges.id, knjiges.naslov, knjiges.godina, knjiges.cijena, knjiges.biblioteka_id, knjiges.slika FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora" + strQuery + " WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + @uvjet4 + @uvjet3 + @uvjet5 + @uvjet6 + " GROUP BY knjiges.id" + @uvjet2)
        @brojKnjiga = Knjige.connection.select_all("SELECT knjiges.id FROM knjiges INNER JOIN vezes ON vezes.kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora"  + strQuery + " WHERE knjiges.naslov LIKE '%" + @naslov + "%' AND autoris.autor LIKE '%" + @autor + "%'" + @uvjet + @uvjet1 + @uvjet4 + @uvjet3 + @uvjet5 + @uvjet6 + " GROUP BY knjiges.id").length
      end
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
        @uputstvaSw = true
        @uputstvaLink = "/modificiraj_knjigu_help"

        #flash.now[:danger] = ""
        #flash.now[:success] = ""
        flash.delete(:danger)
        flash.delete(:success)

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
        @odabrana = !Odabraneknjige.find_by(id_knjige:idKnjige).nil?  # true ako je knjiga na listi odabranih, inace false
        @pocetniIspisAutora = ""
        for el in @autoriKnjige
            @pocetniIspisAutora += el["autor"] + "; "
        end
        @pocetniIspisAutora = @pocetniIspisAutora.chop.chop

        #@kolicine =  Skladista.connection.select_all("SELECT skladista.skladiste, adrese.adresa, veze1.kolicina FROM veze1 INNER JOIN adrese ON veze1.kodadrese = adrese.id INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE veze1.kodknjige = 1422");
        @kolicine =  Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT skladista.skladiste, adrese.adresa, veze1.kolicina, veze1.id FROM veze1 INNER JOIN adrese ON veze1.kodadrese = adrese.id INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE veze1.kodknjige = ?", idKnjige]));

        @ss2 = @autoriKnjige.length
        if !bibid.nil?
            @biblioteka = Biblioteke.find_by(biblioteka_id: bibid).biblioteka
        else
            @biblioteka = ""
        end


        @odabrani1 = nil
        @skladista = Skladista.all
        @odabrani2 = nil
        uvjet = "Zeleni trg 28";
        uvjet = ""
        @adrese = [] #Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = ?", uvjet]));
        @menuSw = false
      
        if !params[:odabrana].nil? && !params[:odabrana].to_s.strip.empty?
            if params[:odabrana] == "YES" && !@odabrana
                redak = Odabraneknjige.new
                redak[:id_knjige] = idKnjige
                redak.save
                @odabrana = true
            elsif params[:odabrana] == "NO" && @odabrana
                Odabraneknjige.find_by(id_knjige:idKnjige).delete
                @odabrana = false
            end
        end
      
      @akcija = "akcija je nil"
      if !params[:akcija].nil?
       if params[:akcija] == "dodaj adresu"
           if params[:skladiste].nil? || params[:skladiste].to_s.strip.empty? 
               flash.now[:danger] = "Niste odabrali skladište."
               @menuSw = true
           elsif params[:adresa].nil? || params[:adresa].to_s.strip.empty? 
               flash.now[:danger] = "Niste odabrali adresu."
               @menuSw = true
           elsif params[:kolicina1].nil? || params[:kolicina1].to_s.strip.empty? || params[:kolicina1].to_i.to_s != params[:kolicina1] || params[:kolicina1].to_i < 0
               flash.now[:danger] = "Morate zadati količinu koja mora biti pozitivni integer."
               @menuSw = true
           else
               idadr = Adrese.find_by(adresa:params[:adresa])["id"]
               sw1 = Veze1.where(Veze1.sanitize_sql_for_conditions(["kodadrese = ? and kodknjige = ?", idadr, idKnjige])).first.nil?
               if !sw1
                   flash.now[:danger] = "Odabrana adresa je već pridružena knjizi."
                   @menuSw = true
               else
                   vez = Veze1.new
                   vez[:kodknjige] = idKnjige
                   vez[:kodadrese] = idadr
                   vez[:kolicina] = params[:kolicina1].to_i
                   vez.save
                   @kolicine =  Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT skladista.skladiste, adrese.adresa, veze1.kolicina, veze1.id FROM veze1 INNER JOIN adrese ON veze1.kodadrese = adrese.id INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE veze1.kodknjige = ?", idKnjige]));
                   flash.now[:success] = "dodao si adresu"
               end    
           end
       elsif params[:akcija] == "odabrano skladiste"
           @odabrani1 = params[:skladiste]
           @adrese = Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = ?", @odabrani1]));
           @menuSw = true
       elsif params[:akcija] == "modificiraj kolicinu"
           if params[:kolicina].nil? || params[:kolicina].to_s.strip.empty? || params[:kolicina].to_i.to_s != params[:kolicina] || params[:kolicina].to_i < 0
               flash.now[:danger] = "Upisana vrijednost mora biti pozitivan integer."
               @menuSw = true
           elsif params[:idAdrese].nil? || params[:idAdrese].to_s.strip.empty?
               flash.now[:danger] = "Morate prvo odabrati adresu."
               @menuSw = true
           else
               vez1 = Veze1.find(params[:idAdrese])
               vez1[:kolicina] = params[:kolicina].to_i
               vez1.save
               @kolicine =  Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT skladista.skladiste, adrese.adresa, veze1.kolicina, veze1.id FROM veze1 INNER JOIN adrese ON veze1.kodadrese = adrese.id INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE veze1.kodknjige = ?", idKnjige]));
               @menuSw = true
               flash.now[:success] = "Postavili ste novu kolicinu knjiga: " + params[:kolicina];
           end
       elsif params[:akcija] == "obrisi adresu"
           if params[:idAdrese].nil? || params[:idAdrese].to_s.strip.empty?
               flash.now[:danger] = "Morate prvo odabrati adresu."
               @menuSw = true
           else
               Veze1.find(params[:idAdrese]).delete
               @kolicine =  Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT skladista.skladiste, adrese.adresa, veze1.kolicina, veze1.id FROM veze1 INNER JOIN adrese ON veze1.kodadrese = adrese.id INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE veze1.kodknjige = ?", idKnjige]));
               flash.now[:success] = "Obrisali ste adresu" 
               @menuSw = true
           end    
       elsif params[:akcija] == "brisi knjigu" 
           if Veze1.find_by(kodknjige:idKnjige).nil?
               Veze.where(:kodknjige => idKnjige).delete_all
               Knjige.find(idKnjige).delete
               flash[:success] = "Knjiga je obrisana."
               redirect_to "/manager1"
           else
               flash.now[:danger] = "Ne možete obrisati knjigu sa skladišta. Prvo je obrišite u skladištima/adresama."
           end
       elsif params[:akcija] == "dodaj"
        @akcija = "dodaj"
        if params[:modificirajAutora].nil? || params[:modificirajAutora].to_s.strip.empty?
            flash.now[:danger] = "Ime autora ne može biti prazan string!"
        elsif Autori.find_by(autor:params[:modificirajAutora]).nil?
            autor = Autori.new
            autor[:autor] = params[:modificirajAutora]
            autor.save
            flash.now[:success] = "Dodan je novi autor!"
            @sviautori = Autori.all.order(:autor)
        else 
            flash.now[:danger] = "Navedenog autora vec imaš u bazi podataka!"
        end
       elsif params[:akcija] == "oduzmi"
        @akcija = "oduzmi"
        autor = Autori.find_by(autor:params[:modificirajAutora])
        if autor.nil?
            flash.now[:danger] = "Navedeni autor nije pronađen!"
        elsif Veze.find_by(kodautora:autor.id).nil?
            #Veze.where(:kodautora => autor.id).delete_all
            autor.delete
            @sviautori = Autori.all.order(:autor)
            flash.now[:success] = "Navedeni autor je obrisan!"
        else
            flash.now[:danger] = "Navedeni autor ima pridružene knjige! Prvo ga ukloni kao autora tih knjiga, pa ga onda možes izbrisati."
        end
       else
        @akcija = "modificiraj "
        sw = true

        @a1 = 0
        @ss = "false"
        if !params[:naslov].nil? && !params[:naslov].to_s.strip.empty?
            # ako nije nil i ako nije prazan string
            knjiga[:naslov] = params[:naslov]
            @a1 = 1
        else
          sw = false
          flash.now[:danger] = "Naslov ne moze biti prazan string!"
        end

        if !params[:cijena].nil? && !params[:cijena].to_s.strip.empty?
            knjiga[:cijena] = params[:cijena].to_i
            #sw = true
        else
            knjiga[:cijena] = nil
            #sw = true
        end

        if !params[:godina].nil?
            if !params[:godina].to_s.strip.empty?
                knjiga[:godina] = params[:godina].to_i.to_s
            else
                knjiga[:godina] = nil
            end
            #sw = true
        end

        if !params[:brojStranica].nil? 
            if !params[:brojStranica].to_s.strip.empty?
                knjiga[:brojstranica] = params[:brojStranica].to_i
            else
                knjiga[:brojstranica] = nil
            end
            #sw = true
        end

        if !params[:isbn].nil? && !params[:isbn].to_s.strip.empty?
            knjiga[:isbn] = params[:isbn]
            #sw = true
        else
            knjiga[:isbn] = nil
            #sw = true
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
            #sw = true
        end

        if !params[:autori].nil? && sw
            if params[:autori] == ""
                @obavijestAutori = "prazan string"
            else
                @obavijestAutori = ""
                Veze.where(:kodknjige => idKnjige).delete_all
                for el in params[:autori]
                    if !el.to_s.strip.empty?
                      ida = Autori.find_by(autor: el).id
                      if !ida.nil?
                        Veze.create(kodautora: ida, kodknjige: idKnjige)
                        @obavijestAutori += ida.to_s + "; "          
                      end  
                    end  
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
            flash.now[:success] = "Promjene su unesene!"
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
        @uputstvaSw = true
        @uputstvaLink = "/manager2_help"

        @skladista = Skladista.all
        @auti = params[:skladista]

        if params[:skladiste].nil? || params[:skladiste] == ""
            @odabrani1 = 0;
            #uvjet = '""';
            uvjet = ''
        else 
            @odabrani1 = params[:skladiste]
            #uvjet = '"' + @odabrani1 + '"';
            uvjet = @odabrani1
        end

        if params[:adresa].nil? || params[:adresa] == ""
            @odabrani2 = 0;
        else 
            @odabrani2 = params[:adresa]
        end

        #@adrese = Skladista.connection.select_all("SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = " + uvjet)
        @adrese = Skladista.connection.select_all(Skladista.sanitize_sql_for_conditions(["SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = ?",uvjet]));

    end

    def dodaj_skladiste
        if params[:novo_skladiste].nil? || params[:novo_skladiste].to_s.strip.empty?
            flash[:danger] = "Pogreška! Ime novog skladista ne smije biti prazan string."
        elsif !Skladista.find_by(skladiste:params[:novo_skladiste]).nil?
            flash[:danger] = "Pogreška! Ime novog skladista mora biti jedinstveno."
        else
            s = Skladista.new(skladiste:params[:novo_skladiste])
            if s.valid?
                s.save
                flash[:success] = "Dodano novo skladište!"
            else
                flash[:danger] = "Pogreška! Pokušaj ponovo."
            end
        end
        redirect_to "/manager2"
    end
    def dodaj_adresu
        s1 = "-"
        if !params[:nova_adresa].nil? && !params[:nova_adresa].to_s.strip.empty?
            s1 = params[:nova_adresa]
        else 
            flash[:danger] = "Adresa ne smije biti prazan string!"
        end
        s2 = "-"
        if !params[:skladiste].nil? && !params[:skladiste].to_s.strip.empty?
            s2 = params[:skladiste]
        else 
            flash[:danger] = "Nisi odabrao skladište!"
        end
        
        id = nil
        swi = true
        if s1 != "-" && s2 != "-"
            skl = Skladista.find_by(skladiste: s2)
            if !skl.nil?
                id = skl.id
            else
                flash[:danger] = "Nisi odabrao skladište!"
            end
            swi = Adrese.connection.select_all(Adrese.sanitize_sql_for_conditions(["SELECT * FROM adrese WHERE kodskladista = ? AND adresa = ?", id,s1])).first.nil?
        end

        if !swi
            flash[:danger] = "Vec imas adresu sa tim imenom u odabranom skladistu."        
            redirect_to manager2_url(skladiste:s2)
        elsif !id.nil?
            #s = Adrese.new(adresa:s1, kodskladista: id)

            s = Adrese.new
            s.kodskladista = id
            s.adresa = s1
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