// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//import "@hotwired/turbo-rails"

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false


import "controllers"


class Header {
    constructor() {
        this.gumb = document.querySelector("#gumb-header");
        this.visina = 200;
        this.collapsMenu = document.querySelector("#collapsing-menu-header");
        if (this.collapsMenu === null) {
            this.collapsMenu = document.querySelector("#collapsing-menu-header1");
            if (this.collapsMenu !== null) {
              this.visina = this.collapsMenu.children.length * 50 + 10;
            } else {
              this.visina = 160;
            }
            console.log("visina je postavljena na " + this.visina);
        }
        this.toggle = false;

        this.gumb.addEventListener("click", (e)=>{this.kliknuo(e)});
    }

    kliknuo(e) {
        if (this.toggle) {
            this.toggle = false;
            this.dodajStilove(this.collapsMenu, {height:"0px"});
        } else {
            this.toggle = true;
            this.dodajStilove(this.collapsMenu, {height:this.visina+"px"});
        }
    }

    dodajStilove(el, stilovi) {
        for (let key in stilovi) {
            el.style[key] = stilovi[key];
        }
    }
}

class Gumbi {
    constructor() {
        this.gumbi = document.querySelectorAll(".knjige-div4 > .knjige-button");
        //console.log("guMBI: " + this.gumbi.length);
      if (this.gumbi.length !== 0) {  
        this.hiddenField = document.querySelector("#knjige-hidden-field");
        this.hiddenField1 = document.querySelector("#knjige-hidden-field1");
        this.forma = document.querySelector("#knjige-forma");
        this.gumbForme = document.querySelector("#knjige-gumb");
        //this.searchGumb = document.querySelector("#knjige-gumb");
        
        for (let i = 0; i < this.gumbi.length; i++) {
            this.gumbi[i].addEventListener("click", (e)=>{this.kliknuo(e)});
        }
        this.postaviAktivniGumb();

        this.gumbForme.addEventListener("click", (e)=>{this.kliknuo1(e)});
      }  
    }

    postaviAktivniGumb() {
        let sw = false;
        //console.log("1Postavljam na " + this.hiddenField.value);
        for (let i = 0; i < this.gumbi.length; i++) {
            if (this.gumbi[i].id === "bibID-"+this.hiddenField.value) {
                //this.gumbi[i].style.backgroundColor = "yellow";
                this.gumbi[i].classList.remove("knjige-neaktivan");
                this.gumbi[i].classList.add("knjige-aktivan");
                sw = true;
                //break;
            } else {
                this.gumbi[i].classList.remove("knjige-aktivan");
                this.gumbi[i].classList.add("knjige-neaktivan");
            }
        }
        if (!sw) {
            //this.gumbi[this.gumbi.length-1].style.backgroundColor = "yellow";
            this.gumbi[this.gumbi.length-1].classList.remove("knjige-neaktivan");
            this.gumbi[this.gumbi.length-1].classList.add("knjige-aktivan");
        }
    }

    kliknuo(e) {
        let oznaka = e.target.id;
        console.log("kliknuo si na gumb " + oznaka);
        console.log("trenutni hidden field je " + this.hiddenField.value);
        this.hiddenField.value = oznaka.split("-")[1];
        this.hiddenField1.value = 1;
        console.log("novi hidden field je " + this.hiddenField.value);
        this.postaviAktivniGumb();
        this.forma.submit();
    }

    kliknuo1(e) {
        e.preventDefault();
        this.hiddenField1.value = 1;
        this.forma.submit();
    }
}

