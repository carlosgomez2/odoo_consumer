require "xmlrpc/client"
require "awesome_print"

namespace :odoo_api do
  desc "Fetch data from odoo"
  task fetch_invoice: :environment do
    puts "--- Fetching invoice from odoo ---"
    url = 'http://localhost:8069'
    db = 'odoo'
    username = 'carlosgomez@multiplica.com'
    password = 'P+vg9gx9sdu&.C@qM'

    common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
    # ap common.call('version')

    uid = common.call('authenticate', db, username, password, {})

    models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy
    invoice_model = 'account.move'
    invoice_access = models.execute_kw(db, uid, password, invoice_model,'check_access_rights', ['read'], {raise_exception: false})
    ap invoice_access

    if invoice_access
      invoice_ids = models.execute_kw(db, uid, password, invoice_model, 'search', [[["payment_state", "=", "paid"]]])
      
      invoices = models.execute_kw(db, uid, password, invoice_model, 'read', [invoice_ids], {fields: %w(id name partner_id user_id country_code state amount_total_signed payment_state invoice_date)})
      # ap invoices

      invoices.each do |invoice|
        ap invoice['id']
        i = Invoice.find_by(odoo_id: invoice['id'])
        if i.nil?
          registry = Invoice.create(
            odoo_id: invoice['id'],
            name: invoice['name'],
            partner_id: invoice['partner_id'][0],
            partner_name: invoice['partner_id'][1],
            user_id: invoice['user_id'][0],
            user_name: invoice['user_id'][1],
            country_code: invoice['country_code'],
            state: invoice['state'],
            amount_total_signed: invoice['amount_total_signed'],
            payment_state: invoice['payment_state'],
            invoice_date: invoice['invoice_date']
          )
          ap registry
        end
      end
    end
  end
end
