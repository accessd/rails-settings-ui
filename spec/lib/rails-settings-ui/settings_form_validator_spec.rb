describe RailsSettingsUi::SettingsFormValidator do

  describe "#errors" do
    context 'integer' do
      it 'success' do
        expect_without_errors('limit' => '123')
      end

      it 'fail' do
        expect_with_error('limit' => 'asq')
      end
    end

    context 'float' do
      it 'success' do
        expect_without_errors('angle' => '30.5')
        expect_without_errors('angle' => '30')
      end

      it 'fail' do
        expect_with_error('angle' => 'asq')
      end
    end

    context 'ActiveSupport::Duration' do
      it 'success' do
        expect_without_errors('timer' => 5.hours.to_s)
      end

      it 'fail' do
        expect_with_error('timer' => 'one hour')
      end
    end

    context 'hash' do
      it 'success' do
        expect_without_errors('style' => sample_hash)
      end

      it 'fail' do
        expect_with_error('style' => 'wtf')
        expect_with_error('style' => '{test: 123}')
        expect_with_error('style' => "{\"border_color\"=>, \"block_color\"=>\"ffffff\"""}")
      end
    end
  end

  begin 'Helper methods'

    def expect_without_errors(settings)
      expect(errors(settings)).to be_empty
    end

    def expect_with_error(settings)
      expect(errors(settings)).to have_key(settings.keys.first.to_sym)
    end

    def errors(settings)
      build_validator(settings_form.merge(settings)).errors
    end

    def build_validator(settings)
      validator = described_class.new(
        Settings.defaults,
        settings
      )
    end

    def settings_form
      {
        'limit' => '123',
        'angle' => '0.5',
        'project_name' => 'qwe',
        'style' => sample_hash,
        'timer' => '1800'
      }
    end

    def sample_hash
      hash = {
        "border_color" => "e0e0e0",
        "block_color" => "ffffff",
        "title" => {
          "font" => "Tahoma",
          "size" => "12",
          "color" => "107821"
        }
      }
      JSON.generate hash
    end

  end

end