class Pagination {
    constructor() {
        this.forma = document.querySelector("#knjige-forma");
        this.hiddenField = document.querySelector("#knjige-hidden-field1");
        //console.log("je li null " + (this.hiddenField !== null));
      if (this.hiddenField !== null) {  
        this.aktivnaStranica = parseInt(this.hiddenField.value);
        this.brojStranica = parseInt(document.querySelector("#knjige-hidden-field2").value);
        this.el = document.querySelector("div.pagination");
        this.ul = document.createElement("ul");
        this.ul.classList.add("pagination");
        this.el.appendChild(this.ul);

        if (this.brojStranica > 2) {
            this.prev = document.createElement("li");
            this.prev.classList.add("prev", "previous_page");
            //this.prev.innerHTML = "prethodna";
            let pel = document.createElement("p");
            pel.innerHTML = "prethodna";
            pel.classList.add("knjige-pagination-velikiekran");
            this.prev.appendChild(pel);
            pel = document.createElement("p");
            pel.innerHTML = "<<";
            pel.classList.add("knjige-pagination-maliekran");
            this.prev.appendChild(pel);

            this.ul.appendChild(this.prev);
            this.prev.addEventListener("click", (e)=>{this.kliknuo(e)});
        }
        this.polje = [];
        let sw1 = false;
        let sw2 = false;
        for (let i = 0; i < this.brojStranica; i++) {
          if (i < 2 || i > this.brojStranica-3 || (this.hiddenField.value-1-3 < i && this.hiddenField.value-1+3 > i) ) { 
            let el = document.createElement("li");
            el.innerHTML = i+1;
            this.polje.push(el);
            this.ul.appendChild(el);
            if (this.hiddenField.value == i+1) {
                el.classList.add("active");
                this.aktivnaStranica = i+1;
            }
            el.addEventListener("click", (e)=>{this.kliknuo(e)});
          } else {
            this.polje.push("...");
            if (!sw1 && this.hiddenField.value-1-2 > i) {
                sw1 = true;
                let el = document.createElement("li");
                el.innerHTML = "...";
                this.polje.push(el);
                this.ul.appendChild(el);
            }
            if (!sw2 && this.hiddenField.value-1+2 < i) {
                sw2 = true;
                let el = document.createElement("li");
                el.innerHTML = "...";
                this.polje.push(el);
                this.ul.appendChild(el);
            }

          }
        }

        if (this.brojStranica > 2) {
            this.next = document.createElement("li");
            this.next.classList.add("next", "next_page");
            //this.next.innerHTML = "sljedeca"
            let pel = document.createElement("p");
            pel.innerHTML = "sljedeca";
            pel.classList.add("knjige-pagination-velikiekran");
            this.next.appendChild(pel);
            pel = document.createElement("p");
            pel.innerHTML = ">>";
            pel.classList.add("knjige-pagination-maliekran");
            this.next.appendChild(pel);

            this.ul.appendChild(this.next);
            this.next.addEventListener("click", (e)=>{this.kliknuo(e)});
        }
      }  
    }

    kliknuo(e) {
        
        if (e.currentTarget.classList.contains("prev")) {
            console.log("kliknuo na prev " + this.aktivnaStranica);
            this.aktivnaStranica = this.aktivnaStranica - 1;
            if (this.aktivnaStranica == 0) {
                this.aktivnaStranica = 1;
            } else {
                console.log("nova stranica na " + this.aktivnaStranica);
                this.polje[this.aktivnaStranica].classList.remove("active");    
                this.polje[this.aktivnaStranica-1].classList.add("active");
                this.hiddenField.value = this.aktivnaStranica;
                this.forma.submit();
            }
        } else if (e.currentTarget.classList.contains("next")) {
            this.aktivnaStranica += 1;
            if (this.aktivnaStranica > this.brojStranica) {
                this.aktivnaStranica -= 1;
            } else {
                this.polje[this.aktivnaStranica-2].classList.remove("active");    
                this.polje[this.aktivnaStranica-1].classList.add("active");
                this.hiddenField.value = this.aktivnaStranica;
                this.forma.submit();
            }
        } else {
            let vri = parseInt(e.target.innerHTML);
            if (vri !== this.aktivnaStranica) {
                if (false) {
                this.polje[this.aktivnaStranica-1].classList.remove("active");
                this.aktivnaStranica = vri;
                this.polje[this.aktivnaStranica-1].classList.add("active");
                this.hiddenField.value = this.aktivnaStranica;
                }
                
                this.hiddenField.value = vri;
                this.forma.submit();
            }
        }
    }
}

