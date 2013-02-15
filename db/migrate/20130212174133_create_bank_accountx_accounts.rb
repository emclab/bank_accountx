class CreateBankAccountxAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accountx_accounts do |t|
      t.string :account_name
      t.string :account_num
      t.boolean :active, :default => true
      t.integer :last_updated_by_id
      t.string :brief_note
      t.string :bank_name

      t.timestamps
    end
  end
end
