require 'swagger_helper'

RSpec.describe '/api/v1/status', type: :request do
  path '/api/v1/status' do
    get 'Retrieves all statuses' do
      tags 'Statuses'  # This is for grouping purposes in Swagger UI
      description 'Fetches all available statuses'
      produces 'application/json'

      response '200', 'Statuses fetched successfully' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     },
                     required: ['id', 'name']
                   }
                 },
                 status: { type: :string }
               },
               required: ['data', 'status']

        run_test! do |response|
          # You can also add additional tests or checks here if needed
          expect(response.status).to eq(200)
          expect(response.body).to include('data')
          expect(response.body).to include('status')
        end
      end
    end
  end
end