class Manager2 {
    constructor() {
        this.odaberi1Gumb = document.querySelector("#manager2-gumb1");

        if (document.querySelector("main#manager2-main") !== null && this.odaberi1Gumb !== null) {
            this.odaberi1Gumb.addEventListener("click", ()=>{this.submit1()});
            this.forma1 = document.querySelector("#manager2-forma1");

            this.odaberi2Gumb = document.querySelector("#manager2-gumb2");
            this.odaberi2Gumb.addEventListener("click", ()=>{this.submit2()});

            this.odaberi3Gumb = document.querySelector("#manager2-gumb3");
            this.forma2 = document.querySelector("#manager2-forma2");
            this.odaberi3Gumb.addEventListener("click", ()=>{this.submit3()});

            this.forma3 = document.querySelector("#manager2-forma3");
            this.odaberi4Gumb = document.querySelector("#manager2-gumb5");
            this.odaberi4Gumb.addEventListener("click", ()=>{this.submit4()});

            this.odaberi6Gumb = document.querySelector("#manager2-gumb6");
            this.forma4 = document.querySelector("#manager2-forma4");
            this.odaberi6Gumb.addEventListener("click", ()=>{this.submit5()});

            postaviFlash("alert");
        }
    }

    submit1() {
        this.forma1.submit();
    }

    submit2() {
        this.forma1.action = "/manager2/oduzmi_skladiste";
        this.forma1.submit();
    }

    submit3() {
        this.forma2.submit();
    }

    submit4() {
        this.forma3.submit();
    }

    submit5() {
        this.forma4.submit();
    }
}

function postaviFlash(klasa) {
    // flash 
    let flashDjeca = document.querySelectorAll("."+klasa);
    for (let i = 0; i < flashDjeca.length; i++) {
        let el = flashDjeca[i].children[1];
        el.linkEl = flashDjeca[i];
        el.addEventListener("click", (e)=>{flashKlik(e)});  // zatvaramo kliknuti flash
        setTimeout(zatvoriFlash, 5000 + i*1000, flashDjeca[i]);
    }

    function zatvoriFlash(el) {
        console.log("Upravo ZATVARAM. " + Math.random());
        el.style.display = "none";
    }

    function flashKlik(e) {
        e.currentTarget.linkEl.style.display = "none";
        console.log("zatvaramo " + Math.random());
    }
}

