require_dependency "bank_accountx/application_controller"

module BankAccountx
  class AccountsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    def index
      @title = 'Bank Accounts'
      if has_index_right?("bank_accountx_accounts")
        if has_create_right?("bank_accountx_accounts")
          @accounts = BankAccountx::Account.order("id DESC")
        else
          @accounts = BankAccountx::Account.where(:active => true).order("id DESC")
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")  
      end
    end
  
    def new
      @title = 'New Bank Account'
      if has_create_right?("bank_accountx_accounts")
        @account = BankAccountx::Account.new(params[:account], :as => :role_new)
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")  
      end       
    end
  
    def create
      if has_create_right?("bank_accountx_accounts")
        @account = BankAccountx::Account.new(params[:account], :as => :role_new)
        @account.last_updated_by_id = session[:user_id]
        if @account.save
          redirect_to accounts_path, :notice => "Bank Account Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
  
    def edit
      @title = 'Update Bank Account'
      if has_update_right?("bank_accountx_accounts")
        @account = BankAccountx::Account.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!") 
      end
    end
  
    def update
      if has_update_right?("bank_accountx_accounts")
        @account = BankAccountx::Account.find_by_id(params[:id])
        if @account.update_attributes(params[:account], :as => :role_update)
          redirect_to accounts_path, :notice => "Bank Account Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      end
    end
  end
end
