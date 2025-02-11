# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#   
#


statuses=["New","Resolved","Processing"]

statuses.each do |status_name|
    Status.find_or_create_by!(name:status_name)
end


# request Categories with subcategories
request_categories_with_subcategories = {
  "Delivery Requests" => ["Change Delivery Address", "Add Special Instructions"],
  "Product Order Requests" => ["Cancel Order", "Modify Order Details"],
  "Service Requests" => ["Upgrade Service Plan", "Request Service Information"],
  "Account Requests" => ["Request Invoice Copy", "Update Account Information"]
}

request_categories_with_subcategories.each do |category_name, sub_category_names|
  parent_category = Category.find_or_create_by!(name: category_name, ticket_type: "RQ", parent_id: nil)
  sub_category_names.each do |sub_category_name|
    Category.find_or_create_by!(name: sub_category_name, parent_id: parent_category.id)
  end
end


# Complaint Categories with subcategories
complaint_categories_with_subcategories = {
  "Delivery Issues" => ["Incorrect Product Received", "Poor Product Quality"],
  "Product Order Problems" => ["Missing Items in Order", "Wrong Size Delivered"],
  "Customer Service Issues" => ["Unhelpful Support", "Delayed Service Response"],
  "Account Billing Problems" => ["Incorrect Billing", "Failed Payment Processing"]
}

complaint_categories_with_subcategories.each do |category_name, sub_category_names|
  parent_category = Category.find_or_create_by!(name: category_name, ticket_type: "CM", parent_id: nil)
  sub_category_names.each do |sub_category_name|
    Category.find_or_create_by!(name: sub_category_name, parent_id: parent_category.id)
  end
end

puts "Categories and subcategories seeded successfully!"