class ModificirajKnjigu {
    constructor(conf=null, menu=null) {
        this.tablica = document.querySelector("#opisknjige1-tablica tbody");
        if (this.tablica !== null) {
            this.conf = conf;
            this.menu = menu;
            let el = document.querySelector("#modificirajknjigu-selekt");
            el.addEventListener("click", (e)=>{this.klik1(e)});
            let el1 = document.querySelector("#biblioteka-polje");
            el.linkEl = el1;   // linkamo DOM element na drugi DOM element, radi efikasnosti

            this.tablicaAutora = document.querySelector("#modificirajknjigu-selekt1");
            this.tablicaAutora.addEventListener("click", (e)=>{this.klik2(e)});
            el1 = document.querySelector("#autor-polje");
            this.tablicaAutora.linkEl = el1;   // linkamo DOM element na drugi DOM element, radi efikasnosti

            el = document.querySelector("#modificirajknjigu-selekt4");
            if (el !== null) {
                el.addEventListener("click", (e)=>{this.klikSelekt2(e)});
            }

            let djeca = this.tablica.children;
            console.log("broj djece je " + djeca.length);
            for (let i = 1; i < djeca.length; i++) {
                if (i == 10)  continue;
                if (i == 4 || i == 2 || i == 8 || i == 9) {
                    djeca[i].addEventListener("click", (e)=>{this.toggleClick1(e)});
                    if (i == 7) {
                        let el = (djeca[i].children)[2].children[1];   
                        el.addEventListener("click", (e)=>{e.stopPropagation()});
                        console.log("OZNACILI SMO " + el.id);
                    } 
                    continue; // slucaj sa menijem sa bibliotekama i autorima i postavljanjem slike
                }
                djeca[i].addEventListener("click", (e)=>{this.toggleClick(e)});
                
                let el = (djeca[i].children)[2].firstChild;
                el.addEventListener("click", (e)=>{this.klik(e)});
                let idd = el.id.split("-")[0];
                let el1 = document.querySelector("#"+idd+"-polje");
                el.linkEl = el1;  // linkamo DOM element na drugi DOM element, radi efikasnosti
                el.addEventListener("change", (e)=>{this.changeInputPolje(e)});
                console.log("dodao si event na " + djeca[i].classList);

            }
            this.forma = document.querySelector("#modificirajknjigu-forma");
            let gumb = document.querySelector("#opisknjige-gumb");
            if (gumb !== null) {  // modificiraj_knjigu
                gumb.addEventListener("click", ()=>{this.submitaj()});
            } 
            
            gumb = document.querySelector("#opisknjige-gumb-nova");
            if (gumb !== null) {  // nova_knjiga
                gumb.addEventListener("click", ()=>{this.submitajNovu()});
            } 

            gumb = document.querySelector("#opisknjige-gumb2");
            if (gumb !== null) {  // nova_knjiga
                gumb.addEventListener("click", ()=>{this.brisiKnjigu()});
            } 

            document.querySelector("#modificirajAutora-input").addEventListener("click", (e)=>{this.klik(e)});
            //this.ff = document.querySelector("#modificirajknjigu-forma1");
            document.querySelector("#modificirajAutora-gumb").addEventListener("click", (e)=>{this.klik(e); this.klikAutor(1)});
            document.querySelector("#modificirajAutora-gumb1").addEventListener("click", (e)=>{this.klik(e); this.klikAutor(2)});

            document.querySelector("#modificirajAutora-gumb2").addEventListener("click", (e)=>{this.bezSlikeKlik(e)});

            // kod za verifikaciju uploada slike
            this.fileInput = document.querySelector("#file-input");
            this.fileInput.addEventListener("change", (e)=>{this.fileVerify(e)});

            // flash 
            postaviFlash("alert");
            if (false) {
            let flashDjeca = document.querySelectorAll(".alert");
            for (let i = 0; i < flashDjeca.length; i++) {
                let el = flashDjeca[i].children[1];
                el.linkEl = flashDjeca[i];
                el.addEventListener("click", (e)=>{this.flashKlik(e)});  // zatvaramo kliknuti flash
                setTimeout(this.zatvoriFlash, 5000 + i*1000, flashDjeca[i]);
            }
            }

            el = document.querySelector("#modificirajknjigu-gumb");
            if (el !== null) {
                el.addEventListener("click", (e)=>{this.klikOtvoriMenu(e)});
            }

            el = document.querySelector("#modificirajknjigu-menu-gumb3");
            if (el !== null) {
                el.addEventListener("click", (e)=>{this.novaKolicina(e)});
            }

            el = document.querySelector("#modificirajknjigu-menu-gumb5");
            if (el !== null) {
                el.addEventListener("click", (e)=>{this.obrisiAdresu(e)});
            }

            el = document.querySelector("#modificirajknjigu-selekt3");
            if (el !== null) {
                el.addEventListener("change", ()=>{this.changeSelekt()});
            }

            el = document.querySelector("#modificirajknjigu-menu-gumb4");
            if (el !== null) {
                el.addEventListener("click", ()=>{this.dodajAdresu()});
            }

            // modifikacija liste odabranih knjiga pritiskom na gumb YES/NO
            el = document.querySelector("#modificirajknjigu-gumb1");
            if (el !== null) {
                this.odabranaEl = document.querySelector("#modificirajknjigu-odabrana");
                el.addEventListener("click", (e)=>{this.toggleOdabrane(e)});
            } else {
                console.log("CINI se da nisi pronasao gumb...");
                this.odabranaEl = null;
            }

        }
    }

