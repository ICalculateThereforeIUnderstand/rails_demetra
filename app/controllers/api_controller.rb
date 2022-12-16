class ApiController < ApplicationController
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
        var = Knjige.connection.select_all("SELECT id, naslov, godina, cijena, brojstranica, isbn, biblioteka_id, slika FROM knjiges;");
        autori = Knjige.connection.select_all("SELECT kodknjige, autor FROM vezes INNER JOIN autoris ON autoris.id = kodautora;");
        biblioteke = Biblioteke.connection.select_all("SELECT * FROM bibliotekes");
        for el in var
            if (!el["slika"].nil?)
                el["slika"] = 1; #Base64.encode64(el["slika"])
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
        sleep(4)
        render json: var
    end

    def slika
        id = Knjige.sanitize_sql_like(params[:id])
        var = Knjige.connection.select_all("SELECT slika, id, naslov, godina, cijena, brojstranica FROM knjiges WHERE id = " + id);    
        #render json: var
        var1 = var[0]["slika"]
        send_data(var1, :filename => "slika.jpg", :type=>"image/jpg")
    end

    def manager2
        tip = params[:tip]
        if (tip === "RETURN_SKLADISTA")
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
              var = Skladista.connection.select_all("SELECT skladiste FROM skladista");
              var1 = []
              var.each do |el|
                var1.push(el["skladiste"])
              end
              var = {"value"=>var1, "error"=>false, "errorCode"=>"Uneseno je novo skladiste"}
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
              var1 = Skladista.connection.select_all("SELECT skladiste FROM skladista");
              var2 = []
              var1.each do |el|
                var2.push(el["skladiste"])
              end
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

              var = Adrese.connection.select_all("SELECT adresa FROM adrese INNER JOIN skladista ON skladista.id = kodskladista WHERE skladiste = '" + skl + "'")
              var1 = []
              var.each do |el|
                var1.push(el["adresa"])
              end

              var = {"value"=>var1, "error"=>false, "errorCode"=>nil}
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
            
            var = Adrese.connection.select_all("SELECT adresa FROM adrese INNER JOIN skladista ON skladista.id = kodskladista WHERE skladiste = '" + skl + "'")
            var1 = []
            var.each do |el|
              var1.push(el["adresa"])
            end
            var = {"value"=>var1, "error"=>false, "errorCode"=>nil}
          else 
            var = {"value"=>nil, "error"=>true, "errorCode"=>"Adresa NIJE obrisana! Na njoj postoje artikli. Prvo njih izbrisi."}
          end
        else
          #var = nil
          var = {"value"=>nil, "error"=>true, "errorCode"=>"You requested action of unknown type"}
        end
        #var = {"ides"=>1, "ide"=>2}
        sleep(1)
        render json: var
        #render plain: "#{params} \n\nid: #{params[:id]} \nuser: #{params[:user]}"
    end
end
