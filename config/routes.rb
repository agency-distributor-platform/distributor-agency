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

  post "/vehicle_model/create", to: "vehicle_model#create" #done
  patch "/vehicle_model/:id", to: "vehicle_model#edit" #done
  get "/vehicle_model/:id", to: "vehicle_model#show" #done
  get "/vehicle_models", to: "vehicle_model#list" #done
  delete "/vehicle_model/:id", to: "vehicle_model#delete" #done

  get "/agency/distributors", to: "agency#get_distributors" #done
  patch "/distributor/agency_linking", to: "distributor#agency_linking" #done

  patch "/distributor/edit", to: "distributor#edit" #done
  patch "/salesperson/edit", to: "salesperson#edit" #done

  get "/current_user_details", to: "user#current_user_details" #done
  get "/user/:user_id", to: "user#user_details" #done

  get "/statuses", to: "item#statuses" #done
  put "/vehicle", to: "vehicles#create_or_edit_vehicle_details" #done
  patch "/vehicle/:vehicle_id/assign_vehicle", to: "vehicles#assign_vehicle" #done
  get "/vehicles", to: "vehicles#get_vehicles" #done
  get "/vehicles/:vehicle_id", to: "vehicles#get_vehicle_details" #done

  put "/vehicles/:transaction_type", to: "vehicles#transact_vehicle" #done #downpayment/partial sales also handled in this api #buyer information maybe created here
  put "/distributor_share", to: "item#add_or_edit_distributor_share" #done
  put "/salesperson_share", to: "item#add_or_edit_salesperson_share" #done
  get "/vehicles/:vehicle_id/transactions", to: "vehicles#get_vehicle_transactions" #done
  patch "/edit_transaction/:transaction_id", to: "item#edit_transaction" #TO-DO #transaction record, as well as transaction details

  get "/agency/sold_vehicles", to: "agency#get_sold_vehicles" #done
  get "/distributor/sold_vehicles", to: "distributor#get_sold_vehicles" #done
  get "/agency/booked_vehicles", to: "agency#get_booked_vehicles" #done
  get "/distributor/booked_vehicles", to: "distributor#get_booked_vehicles" #done
  get "/salesperson/sold_vehicles", to: "salesperson#get_sold_vehicles" #dev done, to test
  get "/salesperson/booked_vehicles", to: "salesperson#get_booked_vehicles" #dev done, to test

  # get "/buyers", to: "buyer#get_buyers" #TO-DO
  # get "/buyers/:buyer_id", to: "buyer#get_buyer" #TO-DO
  # patch "/buyer/:buyer_id/edit", to: "buyer#edit" #TO-DO

  post "/logout", to: "authentication#logout" #TO-DO
end

#TO-DO Logout routes
