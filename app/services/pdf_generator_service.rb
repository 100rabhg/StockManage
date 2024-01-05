class PdfGeneratorService
    MONTSERRAT_FONT_PATH = 'app/assets/stylesheets/Montserrat-Regular.ttf'
    MONTSERRAT_BOLD_FONT_PATH = 'app/assets/stylesheets/Montserrat-Bold.ttf'
    def initialize
      @pdf = Prawn::Document.new
      @document_width = @pdf.bounds.width # width fo the document
      @pdf.font_families.update(
        'montserrat' => {
          normal: MONTSERRAT_FONT_PATH, # Path to the normal (regular) font style
          bold: MONTSERRAT_BOLD_FONT_PATH # Path to the bold font style (if applicable)
        }
      )
      @pdf.font('montserrat')
    end

    def mid_section(bill_to)

      mid_section_data = [['Biled To', 'Date Issued', 'Amount Due'],
                [
                  "#{bill_to.name} \n #{bill_to.address} \n #{bill_to.phone_number}",
                  Date.today.strftime('%d %b %y'),
                  ActionController::Base.helpers.number_to_currency(bill_to.balance, unit: '₹')
                ]]
     
      mid_section_options = {
        width: @document_width,
        row_colors: ['ffffff'],
        header: true,
        cell_style: {
          border_width: 0,
          padding: [15, 0, 0, 15]
        }
      }
     
      @pdf.table(mid_section_data, mid_section_options) do |table|
        table.row(0).text_color = '005bd3'
        table.row(0).size = 12
        table.row(0).font_style = :bold
        table.row(1).text_color = '000000'
        table.row(-1).padding_bottom = 15
      end
    end

    def supplier_section(supplier)
      report_data = [['Orders Date', 'Deliver Date', 'Price']]
      
      buy_order_total = 0
      report_data += supplier.buy_orders.map do |buy_order|
        buy_order_total += buy_order.total_price
        [
          buy_order.order_date.strftime('%d %b %y'),
          buy_order.delivery_date.strftime('%d %b %y'),
          ActionController::Base.helpers.number_to_currency(buy_order.total_price, unit: '₹')
        ]
      end

      report_data_options = {
        width: @document_width,
        row_colors: ['ffffff'],
        header: true,
        cell_style: {
          border_width: 1,
          borders: [:bottom],
          border_color: '888892',
          padding: [15, 0, 0, 15],
        }
      }

      @pdf.table(report_data, report_data_options) do |table|
        table.row(0).borders = [:top]
        table.row(0).border_color = '005bd3'
        table.row(0).border_width = 2
        table.row(0).text_color = '005bd3'
        table.row(0).font_style = :bold
        table.row(0).size = 12
        table.row(1).borders = [:top, :bottom]
        table.row(0).padding_bottom = 15
        table.row(-1).padding_bottom = 15
      end
      total_option = {
        width: @document_width/3,
        position: :right,
        cell_style: {
          border_width: 0,
          padding_top: 15,
        }
      }
      table = @pdf.table [['Total', ActionController::Base.helpers.number_to_currency(buy_order_total, unit: '₹')]], total_option
      table.row(-1).padding_bottom = 15

      return if supplier.supplier_tranctions.where(buy_order_id: nil).count.zero?

      report_data = [['Amount Payed', 'Date']]
      
      total_payed = 0
      report_data += supplier.supplier_tranctions.where(buy_order_id: nil).map do |tranction|
        total_payed += tranction.debit_amount
        [
          ActionController::Base.helpers.number_to_currency(tranction.debit_amount, unit: '₹'),
          tranction.tranction_date.strftime('%d %b %y'),
        ]
      end

      @pdf.table(report_data, report_data_options) do |table|
        table.row(0).borders = [:top]
        table.row(0).border_color = '005bd3'
        table.row(0).border_width = 2
        table.row(0).text_color = '005bd3'
        table.row(0).font_style = :bold
        table.row(0).size = 12
        table.row(1).borders = [:top, :bottom]
        table.row(0).padding_bottom = 15
        table.row(-1).padding_bottom = 15
      end

      table = @pdf.table [['Total Payed', ActionController::Base.helpers.number_to_currency(total_payed, unit: '₹')]], total_option
      table.row(-1).padding_bottom = 15

      @pdf.table [['Remaining Pay', ActionController::Base.helpers.number_to_currency(buy_order_total-total_payed, unit: '₹')]], total_option
    end

    def shopkeeper_section(shopkeeper)
      report_data = [['Sell Date', 'Price']]
      
      sell_order_total = 0
      report_data += shopkeeper.sell_orders.map do |sell_order|
        sell_order_total += sell_order.total_price
        [
          sell_order.sell_date.strftime('%d %b %y'),
          ActionController::Base.helpers.number_to_currency(sell_order.total_price, unit: '₹')
        ]
      end

      report_data_options = {
        width: @document_width,
        row_colors: ['ffffff'],
        header: true,
        cell_style: {
          border_width: 1,
          borders: [:bottom],
          border_color: '888892',
          padding: [15, 0, 0, 15],
        }
      }

      @pdf.table(report_data, report_data_options) do |table|
        table.row(0).borders = [:top]
        table.row(0).border_color = '005bd3'
        table.row(0).border_width = 2
        table.row(0).text_color = '005bd3'
        table.row(0).font_style = :bold
        table.row(0).size = 12
        table.row(1).borders = [:top, :bottom]
        table.row(0).padding_bottom = 15
        table.row(-1).padding_bottom = 15
      end
      total_option = {
        width: @document_width/3,
        position: :right,
        cell_style: {
          border_width: 0,
          padding_top: 15,
        }
      }
      table = @pdf.table [['Total', ActionController::Base.helpers.number_to_currency(sell_order_total, unit: '₹')]], total_option
      table.row(-1).padding_bottom = 15

      return if shopkeeper.shopkeeper_tranctions.where(sell_order_id: nil).count.zero?

      report_data = [['Deposit Amount', 'Date']]
      
      total_deposit = 0
      report_data += shopkeeper.shopkeeper_tranctions.where(sell_order_id: nil).map do |tranction|
        total_deposit += tranction.credit_amount
        [
          ActionController::Base.helpers.number_to_currency(tranction.credit_amount, unit: '₹'),
          tranction.tranction_date.strftime('%d %b %y'),
        ]
      end

      @pdf.table(report_data, report_data_options) do |table|
        table.row(0).borders = [:top]
        table.row(0).border_color = '005bd3'
        table.row(0).border_width = 2
        table.row(0).text_color = '005bd3'
        table.row(0).font_style = :bold
        table.row(0).size = 12
        table.row(1).borders = [:top, :bottom]
        table.row(0).padding_bottom = 15
        table.row(-1).padding_bottom = 15
      end

      table = @pdf.table [['Total Deposit', ActionController::Base.helpers.number_to_currency(total_deposit, unit: '₹')]], total_option
      table.row(-1).padding_bottom = 15

      @pdf.table [['Deposit Due', ActionController::Base.helpers.number_to_currency(sell_order_total - total_deposit, unit: '₹')]], total_option
    end

    def generate_pdf(bill_to)
      @pdf.text "INVOICE", size: 15, style: :bold
      mid_section(bill_to)
      if bill_to.class == Supplier
        supplier_section(bill_to)
      else
        shopkeeper_section(bill_to)
      end
      @pdf.render
    end
  end