class MarketingRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_marketing_request, only: [:edit, :update, :destroy, :accept, :reject, :reopen]

  def index
    respond_to do |format|
      format.html { MarketingRequest.mark_stale }
      format.json { render json: MarketingRequestDatatable.new(view_context) }
    end
  end

  def show
    @marketing_request = MarketingRequest.where(id: params[:id]).
    eager_load(thread: [comments: [:documents]]).
    includes(:submitted_by).includes(:documents).all[0]
  end

  def new
    @marketing_request = MarketingRequest.new
  end

  def edit
  end

  def accept
    @marketing_request.workflow_state = :accepted
    @marketing_request.save
    render :show
  end

  def reject
    @marketing_request.workflow_state = :rejected
    @marketing_request.save
    render :show
  end

  def reopen
    @marketing_request.workflow_state = :reopened
    @marketing_request.save
    render :show
  end

  def create
    @marketing_request = MarketingRequest.new(marketing_request_params)
    @marketing_request.submitted_by = current_user
    @marketing_request.valid?

    unless marketing_request_params[:documents_attributes]
      @marketing_request.errors.add(:base, "File can't be blank")
    end

    respond_to do |format|
      if @marketing_request.errors.empty? &&  @marketing_request.save
        format.html { redirect_to @marketing_request, notice: 'Marketing request was successfully created.' }
        format.json { render :show, status: :created, location: @marketing_request }
      else
        format.html { render :new }
        format.json { render json: @marketing_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @marketing_request.update(marketing_request_params)
        format.html { redirect_to @marketing_request, notice: 'Marketing request was successfully updated.' }
        format.json { render :show, status: :ok, location: @marketing_request }
      else
        format.html { render :edit }
        format.json { render json: @marketing_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @marketing_request.destroy
    respond_to do |format|
      format.html { redirect_to marketing_requests_url, notice: 'Marketing request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_marketing_request
    @marketing_request = MarketingRequest.find(params[:id])
  end

  def marketing_request_params
    mrp = params.require(:marketing_request).permit(:title, :description, :priority, :watchers, documents_attributes: [:attachment, :_destroy, :id])

    h = mrp.to_h
    if h[:documents_attributes].present?
      h[:documents_attributes][0][:uploaded_by_id] = current_user.id
    end
    h
  end
end
