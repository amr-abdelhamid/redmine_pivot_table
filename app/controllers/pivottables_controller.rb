class PivottablesController < ApplicationController
  unloadable
  before_filter :find_project, :authorize, :only => :index

  helper :issues
  helper :queries
  include QueriesHelper
  helper :repositories
  include RepositoriesHelper
  helper :sort
  include SortHelper
  include IssuesHelper

  ISSUES_LIMIT = 10000

  def pivottables
  end

  def index
    @project = Project.find(params[:project_id])
    @language = current_language
    @language_js = "pivot." + current_language.to_s + ".js"
    @statuses = IssueStatus.sorted.collect{|s| [s.name] }

    if (params[:query_id])
      @query = Query.find(params[:query_id])
    end

    retrieve_query
    if (!@query.new_record? && @query.options[:pivot_config])
      pivot_config = @query.options[:pivot_config]
      pivot_config.each do |k, v|
        params[k] = v
      end
    end

    @rows = params[:rows] ? params[:rows].split(",") : nil
    @cols = params[:cols] ? params[:cols].split(",") : nil
    @aggregatorName = params[:aggregatorName]
    @vals = params[:attrdropdown] ? params[:attrdropdown].split(",") : nil
    @rendererName = params[:rendererName]

    @table = params[:table]

    params.delete("rows")
    params.delete("cols")
    params.delete("aggregatorName")
    params.delete("attrdropdown")
    params.delete("rendererName")

    if (params[:table] == "activity")
      @days = Setting.activity_days_default.to_i
      @with_subprojects = Setting.display_subprojects_issues?
      @activity = Redmine::Activity::Fetcher.new(User.current, :with_subprojects => @with_subprojects)
      @events = @activity.events(Date.today - @days, Date.today + 1)
    else
      @query.project = @project

      # Exclude description
      @query.available_columns.delete_if { |querycolumn| querycolumn.name == :description }

      if (params[:closed] == "1")
          @query.add_filter("status_id", "*", [''])
      end

      @query.project = nil
      @issues = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
                              :offset => 0,
                              :limit => ISSUES_LIMIT)
      @query.project = @project
    end
  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  end

  def new
    @project = Project.find(params[:project_id])
    retrieve_query
    @query.project = @project
    @query.name = ""
    @query.options[:pivot_config] = { :table => params[:table],
               :rows => params[:rows],
               :cols => params[:cols],
               :rendererName => params[:rendererName],
               :aggregatorName => params[:aggregatorName],
               :attrdropdown => params[:attrdropdown] }
  end

  def save
    @project = Project.find(params[:project_id])
    retrieve_query

    @query.user = User.current
    @query.project = params[:query_is_for_all] ? nil : @project
    @query.build_from_params(params)
    @query.column_names = nil if params[:default_columns]
    #@query.sort_criteria = params[:query] && params[:query][:sort_criteria]
    @query.name = params[:query] && params[:query][:name]
    if User.current.allowed_to?(:manage_public_queries, @query.project) || User.current.admin?
      @query.visibility = (params[:query] && params[:query][:visibility]) || IssueQuery::VISIBILITY_PRIVATE
      @query.role_ids = params[:query] && params[:query][:role_ids]
    else
      @query.visibility = IssueQuery::VISIBILITY_PRIVATE
    end

    config = params[:query][:options][:pivot_config]
    @query.options[:pivot_config] = { :table => config[:table],
               :rows => config[:rows],
               :cols => config[:cols],
               :rendererName => config[:rendererName],
               :aggregatorName => config[:aggregatorName],
               :attrdropdown => config[:attrdropdown] }

    if @query.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to project_pivottables_path(@project)
    else
      render :action => 'new', :layout => !request.xhr?
    end
  end
end
