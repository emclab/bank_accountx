# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account, :class => 'BankAccountx::Account' do
    account_name "chase checking"
    account_num "1235654"
    active true
    last_updated_by_id 1
    brief_note "here is the note"
    bank_name "chase"
  end
end