    toggleOdabrane(e) {
        if (e.currentTarget.innerHTML.trim() == "YES") {
            this.odabranaEl.value = "NO";
            e.currentTarget.innerHTML = "NO";
        } else {
            this.odabranaEl.value = "YES";
            e.currentTarget.innerHTML = "YES";
        }
    }

    dodajAdresu() {
        console.log("Upravo pridruzujem adresu. " + Math.random());
        document.querySelector("#modificirajAutora-hidden").value = "dodaj adresu";
        this.conf.postaviPoruku("Pridružujete knjizi novu skladišnu adresu. Da li ste sigurni?");
        this.conf.confirm(()=>{this.forma.submit()});
    }

    changeSelekt() {
        console.log("Upravo si kliknuo select prozor od skladista. " + Math.random());
        document.querySelector("#modificirajAutora-hidden").value = "odabrano skladiste";
        this.forma.submit();
    }

    novaKolicina(e) {
        document.querySelector("#modificirajAutora-hidden").value = "modificiraj kolicinu";
        this.conf.postaviPoruku("Mjenjate količinu ove knjige na odabranoj adresi. Da li ste sigurni?");
        this.conf.confirm(()=>{this.forma.submit()});
    }

    obrisiAdresu(e) {
        document.querySelector("#modificirajAutora-hidden").value = "obrisi adresu";
        this.conf.postaviPoruku("Upravo ćete obrisati adresu. Da li ste sigurni?");
        this.conf.confirm(()=>{this.forma.submit()});
    }

    klikOtvoriMenu(e) {
        e.stopPropagation();
        e.preventDefault();
        //this.menu.postaviPoruku("Mijenjate podatke... Da li ste sigurni?");
        this.menu.confirm(()=>{this.forma.submit()});
    }

    brisiKnjigu() {
        //console.log("Kliknuo si za brisanje knjige." + Math.random());
        document.querySelector("#modificirajAutora-hidden").value = "brisi knjigu";
        this.conf.postaviPoruku("BRIŠETE ovu knjigu. Da li ste sigurni?");
        this.conf.confirm(()=>{this.forma.submit()});
    }

    zatvoriFlash(el) {
        console.log("Upravo ZATVARAM. " + Math.random());
        el.style.display = "none";
    }

    flashKlik(e) {
        e.currentTarget.linkEl.style.display = "none";
        console.log("zatvaramo " + Math.random());
    }

    klikSelekt2(e) {
        e.stopPropagation();
        e.preventDefault();
        console.log("Kliknuo na Selekt " + Math.random());
    }

    fileVerify(e) {
        console.log("file je velicine " + e.currentTarget.files[0].size);
        if (e.currentTarget.files[0].size > 65300) {
            e.currentTarget.value = "";
            alert("File je veci od 64KB");
        }
    }

    bezSlikeKlik(e) {
        console.log("Ponistavamo sliku");
        document.querySelector("#file-slikaAkcija").value = "no"
        this.forma.submit();
    }

    klikAutor(opcija) {
        if (opcija === 1) {
            document.querySelector("#modificirajAutora-hidden").value = "dodaj";
            this.conf.postaviPoruku("Dodajete navedenog autora. Da li ste sigurni?");
        } else {
            document.querySelector("#modificirajAutora-hidden").value = "oduzmi";
            this.conf.postaviPoruku("Brišete navedenog autora. Da li ste sigurni?");
        }
        console.log("sada bi trebao submitati autora...");
        this.conf.confirm(()=>{this.forma.submit()});
        //this.forma.submit();
    }

    submitaj() {
        console.log("submitam");
        this.conf.postaviPoruku("Mijenjate podatke knjige. Da li ste sigurni?");
        this.conf.confirm(()=>{this.forma.submit()});
        //this.forma.submit();
    }

