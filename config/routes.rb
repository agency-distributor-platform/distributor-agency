Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/register", to: "authentication#register" #done
  post "/login", to: "authentication#login" #done
  get "/agencies", to: "pre_login#list_agencies" #done
  get "/distributors", to: "pre_login#list_distributors" #done
  get "/search_agencies", to: "pre_login#search_agencies"
  get "/search_distributors", to: "pre_login#search_distributors"
  patch "/agency/:agency_id/edit", to: "agency#edit" #done
  post "/vehicle_model/create", to: "vehicle_model#create" #TO-DO
  patch "/vehicle_model/:id", to: "vehicle_model#edit" #TO-DO
  get "/vehicle_model/:id", to: "vehicle_model#show" #TO-DO
  get "/vehicle_models", to: "vehicle_model#list" #TO-DO
  delete "/vehicle_model/:id", to: "vehicle_model#delete" #TO-DO
  put "/agency/:agency_id/vehicles", to: "agency#bulk_upload_vehicle_details" #TO-DO
  put "/agency/:agency_id/vehicle", to: "agency#create_or_edit_vehicle_details" #done
  patch "/sell_vehicle", to: "item#sell_vehicle" #done
  get "/agency/:agency_id/sold_items", to: "agency#get_sold_items" #done
  get "/distributor/:distributor_id/sold_items", to: "distributor#get_sold_items" #done
  get "/agency/:agency_id/distributors", to: "agency#get_distributors" #done
  get "/agency/:agency_id/distributors/:distributor_id", to: "agency#get_distributor" #done
  patch "/distributor/:distributor_id/agency_linking", to: "distributor#agency_linking" #done -> Edit other way round
  get "/agency/:agency_id/buyers", to: "agency#get_buyers" #done
  get "/agency/:agency_id/buyers/:buyer_id", to: "agency#get_buyer" #done
  get "/agency/:agency_id/vehicles", to: "agency#get_vehicles" #done
  get "/agency/:agency_id/vehicles/:vehicle_id", to: "agency#get_vehicle_details" #done
  patch "/distributor/:distributor_id/edit", to: "distributor#edit" #done
  get "/distributor/:distributor_id/buyers", to: "distributor#get_buyers" #done
  get "/distributor/:distributor_id/buyers/:buyer_id", to: "distributor#get_buyer" #done
  get "/distributor/:distributor_id/vehicles", to: "distributor#get_vehicles" #done
  get "/distributor/:distributor_id/vehicles/:vehicle_id", to: "distributor#get_vehicle_details" #done
  patch "/buyer/:buyer_id/edit", to: "buyer#edit" #done

  #get agency own details ->
  #get all distributors ->
end

# Token based authentication of requests
# Set sessions on login, cleanup of session ids -> use cache
# Logout routes

# ————————————————————————————————————————————————————————

# USER

# Login

# Logout

# Registration

# GetAllVehicles (selling-price is visible)

# ————————————————————————————————————————————————————————
