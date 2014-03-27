require 'minitest/autorun'

describe "my_cool_app::default" do

  it "has created /var/www/my_cool_app/index.html" do
    assert File.exists?("/var/www/my_cool_app/index.html")
  end

end