    submitajNovu() {
        console.log("submitam");
        this.conf.postaviPoruku("Unosite novu knjigu. Da li ste sigurni?");
        this.conf.confirm(()=>{this.forma.submit()});
        //this.forma.submit();
    }

    changeInputPolje(e) {
        let tekst = e.target.value;
        console.log("tekst je " + tekst);
        e.target.linkEl.innerHTML = tekst;
    }

    toggleClick(e) {
        let djeca = e.currentTarget.children;
        let stanje = window.getComputedStyle(djeca[1]).getPropertyValue("display");
        //console.log("Stanje retka je " + stanje + "  " + Math.random());
        if (stanje === "table-cell") {
            djeca[1].style.display = "none";
            djeca[2].style.display = "table-cell";
            djeca[2].firstChild.focus();
        } else {
            djeca[1].style.display = "table-cell";
            djeca[2].style.display = "none";
        }
        // zatvaramo ostale retke
        let djecaTablice = this.tablica.children;
        for (let i = 0; i < djecaTablice.length; i++) {
            if (djecaTablice[i] === e.currentTarget) {
                console.log("naisao na kliknuti redak");
            } else {
                let djeca1 = djecaTablice[i].children;
                stanje = window.getComputedStyle(djeca1[1]).getPropertyValue("display");
                if (stanje === "table-cell") {

                } else {
                    djeca1[1].style.display = "table-cell";
                    djeca1[2].style.display = "none";
                }
            }
        }

    }

    toggleClick1(e) {
        let djeca = e.currentTarget.children;
        let stanje = window.getComputedStyle(djeca[1]).getPropertyValue("display");
        let toggleSw = true;
        //console.log("Stanje retka je " + stanje + "  " + Math.random());
        if (stanje === "table-cell") {
            djeca[1].style.display = "none";
            djeca[2].style.display = "table-cell";
            //djeca[2].firstChild.focus();
            toggleSw = true;
        } else {
            djeca[1].style.display = "table-cell";
            djeca[2].style.display = "none";
            toggleSw = false;
        }
        // zatvaramo ostale retke
        let djecaTablice = this.tablica.children;
        for (let i = 0; i < djecaTablice.length; i++) {
            if (djecaTablice[i] === e.currentTarget) {
                console.log("naisao na kliknuti redak");
            } else {
                let djeca1 = djecaTablice[i].children;
                stanje = window.getComputedStyle(djeca1[1]).getPropertyValue("display");
                if (stanje === "table-cell") {

                } else {
                    djeca1[1].style.display = "table-cell";
                    djeca1[2].style.display = "none";
                }
            }
        }

        if (!toggleSw && e.currentTarget.id == "modificiraj-knjigu-autor") {
            console.log("TOGGLAS autorov red.");
            let dijete = e.currentTarget.children[1];
            let djecaTablice = this.tablicaAutora.children;
            let ispis = "";
            let sw1 = true;
            if (djecaTablice[0].selected) {
                sw1 = false;
            } 
            for (let i = 1; i < djecaTablice.length; i++) {
                if (djecaTablice[i].selected) {
                    if (sw1) {
                        ispis += djecaTablice[i].value + "; ";
                    } else {
                        //djecaTablice[i].removeAttribute("selected");
                        djecaTablice[i].selected = false;
                    }
                }
            }
            
            dijete.innerHTML = ispis.substring(0, ispis.length - 2);;
        }

    }

    klik(e) {
       e.stopPropagation();
       e.preventDefault(); 
    }

    klik1(e) {
        e.stopPropagation();
        e.preventDefault(); 
        console.log("polje je " + e.target.value);
        e.currentTarget.linkEl.innerHTML = e.target.value;
    }
    
    klik2(e) {
        e.stopPropagation();
        e.preventDefault(); 
        console.log("polje je " + e.target.value);

        
        


        //e.currentTarget.linkEl.innerHTML = e.target.value;
    }
}

