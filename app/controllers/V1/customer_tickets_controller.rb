class V1::CustomerTicketsController < ApplicationController
  before_action :authenticate_request!
  before_action :get_customer_ticket, only: %i[show update]

  def create
    begin
      if params[:photos].present? && params[:photos].size > 5
        render json: {data: "Can't have more than 5 attachments", status: "FAILURE"}, status: :unprocessable_entity
        return
      end
      ActiveRecord::Base.transaction do
        customer_ticket = @current_user.customer_tickets.new(customer_tickets_param)
        customer_ticket.status = 'New'
        if params[:type].nil? || !["CM","RQ"].include?(params[:type])
          render json: { message: "Invalid type. It must be 'CM' or 'RQ'.", status: "FAILURE" }, status: :unprocessable_entity
          return
        end
        customer_ticket.set_ticket_number(params[:type])
        unless customer_ticket.save
          render json: {errors: customer_ticket.errors.full_messages, status: 'FAILURE'}, status: :unprocessable_entity
          return
        end
        if params[:album].present?
          album = customer_ticket.create_album(albums_param)
          if params[:photos].present?
            params[:photos].map do |photo|
              resized_photo = Rszr::Image.load(photo.path)
              resized_photo.resize!(400, 300)
              file_extension = File.extname(photo.original_filename) || 'png'
              tmp_file = Tempfile.new([File.basename(photo.original_filename, file_extension), file_extension])
              resized_photo.save(tmp_file.path)
              tmp_file.rewind
              uploaded_photo = MyUploader.upload(tmp_file, :store)
              photo = album.photos.create(image: uploaded_photo)
              unless photo.persisted?
                render json: {errors: photo.errors.full_messages, status: 'FAILURE'}, status: :unprocessable_entity
                raise ActiveRecord::Rollback, "Error creating photo, #{photo.errors.full_messages.join(', ')}"
              end
            end
          end
        end
        render json: {data: V1::CustomerTicketSerializer.new(customer_ticket, {context:{action:'create'}}), status: 'SUCCESS'}, status: :created
      end
    rescue => e
      render json: {message: e.message, status: 'FAILURE'}, status: :unprocessable_entity
    end
  end

  def index
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = 8
    customer_tickets = fetch_customer_tickets(@current_user.role)
    total_count = customer_tickets.size
    offset = (page - 1) * per_page
    customer_tickets = customer_tickets.limit(per_page).offset(offset)
    if customer_tickets.empty?
      render json: {status: 'SUCCESS', message: "There are no customer_tickets"}, status: :ok
    else
      serialized_customer_tickets = customer_tickets.map { |customer_ticket| V1::CustomerTicketSerializer.new(customer_ticket, {context:{action:'index'}}) }
      render json: {status: 'SUCCESS', data: serialized_customer_tickets, meta:{total_count: total_count, total_pages: (total_count / per_page.to_f).ceil, current_page: page}}, status: :ok
    end
  end

  def show
    if @customer_ticket.nil?
      render json: {status: "FAILURE", data: @customer_ticket.errors.full_messages}, status: :unprocessable_entity
    else
      render json: {status: "SUCCESS", data: V1::CustomerTicketSerializer.new(@customer_ticket, {context:{action:'show'}})}
    end
  end

  def update
    if @customer_ticket.nil?
      render json: {status: "FAILURE", data: customer_ticket.errors.full_messages}, status: :unprocessable_entity
    else
      if @current_user.admin?
        @customer_ticket.update(customer_ticket_update_params)
        render json: {status: "SUCCESS", message: "Details updated successfully"}, status: :ok
      else
        render json: {status: "FAILURE", message: "You don't have necessary permissions to change the status"}, status: :forbidden
      end
    end
  end

  def search
    customer_ticket = CustomerTicket.find_by(ticket_number: params[:ticket_number].squish)
    if customer_ticket.nil?
      render json: {message: "No complaint exists for the given id", status: 'FAILURE'}, status: :unprocessable_entity
      return
    end
    render json: {status: "SUCCESS", data: V1::CustomerTicketSerializer.new(customer_ticket, {context:{action:'search'}})}, status: :ok
  end

  private

  def customer_tickets_param
    params.require(:customer_ticket).permit(:category, :sub_category, :description)
  end

  def albums_param
    params.require(:album).permit(:title)
  end

  def customer_ticket_update_params
    params.permit(:id, :status, :comment)
  end

  def fetch_customer_tickets(role)
    type = params[:type].present? ? params[:type] : 'All'
    customer_tickets = type == 'All' ? CustomerTicket.all : CustomerTicket.where("ticket_number LIKE ?", "%#{type}%")
    if role == 'user'
      customer_tickets = customer_tickets.where(user_id: @current_user.id)
    end
    status = params[:status]
    customer_tickets = customer_tickets.where(status: status) if status.present?
    from = params[:from]
    to = params[:to]
    if from.present? and to.present?
      from_date = Time.parse(from)
      to_date = Time.parse(to)
      customer_tickets = customer_tickets.where("created_at BETWEEN ? AND ?", from_date, to_date)
    end
    customer_tickets
  end

  def get_customer_ticket
    @customer_ticket = CustomerTicket.find(params[:id])
  end
  
end
