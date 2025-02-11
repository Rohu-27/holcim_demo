class CustomerTicket < ApplicationRecord
  audited
  acts_as_paranoid
  has_one :album, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :album, allow_destroy: true
  validates_associated :album
  validates_presence_of :category
  validates :ticket_number, presence: true

  def set_ticket_number(ticket_type)
    last_id = ActiveRecord::Base.connection.execute("SELECT nextval('ticket_number_seq')").first['nextval']
    self.ticket_number="#{ticket_type}-#{last_id.to_s.rjust(3,"0")}"
  end
end
