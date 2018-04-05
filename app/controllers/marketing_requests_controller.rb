class MarketingRequestsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_marketing_request, only: [:show, :edit, :update, :destroy, :complete, :reopen]

  # GET /marketing_requests
  # GET /marketing_requests.json
  def index
    @marketing_requests = MarketingRequest.all
  end

  # GET /marketing_requests/1
  # GET /marketing_requests/1.json
  def show
  end

  # GET /marketing_requests/new
  def new
    @marketing_request = MarketingRequest.new
  end

  # GET /marketing_requests/1/edit
  def edit
  end

  # GET /marketing_requests/1/complete
  def complete
    @marketing_request.workflow_state = :complete
    @marketing_request.save
    render :show
  end

  # GET /marketing_requests/1/reopen
  def reopen
    @marketing_request.workflow_state = :open
    @marketing_request.save
    render :show
  end

  # POST /marketing_requests
  # POST /marketing_requests.json
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

  # PATCH/PUT /marketing_requests/1
  # PATCH/PUT /marketing_requests/1.json
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

  # DELETE /marketing_requests/1
  # DELETE /marketing_requests/1.json
  def destroy
    @marketing_request.destroy
    respond_to do |format|
      format.html { redirect_to marketing_requests_url, notice: 'Marketing request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketing_request
      @marketing_request = MarketingRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketing_request_params
      params.require(:marketing_request).permit(:title, :description)
    end
end
