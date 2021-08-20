class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.integer :odoo_id
      t.string :name
      t.string :partner_id
      t.string :partner_name
      t.string :user_id
      t.string :user_name
      t.string :country_code
      t.string :state
      t.float :amount_total_signed
      t.string :payment_state
      t.string :invoice_date

      t.timestamps
    end
  end
end
