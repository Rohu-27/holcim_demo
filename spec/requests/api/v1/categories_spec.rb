require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/api/v1/categories' do

    get 'List Categories' do
      tags 'Categories'
      security [{ BearerAuth: [] }]
      produces 'application/json'
      
      parameter name: :parent_id, in: :query, type: :integer, required: false, example: 1, description: 'Parent category ID'
      parameter name: :ticket_type, in: :query, type: :string, required: false, example: 'CM', description: 'Category type (CM or RQ)'

      response '200', 'Categories retrieved' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'SUCCESS' },
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Category' }
                 }
               }
        run_test!
      end

      response '422', 'Invalid parameters' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Please provide either parent_id or type' },
                 status: { type: :string, example: 'FAILED' }
               }
        run_test!
      end
    end

    post 'Create Category' do
      tags 'Categories'
      security [{ BearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Bug Report" },
          ticket_type: { type: :string, example: "CM" },
          parent_id: { type: :integer, example: 1, nullable: true }
        }
      }

      response '201', 'Category created' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'SUCCESS' },
                 data: { '$ref' => '#/components/schemas/Category' }
               }
        run_test!
      end

      response '422', 'Invalid parameters' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Invalid type. It must be CM or RQ.' },
                 status: { type: :string, example: 'FAILED' }
               }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Unauthorized Person to access the Resource' },
                 status: { type: :string, example: 'UnAuthorized' }
               }
        run_test!
      end
    end
  end

  path '/api/v1/categories/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true, description: 'Category ID'

    get 'Retrieve a Category' do
      tags 'Categories'
      security [{ BearerAuth: [] }]
      produces 'application/json'

      response '200', 'Category found' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'SUCCESS' },
                 data: { '$ref' => '#/components/schemas/Category' }
               }
        run_test!
      end

      response '404', 'Category not found' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Category not found' },
                 status: { type: :string, example: 'NOT FOUND' }
               }
        run_test!
      end
    end

    put 'Update a Category' do
      tags 'Categories'
      security [{ BearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Updated Category" }
        }
      }

      response '200', 'Category updated' do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'SUCCESS' },
                 data: { '$ref' => '#/components/schemas/Category' }
               }
        run_test!
      end

      response '404', 'Category not found' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Category not found' },
                 status: { type: :string, example: 'NOT FOUND' }
               }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Unauthorized Person to access the Resource' },
                 status: { type: :string, example: 'UnAuthorized' }
               }
        run_test!
      end
    end

    delete 'Delete a Category' do
      tags 'Categories'
      security [{ BearerAuth: [] }]
      produces 'application/json'

      response '204', 'Category deleted' do
        run_test!
      end

      response '404', 'Category not found' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Category not found' },
                 status: { type: :string, example: 'NOT FOUND' }
               }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Unauthorized Person to access the Resource' },
                 status: { type: :string, example: 'UnAuthorized' }
               }
        run_test!
      end
    end
  end
end
