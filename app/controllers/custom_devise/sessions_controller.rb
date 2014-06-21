class CustomDevise::SessionsController < Devise::SessionsController
  def display_parameters
    ap "Params: [Filtered]"
  end
end
