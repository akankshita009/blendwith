ActiveAdmin.register User do
  index do
    selectable_column # adds a checkbox for each resource (index only)
    column :id
    column :email
    #column :current_sign_in_at
    #column :last_sign_in_at
    #column :current_sign_in_ip
    #column :last_sign_in_ip
    column :username
    column :first_name
    column :last_name
    #column :city
    #column :location
    #column :player_title
    #column :player_description
    column :uid
    column :provider
    column :player_token
    column :approved

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :first_name
      f.input :last_name
      f.input :approved
    end
    f.actions
  end

  filter :approved

  controller do

    def action_methods
      ['index', 'edit', 'update', 'destroy', 'show']
    end

    def update
      @user = User.find(params[:id])
      approved = @user.approved
      if @user.update_attributes(params[:user])
        if !approved && @user.approved
          #email
          Notifier.welcome(@user).deliver
        end
        redirect_to admin_user_path(@user)
      else
        render :edit
      end
    end
  end
end
