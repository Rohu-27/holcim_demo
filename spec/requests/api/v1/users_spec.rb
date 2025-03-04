require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/login' do
    post 'User Login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "password123" }
        },
        required: %w[email password]
      }

      response '200', 'Login successful' do
        schema type: :object,
               properties: {
                 token: { type: :string, example: "your.jwt.token.here" }
               }
        
        run_test!
      end

      response '401', 'Invalid credentials' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: "Invalid Email or Password" }
               }

        run_test!
      end
    end
  end
  path '/api/v1/users' do
    get 'Retrieves all users' do
      tags 'Users'
      security [{ BearerAuth: [] }]
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Users per page'

      response '200', 'Users list retrieved successfully' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/User' }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     status: { type: :string },
                     total_users: { type: :integer },
                     current_page: { type: :integer }
                   }
                 }
               }

        run_test!
      end
    end

    post 'Creates a user' do
      tags 'Users'
      security [{ BearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          role: { type: :string }
        },
        required: %w[email password role]
      }

      response '201', 'User created successfully' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' },
                 status: { type: :string }
               }

        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'User ID'

    get 'Retrieves a user' do
      tags 'Users'
      security [{ BearerAuth: [] }]
      produces 'application/json'

      response '200', 'User found' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' },
                 status: { type: :string }
               }

        run_test!
      end

      response '404', 'User not found' do
        run_test!
      end
    end

    put 'Updates a user' do
      tags 'Users'
      security [{ BearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          role: { type: :string }
        }
      }

      response '200', 'User updated successfully' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' },
                 status: { type: :string }
               }

        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      security [{ BearerAuth: [] }]
      produces 'application/json'

      response '204', 'User deleted successfully' do
        run_test!
      end

      response '404', 'User not found' do
        run_test!
      end
    end
  end
end
