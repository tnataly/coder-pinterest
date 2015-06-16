require 'spec_helper'
RSpec.describe PinsController do
   
 # after(:all) do
 #   pin = Pin.find_by_slug("ruby-hard")
 #   if pin.present?
 #     pin.delete
 #   end    
 # end
let(:attr) do
        { :title => "Learn Rails", 
          :url => "New url",
          :text => "The new text",
          :slug => "ruby-hard",

           }
      end      

before (:all) do
     @pin = Pin.create(title: "Learn RUBY hard way", 
      url: "http://google.com", 
      text: "Some super text",
        slug: "ruby-hard",
        category_id: "ruby") 
end

before(:each) do
        put :update, :id => @pin.id, :pin => attr
        @pin.reload
end


 
      it 'updates a pin' do

        expect(@pin.title).to eql attr[:title] 
        expect(@pin.url).to eql attr[:url]
        expect(@pin.text).to eql attr[:text]
        expect(@pin.slug).to eql attr[:slug]
        expect(@pin.category).to eql attr[:category_id]
        puts "===================\n" + response.body

     end
    
      it 'redirects to the show view' do
          expect(response).to redirect_to(pin_path(assigns(:pin)))
      end

end