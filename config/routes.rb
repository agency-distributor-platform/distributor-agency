Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/register", to: "authentication#register" #done
  get "/login", to: "authentication#login" #done
  patch "/agency/:agency_id/edit", to: "agency#edit" #done
  put "/agency/:agency_id/vehicles", to: "agency#bulk_upload_vehicle_details" #TO-DO
  put "/agency/:agency_id/vehicle", to: "agency#create_or_edit_vehicle_details" #testing -> check if distributor is linked to agency
  patch "/sell_vehicle", to: "item#sell_vehicle" #done
  get "/agency/:agency_id/sold_items", to: "agency#get_sold_items" #done
  get "/distributor/:distributor_id/sold_items", to: "distributor#get_sold_items" #done
  get "/agency/:agency_id/distributors", to: "agency#get_distributors" #done
  get "/agency/:agency_id/distributors/:distributor_id", to: "agency#get_distributor" #done
  patch "/agency/:agency_id/distributors_linking", to: "agency#distributors_linking" #done
  get "/agency/:agency_id/buyers", to: "agency#get_buyers" #done
  get "/agency/:agency_id/buyers/:buyer_id", to: "agency#get_buyer" #done
  get "/agency/:agency_id/vehicles", to: "agency#get_vehicles" #done
  get "/agency/:agency_id/vehicles/:vehicle_id", to: "agency#get_vehicle_details" #done
  patch "/distributor/:distributor_id/edit_distributor", to: "distributor#edit_details" #TO-DO
  get "/distributor/:distributor_id/buyers", to: "distributor#get_buyers" #done
  get "/distributor/:distributor_id/buyers/:buyer_id", to: "distributor#get_buyer" #done
  get "/distributor/:distributor_id/vehicles", to: "distributor#get_vehicles" #done
  get "/distributor/:distributor_id/vehicles/:vehicle_id", to: "distributor#get_vehicle_details" #done
  put "/buyer/:buyer_id", to: "buyer#edit_details" #TO-DO
end

# DEALER

# Login

# Logout

# Registration

# Edit-Dealer


# ————————————————————————————————————————————————————————

# USER

# Login

# Logout

# Registration

# GetAllVehicles (selling-price is visible)


# ————————————————————————————————————————————————————————
