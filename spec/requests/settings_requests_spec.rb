describe 'Settings requests', type: :request do
  describe 'layout' do
    it 'use default application layout' do
      get '/settings'
      expect(response).to be_successful
      expect(response).to render_template(layout: 'application')
    end

    it 'use custom layout' do
      change_layout('admin')
      get '/settings'
      expect(response).to be_successful
      expect(response).to render_template(layout: 'admin')
      change_layout('application')
    end
  end

  begin 'Helper methods'
    def change_layout(layout_name)
      ENV['LAYOUT_NAME'] = layout_name
    end
  end
end
