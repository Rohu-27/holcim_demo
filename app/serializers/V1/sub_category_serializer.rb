class V1::SubCategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :created_at, :updated_at, :category_id
end