class ApiController < ApplicationController
    def izdvajamoApi
        var = Knjige.connection.select_all("SELECT o.id, naslov, godina, cijena, brojstranica, isbn, biblioteka FROM odabraneknjiges as o INNER JOIN knjiges  ON knjiges.id = o.id_knjige INNER JOIN bibliotekes as b ON b.biblioteka_id = knjiges.biblioteka_id;").to_a();
        #sleep(1)
        render json: var
    end
end
