module Reports
  class UserOrders < Reporter::Report
    set_form_class UserForm

    builder :xlsx do |report|
      result = report.result

      p = Axlsx::Package.new
      wb = p.workbook
      date_style = wb.styles.add_style :sz => 20, :format_code => 'dd-mm-yyyy'

      wb.add_worksheet(name: 'User Orders') do |sheet|
        sheet.add_row(['Start Date', report.form_object.start], style: [nil, date_style])
        sheet.add_row(['End Date', report.form_object.end], style: [nil, date_style])
        sheet.add_row([])
        sheet.add_row(result.columns)
        result.rows.each do |row|
          sheet.add_row(row)
        end
      end
      p.to_stream
    end

    def result
      where_clause = if form_object.user_id.present?
                       "orders.created_at >= :start AND orders.created_at <= :end AND user_id = :user_id"
                     else
                       "orders.created_at >= :start AND orders.created_at <= :end"
                     end

      query = <<-SQL
          SELECT users.id, SUM(orders.amount) AS amount
          FROM users LEFT JOIN orders ON users.id = orders.user_id
          WHERE #{where_clause}
          GROUP BY users.id
      SQL

      ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.sanitize_sql_for_conditions([query, form_object.attributes.symbolize_keys])
      )
    end
  end
end
