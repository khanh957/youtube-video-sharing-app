require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when creating a new user' do
    let(:email) { "email@example.com" }
    let(:password) { "password" }
    let(:user) { User.create!(email: email, password: password) }

    context "with valid data" do
      it "should successfully create a user" do
        expect(user.email).to eq("email@example.com")
        expect(user.valid_password?(password)).to be_truthy
      end
    end

    context "with an incorrect email format" do
      let(:email) { "example" }

      it "raises an error" do
        expect { user }.to raise_error(ActiveRecord::RecordInvalid)
        expect { user }.to raise_error("Validation failed: Email is invalid")
      end
    end

    context "with an existing email" do
      before { FactoryBot.create(:user) }

      it "raises an error" do
        expect { user }.to raise_error(ActiveRecord::RecordInvalid)
        expect { user }.to raise_error("Validation failed: Email has already been taken")
      end
    end

    context "with empty email" do
      let(:email) { "" }

      it "raises an error" do
        expect { user }.to raise_error(ActiveRecord::RecordInvalid)
        expect { user }.to raise_error("Validation failed: Email can't be blank")
      end
    end

    context "with empty password" do
      let(:password) { "" }

      it "raises an error" do
        expect { user }.to raise_error(ActiveRecord::RecordInvalid)
        expect { user }.to raise_error("Validation failed: Password can't be blank")
      end
    end

    context "with invalid password" do
      let(:password) { "123" }

      it "raises an error" do
        expect { user }.to raise_error(ActiveRecord::RecordInvalid)
        expect { user }.to raise_error("Validation failed: Password is too short (minimum is 6 characters)")
      end
    end
  end
end
