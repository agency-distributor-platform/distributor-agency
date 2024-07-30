Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post "/register", to: "authentication#register" #done
  post "/login", to: "authentication#login" #done
  get "/agencies", to: "pre_login#list_agencies" #done, pagination-done
  get "/distributors", to: "pre_login#list_distributors" #done, pagination-done
  get "/search_agencies", to: "pre_login#search_agencies" #done, pagination-done
  get "/search_distributors", to: "pre_login#search_distributors" #done, pagination-done
  get "/search_salespersons", to: "pre_login#search_salespersons" #TO-DO
  patch "/agency/edit", to: "agency#edit" #done #user can only edit it's own agency

  post "/vehicle_model/create", to: "vehicle_model#create" #done
  patch "/vehicle_model/:id", to: "vehicle_model#edit" #done
  get "/vehicle_model/search", to: "vehicle_model#search" #done
  get "/vehicle_model/:id", to: "vehicle_model#show" #done
  get "/vehicle_models", to: "vehicle_model#list" #done, pagination-done
  delete "/vehicle_model/:id", to: "vehicle_model#delete" #done

  get "/agency/distributors", to: "agency#get_distributors" #done, pagination-already
  patch "/distributor/agency_linking", to: "distributor#agency_linking" #done

  patch "/distributor/edit", to: "distributor#edit" #done
  patch "/salesperson/edit", to: "salesperson#edit" #done

  get "/current_user_details", to: "user#current_user_details" #done
  get "/user/:user_id", to: "user#user_details" #done

  get "/statuses", to: "item#statuses" #done
  put "/vehicle", to: "vehicles#create_or_edit_vehicle_details" #done
  patch "/vehicle/:vehicle_id/assign_vehicle", to: "vehicles#assign_vehicle" #done
  get "/vehicles", to: "vehicles#get_vehicles" #done, pagination-done
  get "/vehicles/:vehicle_id", to: "vehicles#get_vehicle_details" #done
  delete "/vehicle/:vehicle_id", to: "vehicles#delete" #done
  get "/vehicle/:vehicle_id/photos", to: "vehicles#photos"
  put "/vehicles/:transaction_type", to: "vehicles#transact_vehicle" #done #downpayment/partial sales also handled in this api #buyer information maybe created here
  put "/distributor_share", to: "item#add_or_edit_distributor_share" #done
  put "/salesperson_share", to: "item#add_or_edit_salesperson_share" #done
  get "/vehicles/:vehicle_id/transactions", to: "vehicles#get_vehicle_transactions" #done, pagination-done
  patch "/edit_transaction/:transaction_id", to: "item#edit_transaction" #TO-DO #transaction record, as well as transaction details

  get "/agency/sold_vehicles", to: "agency#get_sold_vehicles" #done, pagination-done
  get "/distributor/sold_vehicles", to: "distributor#get_sold_vehicles" #done, pagination-done
  get "/agency/booked_vehicles", to: "agency#get_booked_vehicles" #done, pagination-done
  get "/distributor/booked_vehicles", to: "distributor#get_booked_vehicles" #done, pagination-done
  get "/salesperson/sold_vehicles", to: "salesperson#get_sold_vehicles" #dev done, to test
  get "/salesperson/booked_vehicles", to: "salesperson#get_booked_vehicles" #dev done, to test


  get "/total_earnings", to: "item#earnings"
  # get "/vehicle/personal_vehicle_transactions" #-> Bookings and sellings
  get "/buyers", to: "buyer#get_buyers" #pagination-done
  get "/buyers/:buyer_id", to: "buyer#get_buyer"
  patch "/buyer/:buyer_id/edit", to: "buyer#edit"
  patch "/change_password", to: "authentication#change_password"

  get "/inquiries", to: "inquiry#list" #, pagination-done
  post "/inquiry", to: "inquiry#create"
  post "/refer", to: "salesperson#create_referral"

  delete "/logout", to: "authentication#logout"
  # new routes
  #bulk upload template
  namespace "bulk" do
    post "upload/vehicle_details", to: "upload#vehicle_details"
    get "upload/vehicle_details/template", to: "upload#vehicle_details_template"
  end

  resources :add_ons
  post "/vehicles/filter", to: "vehicles#filter_results"
  #testing
  get "/test", to: "test#hello"
  resources :contact_us
  put "/contract/generate", to: "contract#generate_contract"
  get "/contract/download/docx", to: "contract#download_as_docx"
  get "/contract/download/pdf", to: "contract#download_as_pdf"

  #add routes to raise a linking request from salesperson to agency
  post "/salesperson_linking_request", to: "salesperson#raise_salesperson_linking_request"
  #add routes to list all linking requests for an agency
  get "/salesperson_linking_requests", to: "agency#list_salesperson_linking_requests"
  #add routes to approve a linking request from salesperson to agency
  patch "/approve_salesperson_linking_request", to: "agency#approve_salesperson_linking_request"
end



#TO-DO Logout routes
