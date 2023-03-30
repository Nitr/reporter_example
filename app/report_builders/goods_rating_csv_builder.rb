require 'csv'

class GoodsRatingCsvBuilder
  def call(report)
    data = report.result

    csv = CSV.new(StringIO.new)
    csv << data.columns
    data.rows.each do |row|
        csv << row
    end
    csv.to_io
  end
end
