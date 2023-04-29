class DocsController < ApplicationController
  before_action :authenticate, only: [:index, :new, :edit, :create, :update, :destroy]

  def index
    @docs = Doc.all
  end

  def show
    @doc = Doc.find_by(slug: params[:slug])
  end

  def new
    @doc = Doc.new
  end

  def edit
    @doc = Doc.find_by(slug: params[:slug])
  end

  def create
    @doc = Doc.new(doc_params)
    @doc.slug = @doc.title.parameterize

    if @doc.save
      redirect_to @doc, notice: "doc was successfully created."
    else
      render :new
    end
  end

  def update
    @doc = Doc.find_by(slug: params[:slug])
    if @doc.update(doc_params)
      redirect_to @doc, notice: "doc was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @doc = Doc.find_by(slug: params[:slug])
    @doc.destroy
    redirect_to docs_url, notice: 'doc was successfully destroyed.'
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN_USERNAME"] && password == ENV["ADMIN_PASSWORD"]
    end
  end

  def doc_params
    params.require(:doc).permit(:title, :content)
  end
end
