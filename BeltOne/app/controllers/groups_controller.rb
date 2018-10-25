class GroupsController < ApplicationController

  def create
  	u = User.find(session[:user_id])
  	u.groups.new(name: params[:group][:name], description: params[:group][:description], total_members:1, user_id: session[:user_id])
  	if u.save
  		puts "the new groups id #{u.groups.last.id}"
  		i = Signup.new(user_id: session[:user_id], group_id: u.groups.last.id)
  		if i.save
  			redirect_to '/groups', notice: "Group and join successfully created"
  		else 
  			redirect_to '/groups', notice: "Failure to join group"
  		end
  	else   			
  		redirect_to '/groups', notice: "Failure to create group"
  	end
  end
  
  def index
  	@groups = Group.all
  end

  def show
  	@group = Group.find(params[:g_id])
  	@members = Signup.where(group_id: params[:g_id]) 
  	@signup = Signup.find_by(user_id:session[:user_id], group_id: @group.id)
  end

  def join
  	@joined = Signup.create(user_id:session[:user_id], group_id: params[:g_id])
  	@gop = Group.find(params[:g_id])
  	@gop.total_members += 1
  	@gop.save
  	redirect_to "/groups/#{params[:g_id]}", notice: "Successfully joined group"

  end

  def leave
  	s = Signup.find_by(user_id:session[:user_id], group_id: params[:g_id])
  	s.delete
  	@gop = Group.find(params[:g_id])
  	@gop.total_members -= 1
  	@gop.save
  	redirect_to "/groups/#{params[:g_id]}", notice: "Successfully left group"
  end

  def destroy
    g = Group.find(params[:g_id])
    sign = Signup.find_by(user_id: session[:user_id], group_id: g.id)
    sign.destroy if sign != nil
    g.destroy
    redirect_to "/groups", notice: "Successfully deleted group"
  end
end




