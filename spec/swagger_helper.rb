# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      }, 
      security: [{ BearerAuth: [] }],
      paths: {
        "/api/v1/customer_tickets" => {
          :post => {
            :summary => "Create a Customer Ticket",
            :description => "Allows users to create a new customer ticket with photo uploads",
            :operationId => "createCustomerTicket",
            :requestBody => {
              :required => true,
              :content => {
                "multipart/form-data" => {
                  :schema => {
                    :type => :object,
                    :properties => {
                      :customer_ticket_type => { :type => :string },
                      :category => { :type => :string, :example => "Bug Report" },
                      :sub_category => { :type => :string, :example => "UI Issue" },
                      :description => { :type => :string, :example => "The submit button is not working." },
                      :album => {
                        :type => :object,
                        :properties => {
                          :title => { :type => :string, :example => "My Album Title" }
                        }
                      },
                      :photos => {
                        :type => :array,
                          :items => {
                            :type => "string", # Specify file type here, it should be binary for image uploads
                            :format => "binary" # Indicate that it is a binary (file) upload
                          }
                      }
                    }
                  }
                }
              }
            },
            :responses => {
              201 => {
                :description => "Customer ticket created successfully",
                :content => {
                  "application/json" => {
                    :schema => { "$ref" => "#/components/schemas/CustomerTicket" }
                  }
                }
              }
            }
          }
        }
      },
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          BearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          User: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              email: { type: :string, example: "user@example.com" },
              role: { type: :string, example: "admin" }
            },
            required: %w[id email role]
          },
          Category: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: "Bug Report" },
              ticket_type: { type: :string, example: "CM" },
              parent_id: { type: :integer, example: 1, nullable: true }
            }
          },
          :CustomerTicket => {
            :type => :object,
            :properties => {
              :id => { :type => :integer, :example => 1 },
              :category => { :type => :string, :example => "Bug Report" },
              :sub_category => { :type => :string, :example => "UI Issue" },
              :description => { :type => :string, :example => "The submit button is not working." },
              :album =>{
                :type => :object,
                :properties => {
                  :title=>{:type => :string, :example => "title"},
                  :photos => {
                    :type => :array,
                    :items => {
                      :type => :string,
                      :format => :file
                    }
                  }
                }
              },
              :created_at => { :type => :string, :format => "date-time", :example => "2024-03-01T12:00:00Z" },
              :updated_at => { :type => :string, :format => "date-time", :example => "2024-03-02T14:00:00Z" }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
