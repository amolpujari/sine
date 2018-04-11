class MarketingRequestsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_marketing_request, only: [:show, :edit, :update, :destroy, :accept, :reject, :reopen]

  def index
    MarketingRequest.mark_stale
    @marketing_requests = MarketingRequest.all
  end

  def show
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

    respond_to do |format|
      if @marketing_request.save
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
      params.require(:marketing_request).permit(:title, :description, documents_attributes: [:attachment, :_destroy, :id])
    end
end
