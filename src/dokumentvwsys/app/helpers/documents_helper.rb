module DocumentsHelper
  def get_filename(filename)
    if filename.include? '.pdf'
      filename
    else
      "#{filename}.pdf"
    end
  end
end
