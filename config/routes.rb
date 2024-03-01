Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/register", to: "authentication#register" #done
  get "/login", to: "authentication#login" #done
  patch "/agency/:agency_id/edit", to: "agency#edit" #done
  put "/agency/:agency_id/vehicles", to: "agency#bulk_upload_vehicle_details" #TO-DO
  put "/agency/:agency_id/vehicle", to: "agency#create_or_edit_vehicle_details" #done
  patch "/sell_vehicle", to: "item#sell_vehicle" #done
  get "/agency/:agency_id/sold_items", to: "agency#get_sold_items" #done
  get "/distributor/:distributor_id/sold_items", to: "distributor#get_sold_items" #done
  get "/agency/:agency_id/distributors", to: "agency#get_distributors" #Testing
  get "/agency/:agency_id/distributors/:distributor_id", to: "agency#get_distributor" #Testing
  patch "/agency/:agency_id/distributors_linking", to: "agency#distributors_linking" #Testing
  get "/agency/:agency_id/buyers", to: "agency#get_buyers" #Testing
  get "/agency/:agency_id/buyer/:buyer_id", to: "agency#get_buyer" #Testing
  get "/agency/:agency_id/vehicles", to: "agency#get_vehicles" #TO-DO
  get "/agency/:agency_id/vehicles/:vehicle_id", to: "agency#get_vehicle_details" #TO-DO
end

# DEALER

# Login

# Logout

# Registration

# Edit-Dealer

# ———————

# Get-All-Vehicles (default - all; possible values - sold , available , unavailable, deal-in-progress) (Selling-price is visible)



# ———————

# Get-Buyer

# Get-buyer-byId


# ————————————————————————————————————————————————————————

# USER

# Login

# Logout

# Registration

# GetAllVehicles (selling-price is visible)


# ————————————————————————————————————————————————————————

# BUYER (by agency or distributors if agency/distributors is applicable)

# Edit buyer details
