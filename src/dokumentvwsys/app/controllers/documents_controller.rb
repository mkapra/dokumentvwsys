class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]
  add_flash_types :errors

  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])
    send_data(@document.pdf, :type => 'application/pdf', :filename => "#{@document.filename}.pdf", :disposition => 'inline')
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    if params[:document][:pdf] && (params[:document][:pdf].content_type != 'application/pdf')
      flash['error'] = 'Only PDF allowed for upload!'
      return redirect_to action: 'new'
    end

    @document = Document.new(document_params) do |t|
      if params[:document][:pdf]
        t.pdf = params[:document][:pdf].read
        t.filename = params[:document][:pdf].original_filename
      end
    end

    if @document.save
      redirect_to @document, notice: 'Document was created successfully'
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:pdf, :delete_at)
  end
end
