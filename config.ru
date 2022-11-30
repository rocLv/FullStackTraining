require 'erb'
require 'sqlite3'

# Model
# ActiveRecord
# ActiveModel
#
class User
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def self.all
    @users = []
    db = SQLite3::Database.new "toyapp.db"
    db.execute('select * from users where 1 = 1 limit 1;') do |row|
      @users << self.new(row[1], row[2])
    end
    @users
  end

  #method_missing
end

# resources :user
# GET /users
class UsersController
  def index
    @user = User.all[0]
    puts @user
    template = File.open("./index.html.erb").read
    template = ERB.new(template)
    template.result(binding)
  end
end

class Application
  def call(env)
    [ 200,
      {'Content-Type'=>'text/html'},
      [UsersController.new.index]
    ]
  end
end

run Application.new
