# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'create' do
    params = {
      email: 'example@email.com',
      first_name: 'First',
      last_name: 'Last',
      password: 'password',
      password_confirmation: 'password'
    }

    post register_path, params: { user: params }

    assert_redirected_to root_path
  end
end
