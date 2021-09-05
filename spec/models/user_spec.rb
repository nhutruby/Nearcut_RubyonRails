# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject do
    described_class.new(name: "Muhammad",
      password: "QPFJWz1343439")
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Check Functions" do
    it "check_length" do
      check_length = User.check_length("Abc123")
      expect(check_length).to eql 4
      check_length = User.check_length("AAAAAAB1")
      expect(check_length).to eql 2
      check_length = User.check_length('$$$###@@@1111')
      expect(check_length).to eql 0
    end
    it "check_three_characters" do
      check_three_characters = User.check_three_characters("AAAAAA$B")
      expect(check_three_characters).to eql 2
      check_three_characters = User.check_three_characters("$$$$$$$$")
      expect(check_three_characters).to eql 2
      check_three_characters = User.check_three_characters('$$$###@@@1111')
      expect(check_three_characters).to eql 4
    end
    it "check at least one lowercase character, one uppercase character and one digit" do
      check_at_least_one = User.check_at_least_one("AAAAAA$B")
      expect(check_at_least_one).to eql 2
      check_at_least_one = User.check_at_least_one('$$$###@@@1111')
      expect(check_at_least_one).to eql 2
      check_at_least_one = User.check_at_least_one("$$$$$$$$")
      expect(check_at_least_one).to eql 3
    end
    it "check_strong_password" do
      check_strong_password = User.check_strong_password("AAAfk1swods")
      expect(check_strong_password).to eql 1
      check_strong_password = User.check_strong_password("Abc123")
      expect(check_strong_password).to eql 4
      check_strong_password = User.check_strong_password("000aaaBBBccccDDD")
      expect(check_strong_password).to eql 5
    end
  end

  describe "CSV Import" do
    before :each do
      @file = fixture_file_upload("data.csv", "csv")
    end

    context "when file is provided" do
      it "imports users" do
        results = User.import(@file)
        expect(results).to eql ["Muhammad was successfully saved",
          "Change 1 charater of Maria Turing's password",
          "Change 4 charaters of Isabella's password",
          "Change 5 charaters of Axel's password"]
      end
    end
  end
end
