Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/register", to:  "authentication#register"
  get "/login", to:  "authentication#login"
  put "/agency/:agency_id/edit", to:  "agency#edit"
  get "/agency/:agency_id/sold_items", to:  "agency#sold_items"
  get "/agency/:agency_id/dealers", to:  "agency#dealers"
  get "/agency/:agency_id/dealer/:dealer_id", to:  "agency#dealer"
  patch "/agency/:agency_id/dealer_linking", to:  "agency#dealer_linking"
  get "/agency/:agency_id/buyers", to:  "agency#buyers"
  get "/agency/:agency_id/buyer/:buyer_id", to:  "agency#buyer"
  get "/agency/:agency_id/vehicles", to:  "agency#vehicle_list"
  get "/agency/:agency_id/vehicles/:vehicle_id", to:  "agency#vehicle_details"
  patch "/agency/:agency_id/vehicles/:vehicle_id", to:  "agency#edit_vehicle_details"
  put "/agency/:agency_id/vehicles", to:  "agency#bulk_upload_vehicle_details"
end

# DEALER

# Login

# Logout

# Registration

# Edit-Dealer

# ———————

# Get-All-Vehicles (default - all; possible values - sold , available , unavailable, deal-in-progress) (Selling-price is visible)

# Sell-Vehicle-by-dealer

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

# BUYER (by agency or dealer if agency/dealer is applicable)

# Edit buyer details
