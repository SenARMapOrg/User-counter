Rails.application.routes.draw do
  root "homes#index"

  get    "/redirect",                      to: "homes#redirect_user"
  get    "/redirect/control",              to: "homes#control",         as: :redirect_control
  post   "/redirect/control/names",        to: "homes#create_name",     as: :redirect_control_names
  delete "/redirect/control/names/:name",  to: "homes#destroy_name",    as: :redirect_control_name
  delete "/redirect/control/counters",     to: "homes#reset_counters",  as: :redirect_control_counters
end
