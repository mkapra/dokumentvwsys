# frozen_string_literal: true

class DocumentsController < ApplicationController
  include AdministrationHelper
  include DocumentsHelper

  before_action :authenticate_user!
  before_action :set_document, only: %i[show edit update destroy]
  before_action :verify_admin_user, only: %i[all list]

  add_flash_types :errors

  def all
    @delete = true
    @documents = Document.all.order('user_id desc')
  end

  def list
    @delete = true
    @user = User.find(params[:id])
    @documents = @user.documents
  end

  def index
    @delete = false
    @documents = current_user.documents
  end

  def show
    @document = Document.find(params[:id])

    return redirect_to errors_not_found_path unless @document.user == current_user || current_user.admin?

    send_data(@document.pdf, type: 'application/pdf', filename: get_filename(@document.filename))
  end

  def new
    @document = Document.new
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

      if params[:user]
        user_string = params[:user]['user']
        first_name, last_name, birthdate =
          user_string.match(/(\w+) (\w+) \(((0?[1-9]|1[0-9]|2[0-9]|3[0-1])\.([0-2]?[1-9]|[1-3][01])\.\d{4})\)/).captures
        birthdate_obj = Date.strptime(birthdate, '%d.%m.%Y')
        user = User.find_by(first_name: first_name, last_name: last_name, birth: birthdate_obj)

        return redirect_to 'new_document_path', flash: { error: 'User not found' } unless user

        t.user = user
      end

      t.delete_at = Date.today + document_params[:delete_at].to_i.week
    end

    if @document.save
      redirect_to documents_path, notice: 'Document was created successfully'
    else
      render action: 'new', error: 'Error while creating document!'
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
  rescue ActiveRecord::RecordNotFound
    redirect_to :root
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:pdf, :delete_at)
  end
end
