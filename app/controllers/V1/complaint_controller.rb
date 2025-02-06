class V1::ComplaintController < ApplicationController
  before_action :authenticate_request!
  before_action :set_time_zone
  before_action :get_complaint, only: %i[show update]

  def create
    begin
      if params[:photos].present? && params[:photos].size > 5
        render json: {data: "Can't have more than 5 attachments", status: "FAILURE"}, status: :unprocessable_entity
        return
      end
      ActiveRecord::Base.transaction do
        complaint = @current_user.complaint.new(complaints_param)
        complaint.status = 'New'
        if complaint.save
          if params[:album].present?
            album = complaint.create_album(albums_param)
            if params[:photos].present?
              params[:photos].map do |photo|
                uploaded_photo = MyUploader.upload(photo, :store)
                photo = album.photos.create(image: uploaded_photo)
                unless photo.persisted?
                  render json: {errors: photo.errors.full_messages, status: 'FAILURE'}, status: :unprocessable_entity
                  raise ActiveRecord::Rollback, "Error creating photo, #{photo.errors.full_messages.join(', ')}"
                end
              end
            end
          end
          render json: {data: V1::ComplaintSerializer.new(complaint, {context:{action:'create'}}), status: 'SUCCESS'}, status: :created
        else
          render json: {errors: complaint.errors.full_messages, status: 'FAILURE'}, status: :unprocessable_entity
        end
      end
    rescue => e
      render json: {message: e.message, status: 'FAILURE'}, status: :unprocessable_entity
    end
  end

  def index
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = 8
    complaints = fetch_complaints(@current_user.role, page, per_page)
    if complaints.empty?
      render json: {status: 'SUCCESS', message: "There are no complaints"}, status: :ok
    else
      total_count = complaints.size
      offset = (page - 1) * per_page
      complaints = complaints.limit(per_page).offset(offset)
      serialized_complaints = complaints.map { |complaint| V1::ComplaintSerializer.new(complaint, {context:{action:'index'}}) }
      render json: {status: 'SUCCESS', data: serialized_complaints, meta:{total_count: total_count, total_pages: (total_count / per_page.to_f).ceil, current_page: page}}, status: :ok
    end
  end

  def show
    if @complaint.nil?
      render json: {status: "FAILURE", data: @complaint.errors.full_messages}, status: :unprocessable_entity
    else
      render json: {status: "SUCCESS", data: V1::ComplaintSerializer.new(@complaint, {context:{action:'show'}})}
    end
  end

  def update
    if @complaint.nil?
      render json: {status: "FAILURE", data: complaint.errors.full_messages}, status: :unprocessable_entity
    else
      if @current_user.admin?
        @complaint.update(status: params[:status])
        render json: {status: "SUCCESS", message: "Status updated successfully"}, status: :ok
      else
        render json: {status: "FAILURE", message: "You don't have necessary permissions to change the status"}, status: :forbidden
      end
    end
  end

  private

  def complaints_param
    params.require(:complaint).permit(:category, :sub_category, :description)
  end

  def albums_param
    params.require(:album).permit(:title)
  end

  def fetch_complaints(role, page, per_page)
    type = params[:type]
    complaints = type == 'All' ? Complaint.all : Complaint.where("ticket_number LIKE ?", "%#{type}%")
    if role == 'user'
      complaints = complaints.where(user_id: @current_user.id)
    end
    status = params[:status]
    from = params[:from]
    to = params[:to]
    complaints = complaints.where(status: status) if status.present?
    complaints = complaints.where("created_at::text BETWEEN ? AND ?",  "#{from}", "#{to}") if from.present? and to.present?
    complaints
  end

  def get_complaint
    @complaint = Complaint.find(params[:id])
  end
end
