require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    it "import a csv file" do
      @file = fixture_file_upload("data.csv", "csv")
      post :create, params: {user: {file: @file}}, format: :json
      expect(response.body).to eql '["Muhammad was successfully saved",'\
                                '"Change 1 charater of Maria Turing\'s password",'\
                               '"Change 4 charaters of Isabella\'s password",'\
                               '"Change 5 charaters of Axel\'s password"]'
    end
  end
end
