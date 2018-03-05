require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:user_attributes) do
    {
      email: 'email@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  # This should return the minimal set of values that should be in the session
  let(:valid_session) { {} }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:valid_attributes) { { user: user_attributes } }
    let(:invalid_attributes) do
      valid_attributes[:user][:email] = nil
      valid_attributes
    end

    context 'with valid params' do
      before(:each) do
        post :create, params: valid_attributes, session: valid_session
      end

      it 'creates a new User' do
        user = User.where(email: valid_attributes[:user][:email]).first
        expect(user).to be
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "new" template)' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        post :create, params: invalid_attributes, session: valid_session
        expect(response).to be_success
      end
    end
  end
end
