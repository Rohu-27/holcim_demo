require 'swagger_helper'

RSpec.describe 'api/v1/customer_tickets', type: :request do
  path '/api/v1/customer_tickets' do
    get 'Retrieves all customer tickets' do
      tags 'Customer Tickets'
      security [{ BearerAuth: [] }]
      produces 'application/json'
      
      parameter name: :customer_ticket_type, in: :query, type: :string, description: 'Type of the customer ticket'
      parameter name: :from, in: :query, type: :string, description: 'Start date for filtering tickets'
      parameter name: :to, in: :query, type: :string, description: 'End date for filtering tickets'
      parameter name: :status, in: :query, type: :string, description: 'Status of the customer ticket'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Tickets per page'

      response '200', 'Customer tickets retrieved successfully' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/CustomerTicket' }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     total_tickets: { type: :integer },
                     current_page: { type: :integer }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/customer_tickets/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Customer Ticket ID'

    get 'Retrieves a customer ticket' do
      tags 'Customer Tickets'
      security [{ BearerAuth: [] }]
      produces 'application/json'

      response '200', 'Customer ticket found' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/CustomerTicket' },
                 status: { type: :string }
               }

        run_test!
      end

      response '404', 'Customer ticket not found' do
        run_test!
      end
    end

    put 'Updates a customer ticket' do
      tags 'Customer Tickets'
      security [{ BearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :customer_ticket, in: :body, schema: {
        type: :object,
        properties: {
          category: { type: :string },
          sub_category: { type: :string },
          description: { type: :string }
        }
      }

      response '200', 'Customer ticket updated successfully' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/CustomerTicket' },
                 status: { type: :string }
               }

        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end
    end

    delete 'Deletes a customer ticket' do
      tags 'Customer Tickets'
      security [{ BearerAuth: [] }]
      produces 'application/json'

      response '204', 'Customer ticket deleted successfully' do
        run_test!
      end

      response '404', 'Customer ticket not found' do
        run_test!
      end
    end
  end
end
