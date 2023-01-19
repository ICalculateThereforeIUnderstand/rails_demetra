Rails.application.routes.draw do
  #use_doorkeeper
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  post "/signup1", to: "api#signup"

  #devise_for :users
  devise_for :users, skip: [:sessions ], controllers: { sessions: 'users/sessions', registrations: "users/registrations" } 
  as :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    #get 'sign_up', to: 'devise/registrations#new', as: :new_user_registration
    post 'sign_in', to: 'devise/sessions#create', as: :user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
  devise_scope :user do
    get 'sign_up', to: 'devise/registrations#new'
  end
  #get 'bibliotekes/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  #get '/veze', to: 'vezes#index'
  #get '/biblioteke', to: 'bibliotekes#index'
  #get '/autori', to: 'autoris#index'
  get '/detalji', to: 'knjiges#detalji'
  #get '/pok', to: 'knjiges#pok'
  #get '/izdvajamo', to: 'odabraneknjiges#index'
  root 'odabraneknjiges#index'
  #get '/knjige', to: 'knjiges#index'
  get '/onama', to: 'static_pages#onama'
  get '/kontakt', to: 'static_pages#kontakt'

  #get '/pokus1', to: 'static_pages#pokus1'
  #get '/pokus2', to: 'static_pages#pokus2'

  #post '/pokus', to: 'knjiges#pokus1'
  get '/knjige', to: 'knjiges#pokus'

  get '/manager2', to: 'managers#manager2'
  get '/manager2/dodaj_skladiste', to: 'managers#dodaj_skladiste'
  get '/manager2/dodaj_adresu', to: 'managers#dodaj_adresu'
  get '/manager2/oduzmi_skladiste', to: 'managers#oduzmi_skladiste'
  get '/manager2/oduzmi_adresu', to: 'managers#oduzmi_adresu'
  post '/modificiraj_knjigu', to: 'managers#modificiraj_knjigu'
  #get '/modificiraj_knjigu1', to: 'managers#modificiraj_knjigu_pokus'
  get '/manager1', to: 'managers#manager1'
  post '/nova_knjiga', to: 'managers#nova_knjiga'
  get '/manager1_help', to: 'managers#manager1_help'
  get '/nova_knjiga_help', to: 'managers#nova_knjiga_help'
  get '/modificiraj_knjigu_help', to: 'managers#modificiraj_knjigu_help'
  get '/manager2_help', to: 'managers#manager2_help'

  get '/api/izdvajamo', to: 'api#izdvajamoApi'
  get '/api/sveknjige', to: 'api#sve_knjigeApi'
  get '/api/sveknjige1', to: 'api#sve_knjigeApi1'
  post '/api/sveknjige1', to: 'api#sve_knjigeApi1'
  get '/api/slika/:id/:ime', to: 'api#slika'
  #get '/api/slika/:id', to: 'api#slika'
  post '/api/manager2', to: 'api#manager2'
  post '/api/modificiraj_knjigu', to: 'api#modificiraj_knjiguApi'
  get '/api/svi_autori_biblioteke_skladista_adrese', to: 'api#sviAutoriBibliotekeSkladistaAdrese'

  get '/logirani', to: 'managers#logirani_user'
  get '/welcome', to: 'managers#welcome'
end
