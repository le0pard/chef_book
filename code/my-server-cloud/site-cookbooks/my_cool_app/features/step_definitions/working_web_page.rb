Given(/^I have provisioned the following infrastructure:$/) do |specification|
  @infrastructure = Leibniz.build(specification)
end

Given(/^I have run Chef$/) do
  @infrastructure.destroy
  @infrastructure.converge
end

Given(/^a url "(.*?)"$/) do |url|
  @host_header = url.split('/').last
end

When(/^a web user browses to the URL$/) do
  connection = Faraday.new(:url => "http://#{@infrastructure['localhost'].ip}", :headers => {'Host' => @host_header}) do |faraday|
    faraday.adapter Faraday.default_adapter
  end
  @page = connection.get('/').body
end

Then(/^the user should see "(.*?)"$/) do |content|
  expect(@page).to match /#{content}/
end

Then(/^cleanup test env$/) do
  @infrastructure.destroy if @infrastructure
end