class Manager1 {  // klasa za manager1 stranicu
    constructor() {
        
        if (document.querySelector("main#manager1-main") !== null) {
            this.polja = document.querySelectorAll(".manager1-el");
            for (let i = 0; i < this.polja.length; i++) {
                this.polja[i].addEventListener("click", (e)=>{this.klik(e)});
            }
            this.input = document.querySelector("#manager1-hidden1");
            this.form = document.querySelector("#manager1-hidden");
            this.selekt = document.querySelector("#manager1-selekt");
            this.selekt.addEventListener("change", ()=>{this.changeSelekt()});
            this.forma = document.querySelector("#knjige-forma");
            this.novaKnjigaGumb = document.querySelector("#knjige-gumb1");
            this.novaKnjigaGumb.addEventListener("click", (e)=>{this.klikNovaKnjiga(e)});
            this.forma1 = document.querySelector("#manager1-hidden2");
            postaviFlash("alert");
        }
    }

    klikNovaKnjiga(e) {
        this.forma1.submit();    
    }

    changeSelekt() {
        this.forma.submit();
        //console.log("Upravo si okinuo submit " + Math.random());
    }

    klik(e) {
        //console.log("id kliknutog polja je " + e.currentTarget.id.split("-")[2]);
        this.input.value = e.currentTarget.id.split("-")[2];
        this.form.submit();
    }
}

class Confirmation {
    constructor(id="confirmation") {
		this.prozor = document.querySelector("#"+id);
        if (this.prozor !== null) {
		    this.gumb1 = document.querySelector("#"+id+"-gumb1");
		    this.gumb2 = document.querySelector("#"+id+"-gumb2");
		    this.poruka = document.querySelector("#"+id+"-el1 p");
		    this.exeFun = ()=>{console.log("nisi namjestio izvrsnu funkciju")};

		    if (this.gumb1 !== null)  this.gumb1.addEventListener("click", ()=>{this.submit1()});
		    if (this.gumb2 !== null)  this.gumb2.addEventListener("click", ()=>{this.submit2()});

		    this.showedSw = true;

            let el = document.querySelector("#modificirajknjigu-menu-krizic");
            if (el !== null) {
                el.addEventListener("click", (e)=>{this.zatvori(e)});
            } 
        }
	}

    zatvori(e) {
        this.showedSw = false;
		this.prozor.style.display = "none";
        console.log("trebao bi zatvoriti prozor. " + Math.random());
    }

	confirm(fun) {
		this.prozor.style.display = "flex";
		this.showedSw = true;

		this.exeFun = fun;
	}

	postaviPoruku(str) {
        this.poruka.innerHTML = str;
	}

	submit1() {
		console.log("zatvaram prozor");
		this.prozor.style.display = "none";
		this.showedSw = false;
	}

	submit2() {
		this.showedSw = false;
		this.prozor.style.display = "none";
		this.exeFun();
	}
}

//window.onload = function() {

let h, g, p, m2, c, menu, mk, m1, el;

document.addEventListener("turbo:load", function () {

setTimeout(()=>{
console.log("stranica je ucitana " + Math.random());
h = new Header();
g = new Gumbi();
p = new Pagination();

// manager
m2 = new Manager2();

c = new Confirmation();
menu = new Confirmation("modificirajknjigu-menu");
mk = new ModificirajKnjigu(c, menu);

m1 = new Manager1();

el = document.querySelector("#link-back");
if (el !== null) {
    el.addEventListener("click", (e)=>{e.preventDefault(); history.back(); console.log("ides natrag")});
}

if (document.querySelector("#izdvajamo-main")) {
  postaviFlash("alert");
}
if (document.querySelector("#login-main")) {
    postaviFlash("alert");
}
}, 250)

}); // turbo:load 

// pomocni devlopment kod

//document.addEventListener("keydown", (e) => {pritisakGumba(e)});

function pritisakGumba(ev) {
    //ev.preventDefault();
    if (ev.code === "KeyS") {
        console.log("sirina ekrana je " + window.innerWidth);
    }
}

//}