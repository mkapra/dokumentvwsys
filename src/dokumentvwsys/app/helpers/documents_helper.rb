module DocumentsHelper
  def get_filename(filename)
    if filename.include? '.pdf'
      filename
    else
      "#{filename}.pdf"
    end
  end

  def get_weeks
    weeks = []
    1.upto(4) {|i| weeks << ["#{i} #{I18n.t('week', count: i)} (#{I18n.l(Date.today + i.weeks)})", i]}

    weeks
  end
end
