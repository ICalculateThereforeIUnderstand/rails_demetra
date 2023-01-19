module ApiHelper
  def vratiPodatke()  # paznja, kvadratno vrijeme. sa pametnim querijem mozes bolje od toga
    var = Skladista.connection.select_all("SELECT id, skladiste FROM skladista");
    adr = Adrese.connection.select_all("SELECT adresa, kodskladista FROM adrese");
    var1 = []
    var.each do |el|
      id = el["id"]
      skl = el["skladiste"]
      adr1 = []
      adr.each do |el1|
        idadr = el1["kodskladista"]
        if (idadr === id)
          adr1.push(el1["adresa"])
        end
      end
      var1.push({"id"=>id, "skladiste"=>skl, "adrese"=> adr1})
    end
    return var1
  end

  def vratiPodatke1()  # linearno vrijeme
    var = Skladista.connection.select_all("SELECT id, skladiste FROM skladista");
    adr = Adrese.connection.select_all("SELECT adresa, kodskladista FROM adrese");
 
    var1 = Hash.new
    var.each do |el|
      id = el["id"]
      var1[id] = []
    end

    adr.each do |el1|
      idadr = el1["kodskladista"]
      var1[idadr].push(el1["adresa"])
    end

    var2 = []
    var.each do |el|
      id = el["id"]
      skl = el["skladiste"]
      var2.push({"id"=>id, "skladiste"=>skl, "adrese"=> var1[id]})
    end

    return var2
  end

  def vratiSveKnjige1()  # linearno vrijeme
    var = Knjige.connection.select_all("SELECT id, naslov, godina, cijena, brojstranica, isbn, biblioteka_id, slika, hash_kod FROM knjiges;");
    autori = Knjige.connection.select_all("SELECT kodknjige, autor, autoris.id as autorID FROM vezes INNER JOIN autoris ON autoris.id = kodautora;");
    biblioteke = Biblioteke.connection.select_all("SELECT * FROM bibliotekes");

    skl = Knjige.connection.select_all("SELECT knjiges.id as id, naslov, adresa, skladiste, kolicina, kodadrese FROM knjiges INNER JOIN veze1 ON kodknjige = knjiges.id INNER JOIN adrese ON kodadrese = adrese.id INNER JOIN skladista ON kodskladista = skladista.id");
    odabrane = Odabraneknjige.connection.select_all("SELECT * FROM odabraneknjiges");

    autoriHash = Hash.new
    for autor in autori
      kod = autor["kodknjige"]
      if (autoriHash.key?(kod))
        autoriHash[kod]["autori"].push(autor["autor"]);
        autoriHash[kod]["autoriID"].push(autor["autorID"]);
      else 
        autoriHash[kod] = {"autori"=>[autor["autor"]],"autoriID"=>[autor["autorID"]]}
      end
    end

    bibliotekeHash = Hash.new
    for biblioteka in biblioteke
      bibliotekeHash[biblioteka["biblioteka_id"]] = biblioteka["biblioteka"]
    end  

    lokacijeHash = Hash.new 
    skl.each do |el1|
      idadr = el1["id"]
      if (lokacijeHash.key?(idadr))
        lokacijeHash[idadr]["skladista"].push(el1["skladiste"]);
        lokacijeHash[idadr]["adrese"].push(el1["adresa"]);
        lokacijeHash[idadr]["kolicine"].push(el1["kolicina"]);
        lokacijeHash[idadr]["adreseID"].push(el1["kodadrese"]);
      else 
        lokacijeHash[idadr] = {"skladista" => [el1["skladiste"]],
        "adrese"=>[el1["adresa"]], "kolicine"=>[el1["kolicina"]],
        "adreseID"=>[el1["kodadrese"]]}
      end
    end
      
    for el in var
      if (!el["slika"].nil?)
        #el["slika"] = "slika" + CGI.escape(Base64.encode64(el["slika"])[1500..1510]) + ".jpg"
        if (el["hash_kod"].nil?)
          el["slika"] = "slika.jpg"
        else 
          el["slika"] = "slika" + el["hash_kod"] + ".jpg"
        end
        # ovaj mehanizam je hack koji dodaje hash na ime filea, tako da ako promjenimo sliku,
        # prisiljavamo kompjuter zbog drugacijeg hasha da ne koristi cache
      end
      #el["slika"] = nil

      kod = el["id"]
      
      if (autoriHash.key?(kod))
        autoriRez = autoriHash[kod]["autori"]
        autoriID = autoriHash[kod]["autoriID"]
      else 
        autoriRez = []
        autoriID = []
      end

      el["autori"] = autoriRez;
      el["autoriID"] = autoriID;

      kod = el["biblioteka_id"]
      if !kod.nil?
        el["biblioteka"] = nil
        if (bibliotekeHash.key?(kod))
          el["biblioteka"] = bibliotekeHash[kod]
        end
      else 
        el["biblioteka"] = nil
      end

      kod = el["id"]
      if (lokacijeHash.key?(kod))
        el["skladista"] = lokacijeHash[kod]["skladista"]
        el["adrese"] = lokacijeHash[kod]["adrese"]
        el["adreseID"] = lokacijeHash[kod]["adreseID"]
        el["kolicine"] = lokacijeHash[kod]["kolicine"]
      else 
        el["skladista"] = []
        el["adrese"] = []
        el["kolicine"] = []
        el["adreseID"] = []
      end

      el["odabrana"] = false
      odabrane.each do |el1|
        idodabrane = el1["id_knjige"]
        if (idodabrane === kod)
          el["odabrana"] = true
          break
        end
      end
    end
    return var
  end

  def vratiSveKnjige2()  # kvadratno vrijeme
    var = Knjige.connection.select_all("SELECT id, naslov, godina, cijena, brojstranica, isbn, biblioteka_id, slika, hash_kod FROM knjiges;");
    autori = Knjige.connection.select_all("SELECT kodknjige, autor, autoris.id as autorID FROM vezes INNER JOIN autoris ON autoris.id = kodautora;");
    biblioteke = Biblioteke.connection.select_all("SELECT * FROM bibliotekes");

    skl = Knjige.connection.select_all("SELECT knjiges.id as id, naslov, adresa, skladiste, kolicina, kodadrese FROM knjiges INNER JOIN veze1 ON kodknjige = knjiges.id INNER JOIN adrese ON kodadrese = adrese.id INNER JOIN skladista ON kodskladista = skladista.id");
    odabrane = Odabraneknjige.connection.select_all("SELECT * FROM odabraneknjiges");

    for el in var
      if (!el["slika"].nil?)
        #el["slika"] = "slika" + CGI.escape(Base64.encode64(el["slika"])[1500..1510]) + ".jpg"
        if (el["hash_kod"].nil?)
          el["slika"] = "slika.jpg"
        else 
          el["slika"] = "slika" + el["hash_kod"] + ".jpg"
        end
        # ovaj mehanizam je hack koji dodaje hash na ime filea, tako da ako promjenimo sliku,
        # prisiljavamo kompjuter zbog drugacijeg hasha da ne koristi cache
      end
      #el["slika"] = nil

      kod = el["id"]
      autoriRez = []
      autoriID = []
      for autor in autori
        if (autor["kodknjige"] == kod)
          autoriRez.push(autor["autor"]);
          autoriID.push(autor["autorID"]);
        end
      end
      el["autori"] = autoriRez;
      el["autoriID"] = autoriID;

      kod = el["biblioteka_id"]
      if !kod.nil?
        el["biblioteka"] = nil
        for biblioteka in biblioteke
          if (kod === biblioteka["biblioteka_id"]) 
            el["biblioteka"] = biblioteka["biblioteka"]
            break
          end
        end
      else 
        el["biblioteka"] = nil
      end

      kod = el["id"]
      skladista = []
      adrese = []
      adreseID = []
      kolicine = []
      el["skladista"] = skladista
      el["adrese"] = adrese
      el["kolicine"] = kolicine
      el["adreseID"] = adreseID
      skl.each do |el1|
        idadr = el1["id"]
        if (idadr === kod)
          skladista.push(el1["skladiste"])
          adrese.push(el1["adresa"])
          adreseID.push(el1["kodadrese"])
          kolicine.push(el1["kolicina"])
        end
      end

      el["odabrana"] = false
      odabrane.each do |el1|
        idodabrane = el1["id_knjige"]
        if (idodabrane === kod)
          el["odabrana"] = true
          break
        end
      end
    end
    return var
  end
  def vratiAutoreBiblioteke()
    var = Autori.connection.select_all("SELECT * FROM autoris ORDER BY autor");
    var1 = Biblioteke.connection.select_all("SELECT * FROM bibliotekes");
    return {"autori"=>var, "biblioteke"=>var1}
  end
