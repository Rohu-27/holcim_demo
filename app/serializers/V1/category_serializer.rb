class V1::CategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :created_at, :updated_at ,:ticket_type, :sub_categories
    has_many :sub_categories, serializer: V1::SubCategorySerializer

    def sub_categories
      object.sub_categories
    end
end