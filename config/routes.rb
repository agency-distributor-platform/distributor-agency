Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/register", to: "authentication#register" #done
  post "/login", to: "authentication#login" #done
  get "/agencies", to: "pre_login#list_agencies" #done
  get "/distributors", to: "pre_login#list_distributors" #done
  get "/search_agencies", to: "pre_login#search_agencies" #done
  get "/search_distributors", to: "pre_login#search_distributors" #done
  get "/search_salespersons", to: "pre_login#search_salespersons" #TO-DO
  patch "/agency/edit", to: "agency#edit" #done #user can only edit it's own agency

  post "/vehicle_model/create", to: "vehicle_model#create" #TO-DO
  patch "/vehicle_model/:id", to: "vehicle_model#edit" #TO-DO
  get "/vehicle_model/:id", to: "vehicle_model#show" #TO-DO
  get "/vehicle_models", to: "vehicle_model#list" #TO-DO
  delete "/vehicle_model/:id", to: "vehicle_model#delete" #TO-DO

  put "/agency/vehicles", to: "agency#bulk_upload_vehicle_details" #TO-DO
  put "/agency/vehicle", to: "agency#create_or_edit_vehicle_details" #TO-DO

  patch "/sell_vehicle", to: "item#sell_vehicle" #TO-DO #downpayment/partial sales also handled in this api #buyer information maybe created here
  patch "/book_vehicle", to: "item#book_vehicle" #TO-DO #buyer info to be inputted, create buyer maybe possible

  get "/agency/sold_items", to: "agency#get_sold_items" #TO-DO
  get "/distributor/sold_items", to: "distributor#get_sold_items" #TO-DO

  get "/agency/distributors", to: "agency#get_distributors" #TO-DO
  patch "/distributor/agency_linking", to: "distributor#agency_linking" #TO-DO -> Edit other way round

  get "/buyers", to: "buyer#get_buyers" #TO-DO
  get "/buyers/:buyer_id", to: "buyer#get_buyer" #TO-DO

  get "/vehicles", to: "vehicles#get_vehicles" #TO-DO
  get "/vehicles/:vehicle_id", to: "vehicles#get_vehicle_details" #TO-DO

  patch "/distributor/edit", to: "distributor#edit" #TO-DO

  patch "/buyer/:buyer_id/edit", to: "buyer#edit" #TO-DO
end

#TO-DO Logout routes
