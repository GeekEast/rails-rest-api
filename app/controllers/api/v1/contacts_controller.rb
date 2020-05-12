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


            private 
            def contact_params
                # what does this mean?
                params.require(:contact).permit(:first_name, :last_name, :email)
            end 
        end
    end
end


