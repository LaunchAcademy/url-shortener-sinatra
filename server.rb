require "sinatra"
require "csv"
require "pry"

CSV_OPTIONS = { headers: true, col_sep: ";" }

def generate_short_url
  rand(36**5).to_s(36)
end

def urls
  result = []
  CSV.foreach("./public/urls.csv", CSV_OPTIONS) do |row|
    result << row.to_hash
  end
  result
end

get "/" do
  redirect to("/urls")
end

get "/urls" do
  erb :index, locals: { urls: urls }
end

get "/urls/new" do
  erb :url_form
end

post "/urls" do
  binding.pry
  long_url = params["long_url"]
  short_url = generate_short_url

  CSV.open("./public/urls.csv", "a", CSV_OPTIONS) do |csv|
    csv << [short_url, long_url]
  end

  redirect to("/urls")
end

get "/:short_url" do |short_url|
  url = urls.find { |url| url["short_url"] == short_url }
  redirect to(url["long_url"])
end
