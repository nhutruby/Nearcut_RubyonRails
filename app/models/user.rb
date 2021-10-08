# typed: true
# frozen_string_literal: true

require 'csv'
require 'sorbet-runtime'
# User Model
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  include Kernel
  extend T::Sig

  field :name, type: String
  field :password, type: String

  # Validates
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :password, presence: true
  validates :password, length: { minimum: 10, maximum: 16 }
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./,
                                 message: 'must include at least'\
                               ' one lowercase letter,'\
                               ' one uppercase letter,'\
                               ' and one digit' }
  # Index
  index({ name: 1 }, { unique: true })

  def self.import(file)
    results = []
    CSV.foreach(file.path, headers: true) do |i|
      next if !i['name'].present? || !i['password'].present?

      c_strong_password = check_strong_password(i['password'].strip)
      results << upload_results(c_strong_password, i['name'].strip, i['password'].strip)
    end
    results
  rescue CSV::MalformedCSVError => e
    puts e.message
  end

  def self.upload_results(check_strong_password, name, password)
    if check_strong_password.zero?
      user = User.create_with(password: password).find_or_create_by(name: name)
      if user.save
        "#{name} was successfully saved"
      else
        "#{name}: #{user.errors.full_messages.join('. ')}"
      end
    else
      "Change #{check_strong_password} #{'charater'.pluralize(check_strong_password)} of #{name}'s password"
    end
  end

  sig { params(str: String).returns(Integer) }
  def self.check_length(str)
    check = 0
    str_length = str.length
    check = 10 - str_length if str_length < 10
    check
  end

  sig { params(str: String).returns(Integer) }
  def self.check_three_characters(str)
    return 0 if str.length < 3

    check = 0
    c = str[0]
    n = 1
    T.must(str[1..]).each_char do |i|
      if i == c
        n += 1
      else
        check += n / 3
        c = i
        n = 1
      end
    end
    check += n / 3
    check
  end

  sig { params(str: String).returns(Integer) }
  def self.check_at_least_one(str)
    check = 0
    check += 1 if /[[:upper:]]/.match?(str) == false
    check += 1 if /[[:lower:]]/.match?(str) == false
    check += 1 if /[[:digit:]]/.match?(str) == false
    check
  end

  sig { params(str: String).returns(Integer) }
  def self.check_strong_password(str)
    sum = check_length(str) + check_three_characters(str)
    c_at_least_one = check_at_least_one(str)
    [sum, c_at_least_one].max
  end
end
