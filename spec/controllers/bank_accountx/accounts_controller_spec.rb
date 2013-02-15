require 'spec_helper'

module BankAccountx
  describe AccountsController do
    
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
    end
  
    render_views
  
    describe "GET 'index'" do
      it "should index bank account for users with right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        acct = FactoryGirl.create(:account, :active => true, :last_updated_by_id => u.id)
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'index', {:use_route => :bank_accountx}
        response.should be_success
        assigns(:accounts).should eq([acct])
      end
      
      it "should index all for users with index and create rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'index')
        ua1 = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ur1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua1.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        acct = FactoryGirl.create(:account, :active => true, :last_updated_by_id => u.id)
        acct1 = FactoryGirl.create(:account, :account_num => 'a new num', :active => false, :last_updated_by_id => u.id)
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'index', {:use_route => :bank_accountx}
        response.should be_success
        assigns(:accounts).should eq([acct1, acct])
      end
      
      it "should reject users without rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'unknownindex')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        acct = FactoryGirl.create(:account, :active => true, :last_updated_by_id => u.id)
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'index', {:use_route => :bank_accountx}
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")         
      end
    end
  
    describe "GET 'new'" do
      it "returns http success for user with create action rights" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :bank_accountx}
        response.should be_success
      end
      
      it "should reject for users without create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        get 'new', {:use_route => :bank_accountx}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")       
      end
    end
  
    describe "GET 'create'" do
      it "should save for user with create right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate = FactoryGirl.attributes_for(:account, :last_updated_by_id => u.id)
        get 'create', {:use_route => :bank_accountx, :account => cate}
        response.should redirect_to accounts_path #URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Customer Status Category Saved!")
      end
      
      it "should render new if there is data error" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'create')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate = FactoryGirl.attributes_for(:account, :account_name => nil, :last_updated_by_id => u.id)
        get 'create', {:use_route => :bank_accountx, :account => cate}
        response.should render_template('new')        
      end
    end
  
    describe "GET 'edit'" do
      it "should edit for users with proper right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate = FactoryGirl.create(:account)
        get 'edit', {:use_route => :bank_accountx, :id => cate.id}
        response.should be_success
      end
      
      it "should redirect for users without proper right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'index')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate = FactoryGirl.create(:account, :last_updated_by_id => u.id)
        get 'edit', {:use_route => :bank_accountx, :id => cate.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    describe "GET 'update'" do
      it "should update for users with update right" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate = FactoryGirl.create(:account, :last_updated_by_id => u.id)
        get 'update', {:use_route => :bank_accountx, :id => cate.id, :account => {:account_name => 'newnew name'}}
        response.should redirect_to URI.escape(accounts_path)
        #response.should render_template('edit')
      end
      
      it "should render edit if data error" do
        z = FactoryGirl.create(:zone, :zone_name => 'hq')
        type = FactoryGirl.create(:group_type, :name => 'employee')
        ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
        ua = FactoryGirl.create(:sys_action_on_table, :table_name => 'bank_accountx_accounts', :action => 'update')
        ur = FactoryGirl.create(:sys_user_right, :sys_user_group_id => ug.id, :sys_action_on_table_id => ua.id)
        ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_id] = u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(u.id)
        cate = FactoryGirl.create(:account, :last_updated_by_id => u.id)
        get 'update', {:use_route => :bank_accountx, :id => cate.id, :account => {:account_name => ''}}
        response.should render_template('edit')        
      end
    end
  
  end
end
