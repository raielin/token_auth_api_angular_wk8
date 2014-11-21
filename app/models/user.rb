class User < ActiveRecord::Base
  belongs_to :title
  has_and_belongs_to_many :skills
  has_many :allocations

  # enum ties a numerical value in the database to named values that can be accessed in rails.
  # http://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html
  # You can access these like this:
  # user = User.first
  # user.employee!  # This sets the status to employee
  # user.role => "employee"
  # user.employee? => true
  enum role: [:admin, :employee]

  # this is a method is similar to has_many, etc.
  # which adds additional features/functions that we need.
  # comes from Rails' built-in token authentication module which adds methodsfor authentication
  # Meta programming: it's a method that adds more methods to our program.
  # Requires that we have a password digest attribute. Gives us the ability to set and authenticate
  # a 'b-crypt' password. It's an algorithm to create encryption for passwords and authenticating
  # against them. Requires 'bcrypt' gem - relies on it.
  # Now when we sent over a new user, they come with a password, has_secure_password will encrypt it
  # and set it as the password_digest.
  has_secure_password

  # Before creating a new user, we set the token.
  # before_create can be very helpful for various uses, i.e. validate, initialize something, send email, etc.
  # before_create, after_destroy, before_destroy, etc. are called lifecycle events/methods.
  before_create :set_token

  private
    def set_token
      return if token.present?
      self.token = generate_token
    end

    def generate_token
      # SecureRandom is a class or module, 'SecureRandom.uuid' will return a random 64-bit
      # long number, but it includes dash. Provides more secure random numbers than just Random.
      # It has some more complex logic in initializing its randomizor function. gsub is taking our
      # the dashes.
      SecureRandom.uuid.gsub(/\-/,'')
    end
end
