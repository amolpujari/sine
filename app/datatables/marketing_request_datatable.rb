class MarketingRequestDatatable
  delegate :params, :link_to, :strip_tags, :local_time_ago, :current_user, to: :@view

  def initialize(view)
    @view = view
    prepare_data
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @fetch_marketing_requests_before_filter.count,
      iTotalDisplayRecords: @fetch_marketing_requests_after_filter.count,
      aaData: @data
    }
  end

  private

  def prepare_data
    @data ||= marketing_requests.map do |marketing_request|
      [
        marketing_request.id,

        %{#{link_to marketing_request.title, marketing_request}
        <p>#{strip_tags(marketing_request.description).to_s[0..199]}
        <br/>
        <span class="gray">Last update #{local_time_ago marketing_request.updated_at}</span>
        </p>
        }.html_safe,

        %{<strong class="priority">#{marketing_request.priority}</strong>},

        %{
          <span style="display:none;">#{marketing_request.created_at.to_i}</span>
          #{marketing_request.submitted_by}
          <br>
          #{local_time_ago marketing_request.created_at}
        }.html_safe,

        nil,

        %{<h5><span class="label pull-right label-default label-#{marketing_request.workflow_state}">
          #{marketing_request.workflow_state.humanize.upcase}</span></h5>
        }.html_safe,
        
        link_to('View <br/> <span class="glyphicon glyphicon-eye-open"></span>'.html_safe, marketing_request),

        ( marketing_request.complete? ? nil: link_to('Edit <br/> <span class="glyphicon glyphicon-pencil"></span>'.html_safe, @view.edit_marketing_request_path(marketing_request)))
      ]
    end
  end

  def marketing_requests
    @marketing_requests ||= fetch_marketing_requests
  end

  def fetch_marketing_requests
    marketing_requests = if current_user.user?
      MarketingRequest.where(submitted_by_id: current_user.id)
    else
      MarketingRequest
    end

    @fetch_marketing_requests_before_filter = marketing_requests

    if search.present?
      marketing_requests = marketing_requests.where("marketing_requests.title like '%#{search}%' ")
    end

    if state_filter.present?
      marketing_requests = marketing_requests.where(workflow_state: state_filter)
    end

    @fetch_marketing_requests_after_filter = marketing_requests

    marketing_requests.includes(:submitted_by).
      reorder("marketing_requests.#{sort_column} #{sort_direction}").
      page(page).per(per_page)
  end

  def search
    @search ||= params[:sSearch].to_s.strip
  end

  def state_filter
    @state_filter ||= params[:sSearch_4].present? ? params[:sSearch_4].to_s.strip.split(",") : []
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def columns
    @colunms ||= [:id, :title, :priority, :created_at, nil, :workflow_state, nil, nil]
  end

  def sort_column
    columns[params[:iSortCol_0].to_i] || :id
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end