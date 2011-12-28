require 'spec_helper'

describe DashboardsController do
  it "should show a welcome message" do
    get "/dashboard"
    response.should have_selector("h1", :content => "Welcome")
  end

end
