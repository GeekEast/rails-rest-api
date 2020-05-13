module Api
    module V1
        class ContactsController < ApplicationController
            def index
                @contacts = Contact.all
                render json: @contacts, status: :ok
            end


            def create
                @contact = Contact.create(contact_params)
                @contact.save()
                render json: @contact, status: :created
            end


            def destroy
                puts params
                @contact = Contact.where(id: params[:id]).first
                if @contact.destroy
                    head(:ok)
                else
                    head(:unprocessable_entity)
                end

            end

            def show
                @contact = Contact.find params[:id]
                render json: @contact, status: :ok
            end


            private 
            def contact_params
                # requires: must have else error
                # permit: filtering attributes
                params.require(:contact).permit(:first_name, :last_name, :email)
            end 
        end
    end
end


