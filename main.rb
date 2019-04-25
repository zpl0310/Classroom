require 'sinatra'
require 'slim'
require 'sass'
require './student'

get('/styles.css'){ scss :styles }

get '/' do
  slim :home
end

get '/courseinfo' do
  @title = "About This Course"
  slim :courseinfo
end

get '/contact' do
  slim :contact
end

not_found do
  slim :not_found
end