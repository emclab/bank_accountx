module BankAccountx
  class Account < ActiveRecord::Base
    attr_accessible :account_name, :account_num, :bank_name, :brief_note, :active, :last_updated_by_id, :as => :role_new
    attr_accessible :account_name, :account_num, :bank_name, :brief_note, :active, :last_updated_by_id, :as => :role_update
    
    belongs_to :contract, :class_name => 'Contractx::Contract'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    
    validates_presence_of :account_name, :account_num, :bank_name
    validates :account_num, :uniqueness => {:case_sensitive => false}
  end
end
