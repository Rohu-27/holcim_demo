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


categories_with_subcategories = {
  "Delivery" => ["Incorrect Product", "Quality"],
  "Order Product" => ["Missing Item", "Wrong Size"],
  "Service" => ["Poor Customer Service", "Delayed Service"],
  "Accounts" => ["Billing Issue", "Payment Failure"]
}

categories_with_subcategories.each do |category_name,sub_category_names|
    category=Category.find_or_create_by!(name: category_name)

    sub_category_names.each do |sub_category_name|
        category.sub_categories.find_or_create_by!(name: sub_category_name)
    end
end

puts "Categories and subcategories seeded successfully!"
