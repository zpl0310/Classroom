
require 'sinatra'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/students.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :studentId, String
  property :email, String
end

DataMapper.finalize
DataMapper.auto_migrate!

configure do
  enable :sessions
  set :username, "li"
  set :password, "111"
end

get '/login' do
  slim :login
end

post '/login' do
  if params[:username] == settings.username
     params[:password] == settings.password
     session[:admin] = true
     redirect to ('/students')
  else
    slim :login
  end
end

get '/logout' do
 session.clear
 redirect to ('/login')
end


get '/students' do
  @students = Student.all
  @islogedin = session[:admin]
  slim :students
end

get '/students/new' do
  @islogedin = session[:admin]
  redirect to ('/login') unless @islogedin
  @student = Student.new
  slim :new_student
end

get '/students/:id' do
  @islogedin = session[:admin]
  redirect to ('/login') unless @islogedin
  @student = Student.get(params[:id])
  slim :show_student
end

get '/students/:id/edit' do
  @islogedin = session[:admin]
  redirect to ('/login') unless @islogedin
  @student = Student.get(params[:id])
  slim :edit_student
end

post '/students' do  
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  @islogedin = session[:admin]
  redirect to ('/login') unless @islogedin
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  @islogedin = session[:admin]
  redirect to ('/login') unless @islogedin
  Student.get(params[:id]).destroy
  redirect to('/students')
end
