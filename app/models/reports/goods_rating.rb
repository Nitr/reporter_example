module Reports
  class GoodsRating < Reporter::Report
    builder :csv, builder_class: GoodsRatingCsvBuilder

    builder :xlsx do |report|
      result = report.result

      p = Axlsx::Package.new
      wb = p.workbook

      wb.add_worksheet(name: 'User Orders') do |sheet|
        sheet.add_row(result.columns)
        result.rows.each do |row|
          sheet.add_row(row)
        end
      end
      p.to_stream
    end

    def result
      query = <<-SQL
        SELECT orders.name, COUNT(orders.name) AS orders_count
        FROM orders
        GROUP BY orders.name
      SQL

      ActiveRecord::Base.connection.exec_query(query)
    end
  end
end
