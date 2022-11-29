Rails.application.routes.draw do
  #get 'bibliotekes/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/veze', to: 'vezes#index'
  get '/biblioteke', to: 'bibliotekes#index'
  get '/autori', to: 'autoris#index'
  get '/knjige', to: 'knjiges#index'
  get '/detalji', to: 'knjiges#detalji'
  get '/pok', to: 'knjiges#pok'
  get '/izdvajamo', to: 'odabraneknjiges#index'

  get '/onama', to: 'static_pages#onama'

  get '/pokus1', to: 'static_pages#pokus1'
  get '/pokus2', to: 'static_pages#pokus2'

  #post '/pokus', to: 'knjiges#pokus1'
  get '/pokus', to: 'knjiges#pokus'

  get '/manager2', to: 'managers#manager2'
  get '/manager2/dodaj_skladiste', to: 'managers#dodaj_skladiste'
  get '/manager2/dodaj_adresu', to: 'managers#dodaj_adresu'
  get '/manager2/oduzmi_skladiste', to: 'managers#oduzmi_skladiste'
  get '/manager2/oduzmi_adresu', to: 'managers#oduzmi_adresu'
  post '/modificiraj_knjigu', to: 'managers#modificiraj_knjigu'
  get '/modificiraj_knjigu1', to: 'managers#modificiraj_knjigu_pokus'
  get '/manager1', to: 'managers#manager1'
end