end

class ApiController < ApplicationController
    def sviAutoriBibliotekeSkladistaAdrese
      var = helpers.vratiAutoreBiblioteke()
      var1 = helpers.vratiPodatke()
      var["skladistaAdrese"] = var1
      render json: var
    end
    def izdvajamoApi
        var = Knjige.connection.select_all("SELECT o.id_knjige as id, naslov, godina, cijena, brojstranica, isbn, biblioteka, slika FROM odabraneknjiges as o INNER JOIN knjiges  ON knjiges.id = o.id_knjige INNER JOIN bibliotekes as b ON b.biblioteka_id = knjiges.biblioteka_id;").to_a();
        autori = Knjige.connection.select_all("SELECT odabraneknjiges.id_knjige as id, autor FROM odabraneknjiges INNER JOIN knjiges ON knjiges.id = odabraneknjiges.id_knjige INNER JOIN vezes ON kodknjige = knjiges.id INNER JOIN autoris ON autoris.id = vezes.kodautora;").to_a();
        for el in var
            if (!el["slika"].nil?)
                el["slika"] = 1; #Base64.encode64(el["slika"])
            end
            autoriRez = []
            for autor in autori
                if (autor["id"] === el["id"])
                    autoriRez.push(autor["autor"]);
                end
            end
            el["autori"] = autoriRez;
        end
        #sleep(1)
        render json: var
    end

    def sve_knjigeApi
        var = Knjige.connection.select_all("SELECT id, naslov, godina, cijena, brojstranica, isbn, biblioteka_id, slika, hash_kod FROM knjiges;");
        autori = Knjige.connection.select_all("SELECT kodknjige, autor FROM vezes INNER JOIN autoris ON autoris.id = kodautora;");
        biblioteke = Biblioteke.connection.select_all("SELECT * FROM bibliotekes");

        for el in var
            if (!el["slika"].nil?)
                #el["slika"] = "slika" + CGI.escape(Base64.encode64(el["slika"])[510..520]) + ".jpg"; #Base64.encode64(el["slika"])
                if (el["hash_kod"].nil?)
                  el["slika"] = "slika.jpg"
                else 
                  el["slika"] = "slika" + el["hash_kod"] + ".jpg"
                end
            end
            #el["slika"] = nil

            kod = el["id"]
            autoriRez = []
            for autor in autori
                if (autor["kodknjige"] == kod)
                    autoriRez.push(autor["autor"]);
                end
            end
            el["autori"] = autoriRez;

            kod = el["biblioteka_id"]
            if !kod.nil?
                el["biblioteka"] = nil
                for biblioteka in biblioteke
                  if (kod === biblioteka["biblioteka_id"]) 
                    el["biblioteka"] = biblioteka["biblioteka"]
                    break
                  end
                end
            else 
                el["biblioteka"] = nil
            end
        end
        #sleep(4)
        render json: var
    end

    def slika
        id = Knjige.sanitize_sql_like(params[:id])
        var = Knjige.connection.select_all("SELECT slika, hash_kod FROM knjiges WHERE id = " + id);    
        #render json: var
        var1 = var[0]["slika"]
        var2 = var[0]["hash_kod"]
        if (var2.nil?)
          send_data(var1, :filename => "slika.jpg", :type=>"image/jpg")
        else 
          send_data(var1, :filename => "slika" + var2 + ".jpg", :type=>"image/jpg")
        end
    end

    def sve_knjigeApi1
      var = helpers.vratiSveKnjige1()
      #sleep(4)
      render json: var
  end

    def modificiraj_knjiguApi
      tip = params[:tip]
      if (tip === "NO_QUERY")
        var = {"value"=>nil, "error"=>false, "errorCode"=>"no error"}
      elsif (tip === "OBRISI_KNJIGU")
        payload = params[:payload]
        knjigaID = payload[:knjigaID]
        a = Veze1.find_by(kodknjige:knjigaID)
        if a.nil?
          b = Knjige.find(knjigaID)
          b.delete
          uvjet = Veze.sanitize_sql_for_conditions(["WHERE kodknjige = ?",knjigaID])
          v = Veze.connection.select_all("DELETE FROM vezes " + uvjet);
          v = Veze.connection.select_all("DELETE FROM veze1 " + uvjet);
          uvjet = Veze.sanitize_sql_for_conditions(["WHERE id_knjige = ?",knjigaID])
          v = Veze.connection.select_all("DELETE FROM odabraneknjiges " + uvjet);
          var = {"value"=>1, "error"=>false, "errorCode"=>"No error"}  
        else
          var = {"value"=>1, "error"=>true, "errorCode"=>"Brisanje nije uspijelo. Knjiga ima pridruzeno skladiste/adresu."}  
        end
      elsif (tip === "OBRISI_PRIDRUZENU_ADRESU")
        payload = params[:payload]
        adresaID = payload[:adresaID]
        knjigaID = payload[:knjigaID]

        s = Veze1.find_by(kodknjige:knjigaID,kodadrese:adresaID)
        if (s.nil?)
          var = {"value"=>1, "error"=>true, "errorCode"=>"POGRESKA! Zapis nije pronaden u bazi podataka."}  
        else 
          s.delete
          var = {"value"=>1, "error"=>false, "errorCode"=>"no error"}
        end
      elsif (tip === "PRIDRUZI_KNJIZI_NOVU_ADRESU")
        payload = params[:payload]
        novaKolicina = payload[:novaKolicina]
        adresa = payload[:adresa]
        skladiste = payload[:skladiste]
        id = payload[:id]

        uvjet = Veze.sanitize_sql_for_conditions(["WHERE skladiste = ? AND adresa = ?",skladiste, adresa])
        s = Veze.connection.select_all("SELECT skladista.id as skladisteID, adrese.id as adresaID, skladiste, adresa FROM skladista INNER JOIN adrese ON kodskladista = skladista.id " + uvjet)

        if (s.length === 1) 
          ishod = true
        else 
          ishod = false
          poruka = "POGRESKA! U bazi podataka nije pronadena jedinstvena kombinacija skladista i adrese"
        end

        if (ishod)
          skladisteID = s[0]["skladisteID"]
          adresaID = s[0]["adresaID"]
          s1 = Veze1.find_by(kodknjige:id, kodadrese:adresaID)
          if (!s1.nil?)
            ishod = false
            poruka = "POGRESKA! U bazi podataka vec imas pridruzen par skladiste-adresa zadanoj knjizi."
          else 
            s2 = Veze1.new(kodknjige:id, kodadrese:adresaID, kolicina:novaKolicina)
            if (!s2.save)
              ishod = false
              poruka = "POGRESKA! Snimanje nove kolicine u bazi podataka nije uspijelo."
            end
          end
        end

        if (ishod)
          var = {"value"=>1, "error"=>false, "errorCode"=>"no error"}
        else 
          var = {"value"=>1, "error"=>true, "errorCode"=>poruka}
        end
      elsif (tip === "PROMIJENI_KOLICINU")
        payload = params[:payload]
        s = Veze1.find_by(kodknjige:payload[:knjigaID], kodadrese:payload[:adresaID])
        s[:kolicina] = payload[:novaKolicina]
        if s.save 
          var = {"value"=>1, "error"=>false, "errorCode"=>"No error"}
        else 
          var = {"value"=>1, "error"=>true, "errorCode"=>"Unos nove kolicine nije uspio."}
        end

      elsif (tip === "DODAJ_AUTORA")
        payload = params[:payload]
        s = Autori.new(autor:payload[:noviAutor])
        if s.save
          var1 = helpers.vratiAutoreBiblioteke()
          var = {"value"=>var1, "error"=>false, "errorCode"=>nil}
        else
          var = {"value"=>1, "error"=>true, "errorCode"=>"Unos autora u bazu podataka nije uspio"}
        end
      elsif (tip === "OBRISI_AUTORA")
        payload = params[:payload]

        red = Autori.find_by(autor:payload[:obrisaniAutor])  
        if red.nil?
          var = {"value"=>nil, "error"=>true, "errorCode"=>"Zadani autor nije pronaden u bazi podataka"}
        else 
          uvjet = Autori.sanitize_sql_for_conditions(["WHERE autor = ?",payload[:obrisaniAutor]])
          s = Autori.connection.select_all("SELECT autor, autoris.id, kodknjige FROM autoris INNER JOIN vezes ON kodautora = autoris.id " + uvjet);
          if s.length == 0
            red.delete
            var1 = helpers.vratiAutoreBiblioteke()
            var = {"value"=>var1, "error"=>false, "errorCode"=>nil}
          else
            var = {"value"=>nil, "error"=>true, "errorCode"=>"1Zadani autor ima pridruzene knjige."}
          end
        end
      elsif (tip === "UNESI_NOVU_KNJIGU")
        payload = params[:payload]
        knjiga = Knjige.new
        knjiga[:naslov] = payload[:naslov]
        knjiga[:godina] = payload[:godina]
        knjiga[:cijena] = payload[:cijena]
        knjiga[:brojstranica] = payload[:brojStranica]
        knjiga[:isbn] = payload[:isbn]
        knjiga[:biblioteka_id] = payload[:bibliotekaID]
        if (payload[:slikaUcitanaSw])
          sl = payload[:slikaFile]
          if (sl.nil?)
            knjiga[:slika] = nil
            knjiga[:hash_kod] = payload[:hashKod]
          else 
            knjiga[:slika] = Base64.decode64(sl)
            knjiga[:hash_kod] = payload[:hashKod]
          end
        end

        if knjiga.save 
          sw = payload[:selectedSw]
          if sw
            s = Odabraneknjige.new(id_knjige:knjiga[:id])
            s.save 
          end

          payload[:autoriID].each do |a|
            Veze.create(kodautora:a, kodknjige:knjiga[:id])
          end

          var = {"value"=>knjiga[:id], "error"=>false, "errorCode"=>"no error"}
        else 
          var = {"value"=>nil, "error"=>true, "errorCode"=>"Unos nove knjige nije uspio"}
        end
        
      elsif (tip === "MODIFICIRAJ_KNJIGU")
        payload = params[:payload]
        knjiga = Knjige.find(payload[:id])
        knjiga[:naslov] = payload[:naslov]
        knjiga[:godina] = payload[:godina]
        knjiga[:cijena] = payload[:cijena]
        knjiga[:brojstranica] = payload[:brojStranica]
        knjiga[:isbn] = payload[:isbn]
        knjiga[:biblioteka_id] = payload[:bibliotekaID]
        if (payload[:slikaUcitanaSw])
          sl = payload[:slikaFile]
          if (sl.nil?)
            knjiga[:slika] = nil
            knjiga[:hash_kod] = payload[:hashKod]
          else 
            knjiga[:slika] = Base64.decode64(sl)
            knjiga[:hash_kod] = payload[:hashKod]
          end
        end

        red = Odabraneknjige.find_by(id_knjige:payload[:id])  
        sw = payload[:selectedSw]
        #uvjet = true
        if red.nil?
          if sw
            s = Odabraneknjige.new(id_knjige:payload[:id])
            s.save 
          end
        else
          if !sw
            red.delete
          end
        end

        idd = payload[:id]
        uvjet = Veze.sanitize_sql_for_conditions(["WHERE kodknjige = ?",idd])
        v = Veze.connection.select_all("DELETE FROM vezes " + uvjet);
        payload[:autoriID].each do |a|
          Veze.create(kodautora:a, kodknjige:idd)
        end

        if knjiga.save
          #sleep(1)
          #var1 = helpers.vratiSveKnjige1(1)
          var = {"value"=>1, "error"=>false, "errorCode"=>"KNJIGA JE MODIFICIRANA"}
        else 
          var = {"value"=>nil, "error"=>true, "errorCode"=>"Unos knjige nije uspio"}
        end
        #sleep(2)
      end
      render json: var
    end

    def manager2
        tip = params[:tip]
        if (tip === "RETURN_SKLADISTA_ADRESE") # query for single page application
          var1 = helpers.vratiPodatke()
          var = {"value"=>var1, "error"=>false, "errorCode"=>"no errora"}
        elsif (tip === "RETURN_SKLADISTA")
          var = Skladista.connection.select_all("SELECT skladiste FROM skladista");
          var1 = []
          var.each do |el|
            var1.push(el["skladiste"])
          end
          #var = var1
          var = {"value"=>var1, "error"=>false, "errorCode"=>"no error"}
        elsif (tip === "RETURN_ADRESE")
          skl = Adrese.sanitize_sql_like(params[:payload]["skladiste"])
          #var = {"skladiste"=>skl}
         
         
          var = Adrese.connection.select_all("SELECT adresa FROM adrese INNER JOIN skladista ON skladista.id = kodskladista WHERE skladiste = '" + skl + "'")
          var1 = []
          var.each do |el|
            var1.push(el["adresa"])
          end
          #var = var1
          var = {"value"=>var1, "error"=>false, "errorCode"=>"no error"}
        elsif (tip === "ADD_SKLADISTE")
          skl = Skladista.sanitize_sql_like(params[:payload]["novoSkladiste"])
          var = Skladista.connection.select_all("SELECT skladiste FROM skladista WHERE skladiste = '" + skl + "'")
          if (var.length == 0)
            s = Skladista.new(skladiste:skl)
            if s.valid?
              s.save
              var2 = helpers.vratiPodatke()
              var = {"value"=>var2, "error"=>false, "errorCode"=>"Uneseno je novo skladiste"}
            else 
              var = {"value"=>nil, "error"=>true, "errorCode"=>"Unos skladista u bazu podataka nije uspio."}
            end
          else # skladiste vec postoji
            var = {"value"=>nil, "error"=>true, "errorCode"=>"Vec imas navedeno skladiste"}
          end
        elsif (tip === "REMOVE_SKLADISTE")
          skl = Skladista.sanitize_sql_like(params[:payload]["obrisiSkladiste"])
          var = Skladista.connection.select_all("SELECT adrese.adresa FROM adrese INNER JOIN skladista ON skladista.id = adrese.kodskladista WHERE skladista.skladiste = '" + skl + "'")
          if (var.length == 0)
            var = Skladista.destroy_by("skladiste":skl)
            if (var.length > 0)
              var2 = helpers.vratiPodatke()
              var = {"value"=>var2, "error"=>false, "errorCode"=>"Zadano skladiste si OBRISAO."}
            else
              var = {"value"=>nil, "error"=>true, "errorCode"=>"Zadano skladiste nije moglo biti obrisano."}
            end 
          else
            var = {"value"=>nil, "error"=>true, "errorCode"=>"Zadano skladiste ima pridruzene adrese."}
          end
        elsif (tip === "ADD_ADRESU")
          skl = Skladista.sanitize_sql_like(params[:payload]["skladiste"])
          adr = Skladista.sanitize_sql_like(params[:payload]["novaAdresa"])
          skla = Skladista.find_by(skladiste: skl)
          if (!skla.nil?)
            id = skla.id
            swi = Adrese.connection.select_all(Adrese.sanitize_sql_for_conditions(["SELECT * FROM adrese WHERE kodskladista = ? AND adresa = ?", id,adr])).first.nil?
            if (!swi)
              var = {"value"=>nil, "error"=>true, "errorCode"=>"Vec imas adresu sa tim imenom u odabranom skladistu."}
            else 
              s = Adrese.new
              s.kodskladista = id
              s.adresa = adr
              s.save

              var2 = helpers.vratiPodatke()
              var = {"value"=>var2, "error"=>false, "errorCode"=>nil}
            end
          else
            var = {"value"=>nil, "error"=>true, "errorCode"=>"GRESKA! Zadano skladiste nije pronadeno."}
          end
        elsif (tip === "REMOVE_ADRESU")
          skl = Skladista.sanitize_sql_like(params[:payload]["skladiste"])
          adr = Skladista.sanitize_sql_like(params[:payload]["obrisiAdresu"])

          adrese = Adrese.connection.select_all("SELECT veze1.kodknjige FROM adrese INNER JOIN veze1 ON veze1.kodadrese = adrese.id WHERE adrese.adresa = '" + adr + "'")
          if adrese.length == 0
            Adrese.destroy_by(adresa: adr)
            
            var2 = helpers.vratiPodatke()
            var = {"value"=>var2, "error"=>false, "errorCode"=>nil}
          else 
            var = {"value"=>nil, "error"=>true, "errorCode"=>"Adresa NIJE obrisana! Na njoj postoje artikli. Prvo njih izbrisi."}
          end
        else
          #var = nil
          var = {"value"=>nil, "error"=>true, "errorCode"=>"You requested action of unknown type"}
        end
        #var = {"ides"=>1, "ide"=>2}
        #sleep(1)
        render json: var
        #render plain: "#{params} \n\nid: #{params[:id]} \nuser: #{params[:user]}"
    end
end
