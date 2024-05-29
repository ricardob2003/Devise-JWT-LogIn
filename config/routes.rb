  #Devise routes
Rails.application.routes.draw do
  devise_for :users,
    path: "",
    path_names: {
      sign_in: "sign_in",
      sign_out: "sign_out",
      password: "password",
    }, controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
    }
end 